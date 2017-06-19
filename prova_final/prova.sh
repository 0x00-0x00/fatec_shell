#!/bin/bash
if [[ $# < 1 ]]; then
	echo "Uso: $0 DIRETORIO";
	exit 1;
fi

while read -r linha; do
	file_basename=$(echo $linha | awk {'print $9'})
	if [[ $file_basename == "" ]]; then
		continue;
	fi
	if [[ -d "$1/${file_basename}" ]]; then
		echo -e "[+] \033[01mDiretorio\033[0m: $file_basename";
	fi
	if [[ -f "$1/${file_basename}" ]]; then
		file_type=$(file "$1/${file_basename}" | awk {'print $2'});
		bytes=$(wc -c "$1/${file_basename}" | awk {'print $1'});
		echo -e "[+] \033[01mArquivo\033[0m: '$file_basename' com $bytes bytes de tamanho e do tipo '$file_type'";
	fi
done <<< "$(ls -l $1)";

