#3 - Um comando grep que encontre todas as vezes que alguém tentou fazer login via root através do sshd.

awk $5 ~"sshd" && /root/ {print}
