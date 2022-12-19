#!/bin/bash

# O nome do script principal desta atividade é criarDuasInstancias.sh.
# Nesta questão, você deve começar criando um grupo de segurança com as seguintes características:
# 1- Aceitar conexões SSH (22/tcp) apenas a partir do IP visível da máquina que está executando o script.
# 2- Aceitar conexões HTTP (80/tcp) a partir da Internet.
# 3- Aceitar conexões MySQL (3306/tcp) a partir de outras máquinas no mesmo grupo de segurança.

#Com o grupo de segurança criado, o script deve criar uma primeira máquina virtual e realizar as seguintes ações:
# 1- Instalar o servidor MySQL.
# 2- Habilitar o acesso por todas as interfaces de rede da máquina.
# 3- Criar um banco de dados chamado scripts, usando usuário e senha para acesso remoto.

#Em seguida, informar na tela o IP Privado. Essa informação também é usada na próxima etapa.
#O script deve partir então para criar uma segunda instância. As seguintes ações devem ser realizadas na criação desse novo servidor:
# 1- Os pacotes cliente do MySQL deve ser instalados.
# 2- Uma conexão deve ser feita no servidor da primeira máquina.
# 3- No banco scripts, criar uma tabela chamada Teste com apenas um campo chamado atividade do tipo inteiro.


CHAVE=$1
USUARIO=$2
SENHA=$3

VPC=$(aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output text)

# criar grupo de segurança
aws ec2 create-security-group --group-name security --description "group security" --vpc-id ${VPC} > /dev/null

# recuperar o id do grupo de segurança
IDGROUP=$(aws ec2 describe-security-groups --group-names "security" --query "SecurityGroups[].GroupId[]" --output text)

#ip publico para conectar via ssh
#IPMAQUINA=$(echo "$(wget -qO- http://ipecho.net/plain)/32")
IPMAQUINA=$(echo "$(wget -qO- http://checkip.amazonaws.com/?_x_tr_sch=http&_x_tr_sl=auto&_x_tr_tl=pt&_x_tr_hl=pt-BR&_x_tr_pto=wapp)/32")

# config do grupo de segurança
aws ec2 authorize-security-group-ingress --group-id ${IDGROUP} --protocol tcp --port 22 --cidr ${IPMAQUINA} > /dev/null
aws ec2 authorize-security-group-ingress --group-id ${IDGROUP} --protocol tcp --port 80 --cidr 0.0.0.0/0 > /dev/null
# so permitir a comunicação se estiverem no mesmo grupo de segurança
aws ec2 authorize-security-group-ingress --group-id ${IDGROUP} --protocol tcp --port 3306 --source-group ${IDGROUP} > /dev/null

#script para recuperar a subnet
SUBNET=$(aws ec2 describe-subnets --query "Subnets[].SubnetId[]" --output text | tr "\t" "," | tr "," "\n" | sed '2,6d')


cat<<EOF>MySqlServer.sh
#!/bin/bash

apt-get update
apt-get install -y mysql-server
systemctl start mysql.service
systemctl enable mysql.service

#configurar o bind-address para 0.0.0.0/0 no mysql, para assim ele escutar qualquer ip
# é preciso estar em super usuario para alterar
#sed -i 's/bind-address               = 127.0.0.1/bind-address                = 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
#sed -i 's/mysqlx-bind-address        = 127.0.0.1/mysqlx-bind-address = 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

sed -i -r '31,32 s/([0-9]+)/0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql.service

# depois usar EOF para configurar e criar database

mysql<<EOF2

CREATE DATABASE scripts;
#passar a variavel do ip da maquina aqui
#CREATE USER 'aluno'@'1.1.1.1'
#CREATE USER 'aluno'@'localhost' user so pode fazer login se estiver logado na maquina, ou no lugar de localhost, criar as duas maquinas de uma vez e passar o ip dela no localhost

# % pode acesssar de qualquer servidor
CREATE USER '$(echo $USUARIO)'@'%' IDENTIFIED BY '$(echo $SENHA)';
# garantir todos os privilegios
GRANT ALL PRIVILEGES ON scripts.* TO '$(echo $USUARIO)'@'%';

# entrar na tabela
#USE scripts;
# criar tabela
#CREATE TABLE teste ( teste INT );

EOF2

EOF


# criar a instancia e fazer a confg do mysqlserver
INSTANCID=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name ${CHAVE} --subnet-id ${SUBNET} --security-group-ids ${IDGROUP} --user-data file://MySqlServer.sh --query "Instances[].InstanceId" --output text)

# pegar o ip publico
#IPPUB=$(aws ec2 describe-instances --query  "Reservations[].Instances[].PublicIpAddress" --instance-id ${INSTANCID} --output text)

# pegar ip privado
IPPRIV=$(aws ec2 describe-instances --query  "Reservations[].Instances[].PrivateIpAddress" --instance-id ${INSTANCID} --output text)

# recuperar status da instancia
STATUS=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID} --output text | cut -f2)

echo Criando servidor de Banco de Dados...
while [ $(echo $STATUS) != "running" ];do  # loop para verificar se instancia esta run
     sleep 2
     STATUS=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID} --output text | cut -f2)
done
# um tempo para inicializar tudo
sleep 30

echo "IP Privado do Banco de Dados: ${IPPRIV}"



#    SEGUNDA PARTE, CRIANDO SERVIDOR CLIENTE MYSQL



cat <<EOF> mysqlclient.sh
#!/bin/bash

apt-get update
apt-get install -y mysql-client

#O -e faz com que o carácter de newline seja interpretado.
echo -e "[client]\nuser=$(echo $USUARIO)\npassword=$(echo $SENHA)" > /root/.my.cnf
# dentro dele vai ter
#[client]
#user=aluno
#password=senha123

#mysql -u aluno scripts -h $(echo $IPPRIV) <<EOF2

echo -e "sudo mysql -u $(echo $USUARIO) scripts -h $(echo $IPPRIV)<<EOF\nUSE scripts;\nCREATE TABLE Teste ( atividade INT );\nEOF\nrm /home/ubuntu/scripts.sh" > /home/ubuntu/scripts.sh
chmod +x /home/ubuntu/scripts.sh
cd /home/ubuntu
bash scripts.sh

#no comando acima contem isso aqui :
#USE scripts;  n precisa pois ele já entra direto no bd correto
#CREATE TABLE Teste ( atividade INT );
#EOF

EOF

# criar a instancia e fazer a instalacao do mysql client
INSTANCID2=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name ${CHAVE} --subnet-id ${SUBNET} --security-group-ids ${IDGROUP} --user-data file://mysqlclient.sh --query "Instances[].InstanceId" --output text)

# pegar o ip da segunda instancia
IPPUB2=$(aws ec2 describe-instances --query  "Reservations[].Instances[].PublicIpAddress" --instance-id ${INSTANCID2} --output text)

# recuperar status da instancia
STATUS2=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID2} --output text | cut -f2)

echo " "
echo Criando servidor de Aplicação...
while [ $(echo $STATUS2) != "running" ];do  # loop para verificar se instancia esta run
     sleep 2
     STATUS2=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID2} --output text | cut -f2)
done
# um tempo para inicializar tudo
sleep 30

echo "IP Público do Servidor de Aplicação: ${IPPUB2}"






