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
CREATE USER 'matias'@'%' IDENTIFIED BY 'senha123';
# garantir todos os privilegios
GRANT ALL PRIVILEGES ON scripts.* TO 'matias'@'%';

# entrar na tabela
#USE scripts;
# criar tabela
#CREATE TABLE teste ( teste INT );

EOF2

