#!/bin/bash
#
# Script escrito por Andre Marques (zc00l)
# -------------------------------------------
#  Abre e monitora instancias do FirstWork.jar

instance_n=0;
alias=("Magikarp" "Chikorita" "Bulbasauro" "Charmander" "Pikachu" "Muk" "Gyarados" "Mankey" "Pidgeotto" "Onix" "Steelix" "Ghast" "Caterpie");
tracker=();
dead=();
target="FirstWork.jar";
start_time=$(python -c "import time;print(int(time.time()))");


function report_status
{
    if [[ $1 == 0 ]]; then
        echo -e "\033[092mSUCESSO\033[0m";
    else
        echo -e "\033[091mFALHOU\033[0m";
    fi
    return 0;
}


function pre
{
    echo -n -e "[\033[093m*\033[0m] $1: ";
    return $?;
}


function info
{
    echo -e "\033[093mINFO\033[0m: $1";
    return $?;
}


function error
{
    echo -e "\033[091mERRO\033[0m: $1";
    return $?;
}


function help_section
{
    args=("-n");
    desc=("Numero de instancias");
    echo "  Ajuda do Script";
    echo "----------------------------"
    echo "Como usar: $0 -n NUMERO_DE_INSTANCIAS"
    for item in "${args[@]}"; do
        echo -e "   \033[01m$item\033[0m: ${desc[@]}";
    done
}


function open_instance
{
    nohup java -jar $1 $2 $3 $4 $5 1>>stdout.log 2>>stderr.log &
}


function initiate
{
    #  Check instance N
    if [ $instance_n == 0 ] || [ $instance_n -gt 10 ]; then
        error "O numero de instancias nao pode ser zero ou maior que dez.";
        exit 0;
    fi
    while [ $instance_n -gt 0 ]; do
       chosen_alias=${alias[$instance_n]};
       pre "Iniciando instancia $chosen_alias";
       #nohup java -jar $target "ZeR0-C00L" "AndreMarques" $chosen_alias $instance_n 1>>stdout.log 2>>stderr.log &
       open_instance $target "ZeR0-C00L" "AndreMarques" $chosen_alias $instance_n
       report_status $?;

       tracker+=(".service_$instance_n");

       #  Decrement by one to loop condition completeness.
       instance_n=$((instance_n-1));
    done
}


function log_errors
{
    err_file="stderr.log"
    curr_time=$(python -c "import time; print(int(time.time()))");

    modulus=$(($1 % 10));
    if [ $modulus -eq 0 ]; then
        echo -n -e "[\033[093m!\033[0m] Erros: $(wc -l $err_file | awk {'print $1'}) em $(($curr_time-$start_time)) segundos.\r"
    fi
}


function monitor_instances
{
    # This function will do the objective number 2: monitoring the processess
    dead=0;
    err_i=0;
    sleep 5;
    while [ ${#tracker[@]} -gt 0 ]; do

        #  Error logging (objective 3: error lines logging)
        err_i=$((err_i++));
        log_errors $err_i

        for instance in "${tracker[@]}"; do

            # First, we check if the dead means equality to the number
            # of process spawned.
            #if [ $dead -eq ${#tracker[@]} ]; then
            #    info "Todas as instancias foram finalizadas.";
            #    exit 0
            #fi

            #  Then, we will jump the invalid element array
            if [[ $instance == "" ]]; then
                continue;
            fi

            # Finally, check if the lock file is existant or not.
            if [[ ! -f "$instance" ]]; then
                #delete=("$instance");
                #tracker=("${tracker[@]/$delete}");  # remove element
                echo -e "\n[\033[093m!\033[0m] Instancia ${instance} terminou.";
                inst_n=$(echo $instance | grep -oP '\d+');
                info "Reiniciando instancia $inst_n [${alias[$inst_n]}]";
                open_instance $target "Zer0-C00L" "AndreMarques" ${alias[$inst_n]} $inst_n;
                ((dead++));
            fi

        done
        sleep 3;
    done
}


if [[ $1 == "" ]]; then
    help_section;
    exit 0;
fi

while getopts "n:" opt; do
    case $opt in
        n) instance_n=$OPTARG; info "Numero de instancias definido em $instance_n";;
    esac;
done

# Delete previous service instances
# killall java > /dev/null 2>&1;
rm .service_* > /dev/null 2>&1;
rm *.log > /dev/null 2>&1;
rm nohup.out > /dev/null 2>&1;

if [[ ! -e $target ]]; then
    error "Nao foi possivel encontrar o arquivo $target";
    exit 0;
fi

java_bin=$(which java);
if [[ ! -e $java_bin ]]; then
    error "Java nao foi encontrado.";
    exit 0;
fi

initiate
monitor_instances
exit 0;
