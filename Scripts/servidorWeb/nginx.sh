#!/bin/bash

# Configurando ngnix

sudo su
apt-get update
apt-get -y install nginx
systemctl start nginx
systemctl enable nginx

#anotações nginx

# mudando o index para mudar o conteudo da pagina

echo "Nome: Alliquison Matias.  Matricula: 508445" > /var/www/html/index.nginx-debian.html





# Outra versâo só que usando apache no lugar de ngnix

#!/bin/bash

#sudo apt update
#sudo apt -y install apache2
#sudo ufw allow 'Apache'
#sudo systemctl start apache2
#sudo mkdir /var/www/html
#sudo chown -R $USER:$USER /var/www/html
#sudo chmod -R 755 /var/www/html

#echo "Nome:Alliquison Matias da Silva" > /var/www/html/index.html
#echo "Matricula: 508445" >> /var/www/html/index.htm
