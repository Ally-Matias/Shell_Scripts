#!/bin/bash

# Desenvolver o script latencia.sh. Esse script vai receber como parâmetro o nome de um arquivo de texto, contendo um endereço IP por linha.
# O script deve usar o comando ping para enviar dez pacotes ICMP para cada endereço do arquivo,
# Calculando o valor médio do tempo de resposta. Ao final, deve imprimir uma lista de IP ordenada
# Do menor para o maior tempo médio de resposta, informando além do endereço, o tempo de resposta médio.

arq=$1

# for no arquivo contendo todos os ip com um (-c 10) para pegar só 10 pacotes.
# depois mandei para um arq lixo(temporario) a linha contendo o ip e o AVG(encontramos essa informação na ultima linha quando finalizado o ping)
# fora do for, eu ordenei pelo avg usando o (sort -k 2n).
# Obs: se não tiver o AVG no lado do ip, é pq n deu para executar o ping, problema ao pegar os pacotes, n é erro do script.

for x in $(cat $arq)
do
ping $x -c 10 > ping.txt

echo $x $(grep "rtt" ping.txt | cut -d '/' -f5) >> lixo.txt

done

sort -k 2n lixo.txt > ping.txt

rm lixo.txt
cat ping.txt

rm ping.txt
