while getopts "s:p:" opt; do
    case $opt in
        s);;
        p);;
        ?);;
    esac
done

if [[ $# < 2 ]]; then
    echo "Uso: $0 -s SERVER_IP -p PORTA"
    exit 1;
fi
