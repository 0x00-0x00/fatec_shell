#!/bin/bash
#  Script para encontrar informacoes sobre usuarios
#   Tarefa da Fatec
#   Escrito por Andre Marques - 3o seg

user_file="/etc/passwd";
user=$1;

# Caso nao seja fornecido um usuario pelo argv
[ ! "$user" ] && { echo -n "Procurar por usuario: "; read user; }


function check_user
{
    if [[ ! -e $user_file ]]; then
        echo "[!] Nao consegui encontrar o arquivo '$user_file'";
        exit;
    fi

    num_users=$(cat $user_file | grep $1 | wc -l)
    if [[ $num_users -eq 0 ]]; then
        echo "Nao foram encontrados usuarios com o nome '$1'.";
        exit;
    fi


    data=$(cat $user_file | grep $1 | grep -oP '.+(?=::)');
    user=$(echo $data | grep -oP '[a-zA-Z0-9]+(?=:x:)');
    uid=$(echo $data | grep -oP '(?!:x:)[0-9]+(?=:)');
    gid=$(echo $data | grep -oP '(?![0-9]+:)[0-9]+');

    echo "_______________________________"
    echo "    Informacoes de usuario"
    echo "=============================="

    echo -n "User: ";
    echo $user;

    echo -n "UID: ";
    echo $uid;

    echo -n "GID: ";
    echo $gid;

}

check_user $user
