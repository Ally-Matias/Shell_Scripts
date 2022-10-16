#!/bin/bash

ARQ=
echo "Informe o arquivo: "
read ARQ

cat $ARQ | echo "$((sed "/^$/d;//d" |(tr -d '.') | (tr -d ',') | (tr ' ' '\n')) )">> lixo.txt

VAR=$(cat lixo.txt | sort)

#echo ${VAR}
#echo ${VAR} > teste.txt

#rm oficial.txt

#for i in $(cat teste.txt);do
#   contagem=$(echo ${i} | cut -d ' ' -f2)
#   string=$(echo ${i} | cut -d ' ' -f1)
#   echo "${string}:${contagem}" >> oficial.txt
#   echo "${string}:${contagem}"
#done

#rm lixo.txt

touch arqui.txt

for i in $(cat lixo.txt);do
   if [[ $(cat arqui.txt | grep -E "^${i}:") ]];then
      continue
   else
      echo ${i} >> arqui.txt
   fi
done

for x in $(cat arqui.txt);do
   CONT=$(cat lixo.txt | grep -E "^${x}$" | wc -l)
   echo ${x}:${CONT} >> temp.txt
   echo ${x}:${CONT}
done

rm -f lixo.txt temp.txt arqui.txt
