#4 - Um comando grep que encontre todas as vezes que alguém conseguiu fazer login com sucesso nos dias 11 ou 12 de Outubro.

awk $1 ~ /^(Oct)/ && $6 ~ /(Accepted)/ && $2 ~ /^(11|12)/ {print}
