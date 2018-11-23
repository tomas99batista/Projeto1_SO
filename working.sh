#!/bin/bash
#89296 Tomas Batista
#89236 Joao Dias
#SO Trabalho Pratico 1
set -e
set -u
set -o pipefail
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#//TODO: Tratar da -l depois da walk()
#//TODO: Ver -r && -a
#//TODO: Ver se no -L imprimir com extensao e tudo

#//TODO: Espacos nos caminhos
#//TODO: NA nos files
#//TODO: nspace
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#MAIN
n_flag=0
l_flag=0
d_flag=0
L_flag=0
r_flag=0
a_flag=0
while getopts ':n:f:l:d:L:ra' OPTION; do
    case "$OPTION" in
        n)
            n_flag=1
            nvalue="$OPTARG"
            # echo "ligou n"
        ;;
        l)
            l_flag=1
            lvalue="$OPTARG"
            # echo "ligou l"
        ;;
        d)
            d_flag=1
            dvalue="$OPTARG"
            # echo "ligou d"
        ;;
        L)
            L_flag=1
            Lvalue="$OPTARG"
            # echo "ligou L"
        ;;
        r)
            r_flag=1
            # echo "ligou r"
        ;;
        a)
            a_flag=1
            # echo "ligou a"
        ;;
        \?)
            echo "$(basename $0) OPTIONS: [-n arg] [-l arg] [-d arg] [-L arg] [-r] [-a]" >&2
            exit 1
        ;;
    esac
done
shift "$(($OPTIND - 1))"

#if -l and -L are passed to the function, display a message and exits the script
if (( $l_flag == 1 && $L_flag == 1 )); then
    printf "Not possible to combine -l and -L, try again please.\n"
    exit 1  #1=code error
fi

if [ "$d_flag" = 1 ]; then
    df=$(date -d $dvalue)
    if [ $? -eq 0 ]; then
        arg_date=$(date -d $dvalue "+%s")
        # echo $arg_date
    fi
fi

#Recursive function to list directories and files
declare -A dirs
declare -A files
walk() {
    totalspace=0
    for entry in "$1"/*; do
        if [[ -f "$entry" ]]; then
            size=$(stat $entry | head -2 | tail -1 | awk '{print $2}')
            file_data=$(stat $entry | tail -4 | head -1 | awk '{print $2, $3}')
            #l FALSE
            if [[ "$l_flag" = 0 ]]; then
                #D & N TRUE
                if [[ "$d_flag" -eq 1 ]] && [[ "$n_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        file_d=$(date -d "$file_data" +%s)
                        if [[ "$arg_date" -ge "$file_d" ]]; then
                            files["${entry}"]=$size
                            string=$(dirname "$entry")
                            dirs["$string"]+=$size
                            totalspace=$((totalspace + size))
                        fi
                    fi
                    #D TRUE
                    elif [[ "$d_flag" -eq 1 ]]; then #only d true
                    file_data=$(date -d "$file_data" +%s)
                    # echo "Data.size" $file_data "Arg Data" $arg_date
                    if [ "$arg_date" -ge "$file_data" ]; then
                        files["${entry}"]=$size
                        string=$(dirname "$entry")
                        dirs["$string"]+=$size
                        totalspace=$((totalspace + size))
                    fi
                    #N TRUE
                    elif [[ "$n_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        files["${base_name}"]=$size
                        string=$(dirname "$base_name")
                        dirs["$string"]+=$size
                        totalspace=$((totalspace + size))
                    fi
                    #N & D FALSE
                    elif [[ $d_flag -eq 0 && $n_flag -eq 0 ]]; then
                    files["$entry"]=$size
                    string=$(dirname "$entry")
                    dirs["$string"]+=$size
                    totalspace=$((size + totalspace))
                fi
            fi
            
        fi
        
        if [[ -d "${entry}" ]]; then
            local old_value=$totalspace
            walk $entry
            # dirs["$entry"]=$totalspace
            totalspace=$((old_value + totalspace))
        fi
    done
    dirs[$1]=$totalspace
}
if [[ "$r_flag" = 0 && "$a_flag" = 0 ]]; then
    for item in $@; do
        walk "${item}"
    done
    for item in ${!files[@]}; do
        echo ${files["${item}"]} "${item}"
    done | sort -k2 #-rn
fi

if [ "$L_flag" = 1 ]; then
    for k in "${!files[@]}"; do
        echo ${files["${k}"]} ${k}
    done | sort -rn -k1 | head -${Lvalue} 
fi

# for item in $@; do
#     walk "${item}"
# done #| if [[ "$r_flag" = 1 && "$a_flag" = 1 ]]; then
#             $(sort -rn -k3)
#     elif [ "$r_flag" = 1 ]; then
#     $(sort -rn -k3)
#     elif [[ "$a_flag" = 1 ]]; then
#     echo
#     elif [[ "$a_flag" = 0 && "$r_flag" = 0 ]]; then
# fi

# # PRINT ALLF FILES
for item in ${!files[@]}; do
    echo ${files["${item}"]} "${item}"
done |
echo "-----------------------------------"
# PRINT ALL DIRETORIES AND RESPETIVE SIZES
# for item in ${!dirs[@]}; do
#     echo ${dirs["${item}"]} "${item}"
# done