#2 - Um comando grep que encontre todas as linhas com mensagens que indicam um login de sucesso via sshd cujo nome do usuário começa com a letra j.

awk $5 ~"sshd" && $8 ~"for" && $9 ~"j" {print}
