#1 - Um comando grep que encontre todas as linhas com mensagens que não são do sshd.

awk $5 !~"sshd" {print}

#awk $5 !~ /^(sshd)/ { print }
