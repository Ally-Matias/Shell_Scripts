#!/bin/bash

# Você deve fazer um script chamado servidorWeb.sh que ao ser executado, cria uma instância na AWS e carrega um servidor web com uma
# página contendo seu nome e matrícula.

# Exemplo da execução:
#$ ./servidorWeb.sh nomedachave
#Criando servidor...
#Acesse: http://84.74.123.45/

# Ao colocar o endereço retornado pelo script no navegador, a página deve ser exibida.
# Observe que a única informação que o usuário deve fornecer é o nome da chave, criada previamente.
# O script deve funcionar em qualquer conta da AWS na região us-east-1. Observe os seguintes pontos:
# 1-Você pode anotar no script o ID da AMI (imagem) do Ubuntu Linux, que é o mesmo para todos os usuários.
# 2-Recupere a subrede do VPC padrão.
# 3-Crie um grupo de segurança liberando a porta 22 e 80, TCP.
# 4-Crie a instância.

CHAVE=$1

VPC=$(aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output text)

# criar grupo de segurança
aws ec2 create-security-group --group-name security --description "group security" --vpc-id ${VPC} > /dev/null  # /dev/null para n mostrar na tela

# recuperar o id do grupo de segurança
IDGROUP=$(aws ec2 describe-security-groups --group-names "security" --query "SecurityGroups[].GroupId[]" --output text)

# config do grupo de segurança
aws ec2 authorize-security-group-ingress --group-id ${IDGROUP} --protocol tcp --port 22 --cidr 0.0.0.0/0 > /dev/null
aws ec2 authorize-security-group-ingress --group-id ${IDGROUP} --protocol tcp --port 80 --cidr 0.0.0.0/0 > /dev/null

#script para recuperar a subnet
#SUBNET=$(aws ec2 describe-instances --query  "Reservations[].Instances[].SubnetId" --output text)
SUBNET=$(aws ec2 describe-subnets --query "Subnets[].SubnetId[]" --output text | tr "\t" "," | tr "," "\n" | sed '2,6d')

# criar a instancia e fazer a confg do engnx
INSTANCID=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name ${CHAVE} --subnet-id ${SUBNET} --security-group-ids ${IDGROUP} --user-data file://nginx.sh --query "Instances[].InstanceId" --output text)

# pegar o ip publico
IPPUB=$(aws ec2 describe-instances --query  "Reservations[].Instances[].PublicIpAddress" --instance-id ${INSTANCID} --output text)

# recuperar status da instancia
STATUS=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID} --output text | cut -f2)


while [ $(echo $STATUS) != "running" ];do  # loop para verificar se instancia esta run
     clear
     echo Criando servidor
     sleep 2
     clear
     echo Criando servidor.
     sleep 2
     clear
     echo Criando servidor..
     sleep 2
     clear
     echo Criando servidor...
     sleep 2
     STATUS=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID} --output text | cut -f2)
     sleep 2
done

# esperar um pouco para a instancia inicializar
sleep 37

#acessar a pagina pelo ip publico
echo "Acesse: http://${IPPUB}/"

