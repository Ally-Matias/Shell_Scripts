#!/bin/bash

# Questão
# Escreva um script chamado alertaDiretorio.sh que recebe como parâmetros um
#valor inteiro que serve como intervalo de tempo em segundos e um nome que
#indica o caminho de um diretório.
# A cada intervalo, a quantidade de arquivos em um diretório será analisada.
#Caso a quantidade de arquivos se altere entre duas verificações, o script deve
#atualizar um arquivo chamado dirSensors.log com as seguintes informações:
# 1- A data que a alteração foi percebida.
# 2- Quantos arquivos existiam.
# 3- Quantos existem agora.
# 4- Quais foram alterados, adicionados ou removidos.

TEMPO=$1 # Tempo em segundos
CAMIN=$2 # Caminho inteiro do diretorio a ser monitorado

touch dirSensors.log
QUANT=$( ls ${CAMIN} | cat | wc -l > lixo2.txt | cat lixo2.txt ) # quantos arquivos
QUANT2=$( ls ${CAMIN} | cat | wc -l > lixo.txt | cat lixo.txt ) # quantos arquivos para fazer a comparação
TEMP2=$(ls ${CAMIN} | cat > arq2.txt) # colocar os nomes dos arquivos em um txt
TEMP=$(ls ${CAMIN} | cat > arq1.txt) # colocar os nomes dos arquivos em um txt para comparar tbm

while true;do
        if [ $(cat lixo.txt) = $(cat lixo2.txt) ];then # Se tiver o msm valor, quer dizer que n foi alterado
                sleep ${TEMPO} # Dormir
                QUANT2=$( ls ${CAMIN} | cat | wc -l > lixo.txt | cat lixo.txt ) # atualizar a variavel
                TEMP2=$(ls ${CAMIN} | cat > arq2.txt) # atualizar a variavel
        else
                sleep ${TEMPO} # Dormir
                if [ $(wc -l arq1.txt | cut -d " " -f1) -lt $(wc -l arq2.txt | cut -d " " -f1) ];then # Verificar qual valor é maior >
                        echo ["$(date +%d-%m-%Y)" "$(date +%H:%M:%S)"] Alteração\! "$(cat lixo2.txt)" \-\> "$(cat lixo.txt)"\. Adicio>
                else
                        echo ["$(date +%d-%m-%Y)" "$(date +%H:%M:%S)"] Alteração\! "$(cat lixo2.txt)" \-\> "$(cat lixo.txt)"\. Removi>
                fi
                QUANT=$( ls ${CAMIN} | cat | wc -l > lixo2.txt | cat lixo2.txt )
                TEMP=$(ls ${CAMIN} | cat > arq1.txt)
        fi
done
