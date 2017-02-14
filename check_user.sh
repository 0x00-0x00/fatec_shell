#!/bin/bash
# Check user script escrito por Andre Marques como tarefa na Fatec.
# ---------------------------------
# 2017-02-14

# User file
user_file="/etc/passwd"

#  Checa se um argumento foi mencionado
if [[ $1 == "" ]]; then
    echo -n "Digite um nome de usuario: "
    read user
else
    user=$1
fi

function check_user
{
    l=$(cat $user_file | grep $1 | wc -l)
    if [[ $l -gt 0 ]]; then
        echo "Encontrei $l usuarios com o nome $1.";
        exit
    else
        echo "Nao existe nenhum usuario com o nome $1.";
        exit
    fi
}

check_user $user
