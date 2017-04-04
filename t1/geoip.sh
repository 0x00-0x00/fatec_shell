#!/bin/bash

ip_file="stdout.log";
ip_out="ip.out";
rm ip.relatorio > /dev/null 2>&1;

function log {
    echo -e "\033[092mINFO\033[0m: $1";
    return 0;
}


function error {
    echo -e "\033[091mERRO\033[0m: $1"
    return 0;
}


function gather_ips {
    if [[ ! -f $ip_file ]]; then error "Arquivo de IP's não existe."; exit 1; fi
    cat $ip_file | grep -oP '\d+\.\d+\.\d+\.\d+' > $ip_out;
    log "Arquivo de IP's gerado com sucesso!";
    return 0;
}

function parse_ips {
    lines=$(wc -l $ip_out | awk {'print $1'});
    ips=();
    echo "Existem $lines IP's a serem processados.";
    i=1;
    while read -r line; do
        ips+=($line);
        echo -n -e "Processando IPs: [$i/$lines]\r";
        ((i++));
    done <<< "$(cat $ip_out)";
    echo -e "\n";
    for ip in "${ips[@]}"; do
        data=$(generate_report $ip);
        echo $data;
        echo $data >> ip.relatorio;
    done
}


function generate_report {
    if [[ $1 == "" ]]; then exit 0; fi  # check if has value
    country=$(whois $1 | grep -i country | awk {'print $2'} | head -n1)
    echo "IP $1 pertence ao país de sigla $country.";
}


gather_ips
parse_ips
