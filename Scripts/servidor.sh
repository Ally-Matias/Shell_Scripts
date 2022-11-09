#!/bin/bash
nc -w 1 -l 34000 > info_cliente.txt
IPCLIENTE=$(cat info_cliente.txt | cut -f1 -d:)
PORTACLIENTE=$(cat info_cliente.txt | cut -f2 -d:)
ARQUIVO=$(cat info_cliente.txt | cut -f3 -d:)
rm info_cliente.txt
# Enviar o arquivo
cat ${ARQUIVO} | nc -w 1 ${IPCLIENTE} ${PORTACLIENTE}
