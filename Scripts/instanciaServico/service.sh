#!/bin/bash

# Configurando ngnix

sudo su
apt-get update
apt-get -y install nginx
systemctl start nginx
systemctl enable nginx

# caminho para a pagina > /var/www/html/index.nginx-debian.html

timedatectl set-timezone America/Fortaleza        # pegar os dados de hora corretos

######

cat << EOF > script.sh    # criar script
#!/bin/bash
while true
do
   #$(date +%H:%M:%S-%D)   data e hora
   #$(uptime -p)           tempo da maquina
   #$(uptime)              carga media do sistema
   #$(free -h)             memoria livre e ocupada
   #$(cat /proc/net/dev)   bytes recebidos e enviados através da interface eth0
   #<li>                   lista
   #<br>                   pular linha
   echo "<li>Servidor ativo: "\$(date +%H:%M:%S-%D)"</li><br>" > /var/www/html/index.nginx-debian.html
   echo "<li>Tempo ativo: "\$(uptime -p)"</li><br>" >> /var/www/html/index.nginx-debian.html   # tr -s para tirar espaços
   echo "<li>Carga media do sistema: "\$(uptime | cut -d ' ' -f 12 | tr ',' ' ')"</li><br>" >> /var/www/html/index.nginx-debian.html
   echo "<li>Memoria livre: "\$(free -h | tail -n 2 | head -n 1 | tr -s ' ' | cut -d' ' -f 4)"</li><br>" >> /var/www/html/index.nginx-debian.html
   echo "<li>Memoria ocupada: "\$(free -h | tail -n 2 | head -n 1 | tr -s ' ' | cut -d' ' -f 3)"</li><br>" >> /var/www/html/index.nginx-debian.html
   echo "<li>Bytes recebidos atraves da interface eth0: "\$(cat /proc/net/dev | tr -s ' ' | grep eth0 | cut -d' ' -f 3)"</li><br>" >> /var/www/html/index.nginx-debian.html
   echo "<li>Bytes enviados atraves da interface eth0: "\$(cat /proc/net/dev | tr -s ' ' | grep eth0 | cut -d' ' -f 11)"</li><br>" >> /var/www/html/index.nginx-debian.html
   sleep 5
done
EOF

chmod +x script.sh
mv script.sh /usr/local/bin/   # movendo para local que quero

########

cat << EOF2 > servico.service   # criar servico

[Unit]
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/local/bin/script.sh

[Install]
WantedBy=multi-user.target
#Wantedby=default.target
EOF2

mv servico.service /etc/systemd/system  # movendo servico para o systemd para rodar
#chmod 644 /etc/systemd/system/servico.service

# OBS : quando interrompido a instancia e inicializada novamente, o ip pode mudar.

systemctl daemon-reload
systemctl enable servico.service
systemctl start servico.service
#systemctl reload servico.service
