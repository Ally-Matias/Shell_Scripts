#!/bin/bash

#QUESTAO - Considere um arquivo com o seguinte conteúdo:
#NOME TURMA NOTA1 NOTA2 NOTA3
#João     A     7     8     9
#Maria    A     5     7     7
#Carlos   B     6     4     6
#Ana      A     3     9     7
#Helena   C     3     4     7
#Luisa    C     9     8    10
#Maite    C    10     9     8
#Chico    B     5     3     8
#Essa questão exige vários comandos sed. Coloque um abaixo do outro.
#Primeiro, em um único comando sed, altere A para INF, turma B para LOG e turma C para RED.
#Em seguida, crie um arquivo para cada turma, contendo apenas os alunos das respectivas turmas (não precisa ser um único comando).
#Por último, informe o comando que cria um novo arquivo, chamado recuperacao.txt, contendo apenas os alunos com média abaixo de 6.

#Essa primeira linha do sed e para mostrar na tela a alteracao.
sed -r -e 's/ A +/INF    /g' -r -e 's/ B +/LOG    /g' -r -e 's/ C +/RED    /g' turma.txt 

#Essa segunda linha do sed e para fazer a alteracao permanentemente. (-i)
sed -r -e 's/ A +/INF    /g' -r -e 's/ B +/LOG    /g' -r -e 's/ C +/RED    /g' -i turma.txt 

#Criacao dos arquivos
touch INFturma.txt
touch LOGturma.txt
touch REDturma.txt

#Enviando as linhas certas para os arquivos criados anteriormente.
sed -n '1p; 2p; 3p; 5p' turma.txt > INFturma.txt 

sed -n '1p; 4p; 9p' turma.txt > LOGturma.txt 

sed -n '1p; 6p; 7p; 8p' turma.txt > REDturma.txt 

touch recuperacao.txt

sed -n '1p; 4p; 6p; 9p' turma.txt > recuperacao.txt 
