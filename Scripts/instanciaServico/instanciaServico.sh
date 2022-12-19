#!/bin/bash

# O script além de criar a máquina virtual, deve instalar um serviço nela que de 5 em 5 segundos colete informações do estado da
# máquina e exiba o resultado na página index.
# 1- O horário e data da coleta de informações.
# 2- Tempo que a máquina está ativa.
# 3- Carga média do sistema.
# 4- Quantidade de memória livre e ocupada.
# 5- Quantidade de bytes recebidos e enviados através da interface eth0.

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
INSTANCID=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name ${CHAVE} --subnet-id ${SUBNET} --security-group-ids ${IDGROUP} --user-data file://service.sh --query "Instances[].InstanceId" --output text)

# pegar o ip publico
IPPUB=$(aws ec2 describe-instances --query  "Reservations[].Instances[].PublicIpAddress" --instance-id ${INSTANCID} --output text)

# recuperar status da instancia
STATUS=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID} --output text | cut -f2)


while [ $(echo $STATUS) != "running" ];do  # loop para verificar se instancia esta run
     clear
     echo Criando servidor de Monitoramento
     sleep 2
     clear
     echo Criando servidor de Monitoramento.
     sleep 2
     clear
     echo Criando servidor de Monitoramento..
     sleep 2
     clear
     echo Criando servidor de Monitoramento...
     sleep 2
     STATUS=$(aws ec2 describe-instances --query  "Reservations[].Instances[].State" --instance-id ${INSTANCID} --output text | cut -f2)
     sleep 2
done

# esperar um pouco para a instancia inicializar
sleep 37

#acessar a pagina pelo ip publico
echo "Acesse: http://${IPPUB}/"
