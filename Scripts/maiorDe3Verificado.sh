#!/bin/bash

#Faça um script chamado maiorDe3Verificado.
#sh que receba três números como parâmetros e retorne o maior.
#Não pode utilizar o comando sort.
#Esse script tem que reclamar caso um dos parâmetros não seja número.

#Recebendo as 3 entradas do usuario

INPUT=$1
INPUT2=$2
INPUT3=$3

# Primeira verificação  é se as entradas são números
# No else vai ter outra verificação para saber qual é o maior número

if [[ ${INPUT} != [0-9] ]];
then
    echo "Opa!!! ${INPUT} não é número."
elif [[ ${INPUT2} != [0-9] ]];
then
    echo "Opa!!! ${INPUT2} não é número."
elif [[ ${INPUT3} != [0-9] ]];
then
    echo "Opa!!! ${INPUT3} não é número."
else
    if [ "${INPUT}" \> "${INPUT2}" ] && [ "${INPUT}" \> "${INPUT3}" ];
    then
        echo "${INPUT}"
    elif [ "${INPUT2}" \> "${INPUT}" ] && [ "${INPUT2}" \> "${INPUT3}" ];
    then
        echo "${INPUT2}"
    elif [ "${INPUT3}" \> "${INPUT}" ] && [ "${INPUT3}" \> "${INPUT2}" ];
    then
        echo "${INPUT3}"
    else
        echo "Todos os números são iguais!"
    fi
fi

