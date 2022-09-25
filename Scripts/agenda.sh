#!/bin/bash

# Criei varias variaveis para guardar as expressões e entradas do usuario

INPUT=$1
INPUT2=$2
INPUT3=$3
BUSCA=$(grep -c "${INPUT2}" agenda.db)  # Faz uma busca e contagem(-c) na agenda pesquisando pelo o usuario, retorna 0(não existe) ou 1 (existe o usuario)
LINHAS=$(wc -l agenda.db | cut -d " " -f1)  # Faz a contagem de linhas no arquivo e deixa somente o valor.
USUARIO=$(cat agenda.db | grep -i "${INPUT2}" | cut -d ":" -f1) # Pesquisa pela a entrada(email) e pega o nome do usuario que esta antes dos :

if [ ${INPUT} = "adicionar" ];
then
    if [ ${BUSCA} = 0 ];
    then
        echo "Arquivo criado!!!"
        echo "Usuário ${INPUT2} adicionado."
        echo "${INPUT2}":"${INPUT3}" >> agenda.db
    else
        echo "usuario já existe"
    fi
elif [ ${INPUT} = "remover" ];
then
    if [ ${BUSCA} = 0 ];
    then
        echo "Usuário ${INPUT2} não existe."
    else
        echo "Usuário ${USUARIO} removido."
        cat agenda.db | grep -v "${INPUT2}" > lixo.txt # Manda o conteudo do arq menos o {input2} para um arquivo lixo temporario.
        mv lixo.txt agenda.db # E após isso dou um mv(mover ou renomear) para o lixo.txt se tornar a minha agenda.db
    fi
elif [ ${INPUT} = "listar" ];
then
    if [ ${LINHAS} = 0 ];
    then
        echo "Arquivo vazio!!!"
    else
        cat agenda.db
    fi
fi
