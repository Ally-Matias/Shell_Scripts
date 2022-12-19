#!/bin/bash
# São do servidor.
IP=$1
PORTA=$2
ARQUIVO=$3
# É onde o servidor vai se conectar comigo.
MEUIP=$(hostname -I | awk ' {print $1}')
MINHAPORTA=33000
# Enviar meu IP, porta local e o nome do arquivo para o servidor
MENSAGEM=${MEUIP}:${MINHAPORTA}:${ARQUIVO}
echo "${MENSAGEM}" | nc -w 1 ${IP} ${PORTA}
# Receber o arquivo do servidor
nc -q 1 -l 33000 > ${ARQUIVO}.recebido
