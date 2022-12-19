#!/bin/bash

# Questão : Um script chamado hosts.sh que nos ajude a relacionar nomes de máquinas à IPs.
# O script deve guardar em um arquivo chamado hosts.db um par (nomedamaquina,IP) para cada entrada.

A="vazio"
I="vazio"
D="vazio"
B="vazio"
T=0

# Os parametros são -> Adicionar: -a (hostname), -i (IP) / Remover: -d (hostname) / Procurar: (hostname) / Procurar pelo IP: -r (IP) / Listar: -l 
while getopts "a:i:d:r:l" OPTVAR;do
# Adicionar
   if [ "$OPTVAR" == "a" ];then
        A=$OPTARG
   fi
   if [ "$OPTVAR" = "i" ];then
	I=$OPTARG
   fi  # Se o A e I não estiverem vazios, quer dizer que foi atribuido um argumento para eles.
   if [ $A != "vazio" ] && [ $I != "vazio" ];then
	echo $A $I >> hosts.db
   fi
# Remover
   if [ "$OPTVAR" == "d" ];then
	D=$OPTARG  # Vou pegar no arquivo todos menos o da variavel D e mandar para um arquivo temporario e depois torna-lo meu arquivo principal(hosts.db)
	cat hosts.db | grep -v "${D}" > lixo.txt
	mv lixo.txt hosts.db
   fi
# Listar
   if [ "$OPTVAR" == "l" ];then
	cat hosts.db
   fi
# Busca individual pelo ip (reverse)
   if [ "$OPTVAR" == "r" ];then
	B=$OPTARG  # Pesquiso no arquivo apenas a linha que contem aquela variavel, e depois retorno apena o primeiro campo(nome)
	cat hosts.db | grep -i "${B}" | cut -d " " -f1
   fi
done

# Busca individual pelo nome
if [ $T == 0 ] && [ $# == 1 ];then
 echo $1 > busca.txt
  if [[ $(grep -E '^-' busca.txt) ]];then  # Se o $1/busca.txt começar com - quer dizer q tem parametro, entao nao é uma busca individual usando apenas o hostname.
     echo " " > busca.txt # isso é apenas para fazer algo, o comando continue n deu certo.
  else # se for uma busca usando hostname, faz um pesquisa no arquivo e pega o segundo campo
     cat hosts.db | grep -i "$1" | cut -d " " -f2
  fi
  rm busca.txt
fi
