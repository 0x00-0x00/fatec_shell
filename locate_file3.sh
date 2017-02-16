#!/bin/bash

if [[ $1 == "" ]]; then
    echo -n "Digite o nome do arquivo para pesquisar: ";
    read arquivo;
else
    arquivo=$1;
fi

data=$(ls -la)
while read -r line; do lines+=("$line"); done <<<"$data"
for line in ${lines[@]};
do
    echo $line;
done


#data=$(ls -la | grep $arquivo | head -n1);
#
#if [[ $(echo $data | wc -l) -eq 0 ]]; then
#    echo "[!] Nao foram encontrados arquivos com o nome '$arquivo'.";
#    exit;
#fi
#
#perm=$(echo $data | grep -oP '^\S*');
#file_name=$(echo $data | grep -oP '[^\s]*$');
#
#echo -n "Arquivo: "; echo $file_name;
#echo -n "Permissao: "; echo $perm;

