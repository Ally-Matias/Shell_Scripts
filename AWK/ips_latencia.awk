# nesse script eu usei a mesma logica que tinha usado na questao parecida (latencia.sh)
# o getline lê a próxima linha e move o script para ela
# depois printei os valores no formato pedido

{
        comando = "ping -c 10 "$1" | grep rtt | cut -f5 -d'/'"
        comando | getline latencia
        print $1 " " latencia "ms" | "sort -n"
}


#for x in ...
   #echo $x $(grep "rtt" ping.txt | cut -d '/' -f5) >> lixo.txt
