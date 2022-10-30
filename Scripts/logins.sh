#1 - Um comando grep que encontre todas as linhas com mensagens que não são do sshd.
#2 - Um comando grep que encontre todas as linhas com mensagens que indicam um login de sucesso via sshd cujo nome do usuário começa com a letra j.
#3 - Um comando grep que encontre todas as vezes que alguém tentou fazer login via root através do sshd.
#4 - Um comando grep que encontre todas as vezes que alguém conseguiu fazer login com sucesso nos dias 11 ou 12 de Outubro.

grep -v "sshd" auth.log
grep -E "sshd.*for j" auth.log
grep -E "sshd.*root" auth.log
grep -E "Oct 1[12].*Accepted" auth.log

