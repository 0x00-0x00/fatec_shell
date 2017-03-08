#!/bin/bash
# Script escrito por Andre Marques ( zc00l )

poem_file="poemas.txt"
if [[ ! -e ${poem_file} ]]; then
    echo "[!] Arquivo de poemas nao encontrado.";
    exit;
fi

function generate_corpora
{
    cat ${poem_file} | tr ' ' '\n' | sort | uniq -u > corpora.txt;
    return 0;
}

function generate_frequency
{
    # Ordem alfabetica
    cat ${poem_file} | tr ' ' '\n' | sort | uniq -c | awk {'print $2": "$1'} > frequencia_alfabetica.txt;

    # Ordem de decrescente
    cat ${poem_file} | tr ' ' '\n' | sort | uniq -c | sort | awk {'print $2": "$1'} > frequencia_decrescente.txt;

    # Ordem de crescente
    cat ${poem_file} | tr ' ' '\n' | sort | uniq -c | sort -r | awk {'print $2": "$1'} > frequencia_crescente.txt;
    return 0;
}

function report
{
    echo "[*] Analisando arquivo: ${poem_file}"
    word_count=$(cat ${poem_file} | wc -w);
    echo -e "    [-] Total de palavras : \033[092m${word_count}\033[0m";
    generate_corpora;
    generate_frequency;
    echo -e "    [-] Corpora palavras: \033[092m$(cat corpora.txt | wc -l)\033[0m";
    echo -e "    [-] Corpora salvo no arquivo: "
    echo -e '        [+] \033[093mcorpora.txt\033[0m';

    echo -e "    [-] Frequencias salvas no arquivos:"
    echo -e "        [+] \033[092mfrequencia_alfabetica.txt\033[0m";
    echo -e "        [+] \033[092mfrequencia_decrescente.txt\033[0m";
    echo -e "        [+] \033[092mfrequencia_crescente.txt\033[0m";
}


report
