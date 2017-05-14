#!/bin/bash

# Retorna string com o AP atualmente conectado pelo NetworkManager
get_current() {
    curr=$(nmcli -t --fields ACTIVE,SSID d wifi | grep yes | tr " " "_" | tr ":" " " | awk {'print $2'} | tr "_" " ");
    echo $curr;
}

# Retorna o AP:Sinal do maior sinal detectado
get_signal() {
    m=0;
    signal=($(nmcli -t --fields SSID,SIGNAL d wifi list | tr " " "_"));
    for i in ${signal[@]};
    do
        signalval=$(echo $i | tr ":" " " | awk {'print $2'})
        if [[ $signalval > $m ]]; then
            m=$signalval;
        fi
    done
    echo ${signal[@]} | tr " " "\n" | grep $m | sort | head -n1;
    return 0;
}

while getopts "n:i:" opt; do
    case $opt in
        n) echo "[+] Intervalo de checagem definido em: $OPTARG"; interval=$OPTARG;;
        i) echo "[+] Interface de rede definida em: $OPTARG"; interface=$OPTARG;;
        ?) echo "[!] Opcao invalida."; exit 1;;
    esac;
done

if [[ $# < 4 ]]; then
    echo -e "Argumentos:\n  -n SEGUNDOS   -> Segundos de intervalo entre checagem\n  -i INTERFACE   -> Interface de rede\n";
    echo "Uso: $0 -n N";
    exit 1;
fi

while [[ 1 -eq 1 ]]; do
    ap=$(get_signal | tr ":" " " | awk {'print $1'} | tr "_" " ");
    curr=$(get_current);
    echo "[*] Atualmente conectado em: $curr";
    if [[ $ap != $curr ]]; then
        echo "[+] Conectando ao access point $ap ...";
        nmcli con up  "$ap";
        if [[ $? == 0 ]]; then
            echo "[+] Conectado.";
        else
            echo "[!] Erro ao se conectar.";
        fi
    else
        echo "[*] Ja conectado no melhor AP."
    fi
    sleep $interval;
done
