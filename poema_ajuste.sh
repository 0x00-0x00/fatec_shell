#!/bin/bash

poems="poemas.fernando"

if [[ ! -e ${poems} ]]; then
    echo "[!] Arquivo de poemas inexistente.";
    exit;
fi

cat ${poems} | sed 's/<\/p>//g' | sed 's/<p class="frase fr0" id="[a-zA-Z0-9]*">//g' | sed 's/\.\.\./\n/g' | sed 's/[«“"!\{\}\-\._)(\/,\?:\-]//g' | sed "s/'//g" | sed 's/\&.*;//g' | sed 's/[0-9]//g'
