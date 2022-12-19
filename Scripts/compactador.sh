#!/bin/bash

# 1- Apresentar uma tela requisitando o caminho de um diretório.
# 2- Formar uma lista com os nomes dos arquivos (sem subdiretórios) do diretório citado. O usuário deve escolher um ou mais arquivos.
# 3- Exibir duas opções de compactação: gzip ou b2zip.
# 4- Questionar o nome do arquivo compactado a ser criado.
# 5- Criar o arquivo compactado com os arquivos selecionados do diretório e exibir uma tela de sucesso com o nome final do arquivo.

dialog --msgbox "ATENÇÃO! Para este script funcionar, é necessário escrever o caminho completo e correto do diretório. Obrigado!" 10 30 --stdout

#pega o caminho
caminho=$(dialog --inputbox "Digite o caminho inteiro do diretório:" 10 90 --stdout)

if [ $(echo $?) == "0" ];then # n apertou cancelar
      #ls $caminho > arq.txt
      echo cd $caminho | ls > arq.txt
      dialog --msgbox "Seus arquivos a seguir, escolha qual vai querer compactar!" 10 30 --textbox arq.txt 70 50 --stdout
      dialog --inputbox "Qual o nome do arquivo que vai querer compactar?" 10 50 --stdout > lixo.txt " " >> arquivos.txt
      pergunta=$(dialog --inputbox "Deseja escolher mais um arquivo? [s/n]" 10 25 --stdout)  # Pergunta se quer outro arquivo
      while [ $(echo $pergunta) == "s" ];do  # loop até não querer mais arquivos
          dialog --msgbox "Seus arquivos a seguir, escolha qual vai querer compactar!" 10 30 --textbox arq.txt 70 50 --stdout
          dialog --inputbox "Qual o nome do arquivo que vai querer compactar?" 10 50 --stdout > lixo.txt " " >> arquivos.txt
          pergunta=$(dialog --inputbox "Deseja escolher mais um arquivo? [s/n]" 10 25 --stdout)
      done
      opcoes=$(dialog --menu "Opções de compactação:" 10 10 0 1 "gzip" 2 "b2zip" --stdout)
      nome=$(dialog --inputbox "Qual vai ser o nome do arquivo compactado?" 10 25 --stdout)
      dialog --msgbox "Para sua segurança, vou manter os seus arquivos originais!" 10 30 --stdout
      if [ $(echo $opcoes) = "1"  ];then #gzip
         # | awk -v caminho=$caminho '{ printf("%s/%s\n", caminho, $1)}'
         gzip -kc $(cat arquivos.txt) > $nome.gz  # -k : compactar o arquivo e manter o arquio original. -c : escrever na saída padrão e redirecionar a saída para um arquivo 
         dialog --msgbox "O arquivo $nome.gz foi criado com sucesso!" 10 30 --stdout
         clear
      else                               #b2zip
         # | awk -v caminho=$caminho '{ printf("%s/%s\n", caminho, $1)}'
         bzip2 -kc $(cat arquivos.txt) > $nome.bz2
         dialog --msgbox "O arquivo $nome.bz2 foi criado com sucesso!" 10 30 --stdout
         clear
      fi
      rm arquivos.txt arq.txt lixo.txt
else
   clear
   echo vocẽ não quis continuar a compactação.
fi

#/home/allymatias/Área\ de\ Trabalho/MatiasDev/Shell_Scripts/Scripts/
