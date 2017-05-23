#!/bin/bash -x

server_program="ncat"

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

start_server()
{
	if [[ ! -f queue.cmd ]]; then
		touch queue.cmd
	fi

	${server_program} -lvp $1 < queue.cmd 2> /dev/null 1>>client.resps &
	rm queue.cmd

	if [[ $? != 0 ]]; then
		exit 1;
	fi

	return 0;
}

while getopts "p:" opt; do
	case $opt in
		p) PORT=$OPTARG; echo "[+] Porta definida em: $OPTARG" ;;
		?) echo "[!] Argumento invalido."; exit 1 ;;
	esac;
done

if [[ $# < 2 ]]; then
	echo "Uso: $0 -p PORTA";
	exit 0;
fi

start_server $PORT
trap 'kill_server; exit 0;' INT TERM;
while [[ ${cmd} != "exit" ]]; do
	start_server $PORT
	echo "[=] Digite o comando: "
	read cmd;
done
