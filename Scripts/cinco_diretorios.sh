#!/bin/bash

#QUESTÃO
# O nome do script será cinco_diretorios.sh. Ao ser executado, o script deve realizar as seguintes tarefas:
# 1 Criar um diretório chamado cinco.
# 2 Criar cinco subdiretórios cinco/dir1 até cinco/dir5.
# 3 Em cada subdiretório, faça quatro arquivos, arq1.txt até arq4.txt. O arquivo arq1.txt deve ter uma linha contendo apenas o
# dígito 1. O arquivo arq2.txt deve ter duas linhas, cada uma contendo o dígito 2.
# O arquivo arq3.txt deve ter três linhas, cada uma contendo o dígito 3.
# E por fim, O arquivo arq4.txt deve ter quatro linhas, cada uma contendo o dígito 4.
# Você não pode repetir chamadas ao mkdir 6 vezes e executar 20 comandos para criar os 20 arquivos.
# Você deve obrigatoriamente utilizar laços aninhados para criar a estrutura.

mkdir cinco
cd cinco
for x in {1..5};do  # Do 1 ao 5 pois são 5 diretorios
mkdir dir$[x]  # tbm exite essa maneira para criar diretorios em um msm (mkdir): mkdir -p {cinco/{dir1/,dir2/,dir3/,dir4/,dir5/}}
cd dir$[x]  # Dois for aninhados e um case para criar os arquivos e diretorios nos cantos corretos
for i in {1..4};do # Do 1 ao 4 pois são 4 arquivos, cada um contendo uma quantidade de digitos diferentes, por isso o case.
case $i in
 1)
   echo '1' > arq$i.txt
   ;;
 2)
   echo -e '2\n2' > arq$i.txt
   ;;
 3)
   echo -e '3\n3\n3' > arq$i.txt
   ;;
 4)
   echo -e '4\n4\n4\n4' > arq$i.txt
   ;;
esac
done
cd ..
done
