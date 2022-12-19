#!/bin/bash

apt-get update
apt-get install -y mysql-client

#O -e faz com que o carácter de newline seja interpretado.
echo -e "[client]\nuser=matias\npassword=senha123" > /root/.my.cnf
echo -e "[client]\nuser=matias\npassword=senha123" > /home/ubuntu/.my.cnf
# dentro dele vai ter
#[client]
#user=aluno
#password=senha123

#mysql -u aluno scripts -h 172.31.8.251 <<EOF2

echo -e "sudo mysql -u matias scripts -h 172.31.8.251<<EOF\nUSE scripts;\nCREATE TABLE Teste ( atividade INT );\nEOF\nrm /home/ubuntu/scripts.sh" > /home/ubuntu/scripts.sh
chmod +x /home/ubuntu/scripts.sh
cd /home/ubuntu
bash scripts.sh

#no comando acima contem isso aqui :
#USE scripts;  n precisa pois ele já entra direto no bd correto
#CREATE TABLE Teste ( atividade INT );
#EOF

