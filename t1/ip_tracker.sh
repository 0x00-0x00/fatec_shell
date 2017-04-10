#!/bin/bash

ip_data="";

function log {
    echo -e "\033[092mINFO\033[0m: $1";
    return 0;
}


function error {
    echo -e "\033[091mERRO\033[0m: $1"
    return 0;
}



if [[ $# < 2 ]]; then
    log "Uso: $0 -f <ARQUIVOS DE IP>";
    exit 0;
fi

while getopts "f:" opt; do
    case $opt in
        f)log "Arquivo de IP's definido: $OPTARG"; ip_data=$OPTARG;;
        ?)error "Opção Inválida!"; exit 0;;
    esac
done


function convert_to_decimal
{
    list=($(echo $1 | tr '.' '\n'));
    byte_shift=24;
    decimal=0;
    counter=0;
    sum=0;
    while [[ $counter < 4 ]]; do
        decimal=$((${list[$counter]} << $byte_shift));
        sum=$(($sum+$decimal));
        ((counter++));
        byte_shift=$(($byte_shift-8))
    done
    echo $sum;
}


function gather_geo_data
{
    decimal=$(convert_to_decimal $1);

    decimal_beg=$(echo $decimal | grep -oP "\d{4}" | head -n1);
    #echo $decimal_beg;

    end_length=$((${#decimal}-${#decimal_beg}));
    #echo $end_length;

    data_file="IP2LOCATION-LITE-DB1.CSV";
    if [[ ! -f $data_file ]]; then
        error "Database de IP's não encontrada.";
        exit 0;
    fi

    data=$(cat $data_file | grep -P "$decimal_beg\d{${end_length}}");
    while read -r line; do
        line_data=($(echo $line | tr "," "\n"));
        if [[ ${line_data[1]} == "" ]]; then
            continue;
        fi

        min_range=$(echo ${line_data[0]} | sed 's/\"//g');
        max_range=$(echo ${line_data[1]} | sed 's/\"//g');
        if [[ $min_range < $decimal ]] && [[ $max_range > $decimal ]]; then
            sigla=$(echo ${line_data[2]} | sed 's/\"//g');
            country=$(echo ${line_data[3]} ${line_data[4]} | sed 's/\"//g');
            echo "IP $1 pertence ao pais $sigla $country";
        fi
    done <<< "$data"
    return 0;
}


while read -r line; do
    gather_geo_data $line;
done <<< "$(cat $ip_data)"

