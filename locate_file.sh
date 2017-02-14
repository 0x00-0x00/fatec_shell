#!/bin/bash

if [[ $1 == "" ]]; then
    echo -n "Digite um nome de arquivo: "
    read filename
else
    filename=$1;
fi

function locate_file
{
    if [[ -e $1 ]]; then
        echo "Arquivo $1 existe.";
    else
        echo "Arquivo $1 nao existe.";
    fi
}

locate_file $filename
