#!/bin/bash
#89296 Tomas Batista
#89236 Joao Dias
#SO Trabalho Pratico 1
set -e
set -u
set -o pipefail

# -l it is not 100% functional
# -NA can bug sometimes

#Initializes all flags at 0
#If they are passed by the user they will be set to 1
n_flag=0
l_flag=0
d_flag=0
L_flag=0
e_flag=0
r_flag=0
a_flag=0

#GETOPTS WILL GET THE OPTIONS PASSED BY THE USER
while getopts ':n:f:l:d:L:e:ra' OPTION; do
    case "$OPTION" in
        n)
            #Increment the times that the user passed each option
            n_flag=$((n_flag + 1))
            #If user passes more than 1 time the options it exits and print an error message
            if [ $n_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
            nvalue="$OPTARG"
        ;;
        l)
            l_flag=$((l_flag + 1))
            if [ $l_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
            #if -l and -L are passed to the function, display a message and exits the script
            if [[ $l_flag == 1 && $L_flag == 1 ]]; then
                printf "Not possible to combine -l and -L, try again please.\n"
                exit 1  #1=code error
            fi
            lvalue="$OPTARG"
            if ! [[ "$lvalue" =~ ^[0-9]+$ ]]
            then
                echo "ERRO: Passe um numero valido no argumento das opcoes"
                exit 3 #3=code error
            fi
        ;;
        d)
            d_flag=$((d_flag + 1))
            if [ $d_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
            dvalue="$OPTARG"
            #This if checks if the -d option argument (a date) is true, $? -eq 0 means true
            #If it is true it convert the argument of -d to a date
            if [ "$d_flag" = 1 ]; then
                if [ $? -eq 0 ]; then
                    arg_date=$(date -d $dvalue "+%s")
                fi
            fi
        ;;
        L)
            L_flag=$((L_flag + 1))
            if [ $L_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
            #if -l and -L are passed to the function, display a message and exits the script
            if [[ $l_flag == 1 && $L_flag == 1 ]]; then
                printf "Not possible to combine -l and -L, try again please.\n"
                exit 1  #1=code error
            fi
            Lvalue="$OPTARG"
            if ! [[ "$Lvalue" =~ ^[0-9]+$ ]]
            then
                echo "ERRO: Passe um numero valido no argumento das opcoes"
                exit 3 #3=code error
            fi
        ;;
        r)
            r_flag=$((r_flag + 1))
            if [ $r_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
        ;;
        a)
            a_flag=$((a_flag + 1))
            if [ $a_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
        ;;
        e)
            e_flag=$((e_flag + 1))
            if [ $e_flag -ne 1 ]; then
                echo "ERRO: Apenas pode passar uma vez cada opcao"
                exit 2  #2=code error
            fi
            evalue="$OPTARG"
            #This will put all the lines of file in the array_files
            if [ "$e_flag" = 1 ];then
                i=0
                array_files=()
                while read line_data; do
                    array_files[i]="${line_data}"
                    ((++i))
                done < "$evalue"
            fi
        ;;
        \?)
            echo "$(basename $0) OPTIONS: [-n arg] [-l arg] [-d arg] [-L arg] [-e arg] [-r] [-a]" >&2
            exit 1
        ;;
    esac
done
shift "$((OPTIND - 1))"

#Dirs its used to store the paths and sizes to -l (and other options)
declare -A dirs

#Files its used to store the files and sizes to -L (and other options)
declare -A files

#Recursive function to list directories and files
walk() {
    totalspace=0
    for entry in "$1"/*; do
        #FILES
        #If it is a FILE
        if [[ -f "$entry" ]]; then
            #l FALSE
            
            #If it is readable
            if [[ -r "$entry" ]]; then
                #Get the size and the data of the file
                size=$(stat $entry | head -2 | tail -1 | awk '{print $2}')
                file_data=$(stat $entry | tail -4 | head -1 | awk '{print $2, $3}')
                file_d=$(date -d "$file_data" +%s)
                
                #D & N & E TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 1 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the file name it contains parts (or it is totally equal) it passes
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        #If the file it is older than the date passed on argument it will store
                        if [[ "$arg_date" -ge "$file_d" ]]; then
                            #It traverse the array with the files not to consider
                            for item in ${array_files[@]}; do
                                #If any of the files on the file it is equal to the one
                                #Passed by argument it does not store
                                if ! [[ "$base_name" =~ ^$item$ ]]; then
                                    #It stores the path with file on the files array and it stores the size value
                                    files["${entry}"]=$size
                                    string=$(dirname "$entry")
                                    #It stores the path on the directories array and it stores the size
                                    dirs["$string"]+=$size
                                    #Increment the total space
                                    totalspace=$((totalspace + size))
                                fi
                            done
                        fi
                    fi
                fi
                
                #N & E TRUE
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 1 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #It traverse the array with the files not to consider
                    for item in ${array_files[@]}; do
                        #If any of the files on the file it is equal to the one
                        #Passed by argument it does not store
                        if ! [[ "$base_name" =~ ^$item$ ]]; then
                            #If the file name it contains parts (or it is totally equal) it passes
                            if [[ "$base_name" =~ ^$nvalue$ ]]; then
                                files["${base_name}"]=$size
                                string=$(dirname "$base_name")
                                dirs["$string"]+=$size
                                totalspace=$((totalspace + size))
                            fi
                        fi
                    done
                fi
                
                #D & E TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 0 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the file it is older than the date passed on argument it will store
                    if [ "$arg_date" -ge "$file_d" ]; then
                        #It traverse the array with the files not to consider
                        for item in ${array_files[@]}; do
                            #If any of the files on the file it is equal to the one
                            #Passed by argument it does not store
                            if ! [[ "$base_name" =~ ^$item$ ]]; then
                                files["${entry}"]=$size
                                string=$(dirname "$entry")
                                dirs["$string"]+=$size
                                totalspace=$((totalspace + size))
                            fi
                        done
                    fi
                fi
                
                #D & N TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 1 && "$e_flag" -eq 0 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the file name it contains parts (or it is totally equal) it passes
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        file_d=$(date -d "$file_data" +%s)
                        #If the file it is older than the date passed on argument it will store
                        if [[ "$arg_date" -ge "$file_d" ]]; then
                            files["${entry}"]=$size
                            string=$(dirname "$entry")
                            dirs["$string"]+=$size
                            totalspace=$((totalspace + size))
                        fi
                    fi
                fi
                
                #D TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 0 && "$e_flag" -eq 0 ]]; then
                    #If the last modify on the file it is older than the date passed on the argument
                    #it stores the file and the directory path (and respective size)
                    if [ "$arg_date" -ge "$file_d" ]; then
                        files["${entry}"]=$size
                        string=$(dirname "$entry")
                        dirs["$string"]+=$size
                        totalspace=$((totalspace + size))
                    fi
                fi
                
                #E TRUE
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 0 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #It traverse the array with the files not to consider
                    for item in ${array_files[@]}; do
                        #If any of the files on the file it is equal to the one
                        #Passed by argument it does not store
                        if ! [[ "$base_name" =~ ^$item$ ]]; then
                            files["${entry}"]=$size
                            string=$(dirname "$entry")
                            dirs["$string"]+=$size
                            totalspace=$((totalspace + size))
                        fi
                    done
                fi
                
                #N TRUE
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 1 && "$e_flag" -eq 0 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the name of the file contains (or it is totally equals) it stores
                    #the file name and the directory path (and respective size)
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        files["${base_name}"]=$size
                        string=$(dirname "$base_name")
                        dirs["$string"]+=$size
                        totalspace=$((totalspace + size))
                    fi
                fi
                
                #N & D & E FALSE
                #If the user passes 0 arguments it stores all the directories and files (and respective size)
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 0 && "$e_flag" -eq 0 ]]; then
                    files["$entry"]=$size
                    string=$(dirname "$entry")
                    dirs["$string"]+=$size
                    totalspace=$((size + totalspace))
                fi
            fi
            
            #If the file it is not readable it will store the value of 'NA'
            if ! [[ -r "$entry" ]]; then
                
                #Set the size to 'NA' and get the data of the file
                size="NA"
                file_data=$(stat $entry | tail -4 | head -1 | awk '{print $2, $3}')
                file_d=$(date -d "$file_data" +%s)
                
                #D & N & E TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 1 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the file name it contains parts (or it is totally equal) it passes
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        #If the file it is older than the date passed on argument it will store
                        if [[ "$arg_date" -ge "$file_d" ]]; then
                            #It traverse the array with the files not to consider
                            for item in ${array_files[@]}; do
                                #If any of the files on the file it is equal to the one
                                #Passed by argument it does not store
                                if ! [[ "$base_name" =~ ^$item$ ]]; then
                                    #It stores the path with file on the files array and it stores the size value
                                    files["${entry}"]="NA"
                                    string=$(dirname "$entry")
                                    #It stores the path on the directories array and it stores the size
                                    dirs["$string"]="NA"
                                    #Increment the total space
                                fi
                            done
                        fi
                    fi
                fi
                
                #N & E TRUE
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 1 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #It traverse the array with the files not to consider
                    for item in ${array_files[@]}; do
                        #If any of the files on the file it is equal to the one
                        #Passed by argument it does not store
                        if ! [[ "$base_name" =~ ^$item$ ]]; then
                            #If the file name it contains parts (or it is totally equal) it passes
                            if [[ "$base_name" =~ ^$nvalue$ ]]; then
                                files["${base_name}"]="NA"
                                string=$(dirname "$base_name")
                                dirs["$string"]="NA"
                                totalspace=$((totalspace + size))
                            fi
                        fi
                    done
                fi
                
                #D & E TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 0 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the file it is older than the date passed on argument it will store
                    if [ "$arg_date" -ge "$file_d" ]; then
                        #It traverse the array with the files not to consider
                        for item in ${array_files[@]}; do
                            #If any of the files on the file it is equal to the one
                            #Passed by argument it does not store
                            if ! [[ "$base_name" =~ ^$item$ ]]; then
                                files["${entry}"]="NA"
                                string=$(dirname "$entry")
                                dirs["$string"]="NA"
                                totalspace=$((totalspace + size))
                            fi
                        done
                    fi
                fi
                
                #D & N TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 1 && "$e_flag" -eq 0 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the file name it contains parts (or it is totally equal) it passes
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        file_d=$(date -d "$file_data" +%s)
                        #If the file it is older than the date passed on argument it will store
                        if [[ "$arg_date" -ge "$file_d" ]]; then
                            files["${entry}"]="NA"
                            string=$(dirname "$entry")
                            dirs["$string"]="NA"
                            totalspace=$((totalspace + size))
                        fi
                    fi
                fi
                
                #D TRUE
                if [[ "$d_flag" -eq 1 && "$n_flag" -eq 0 && "$e_flag" -eq 0 ]]; then
                    #If the last modify on the file it is older than the date passed on the argument
                    #it stores the file and the directory path (and respective size)
                    if [ "$arg_date" -ge "$file_d" ]; then
                        files["${entry}"]="NA"
                        string=$(dirname "$entry")
                        dirs["$string"]="NA"
                        totalspace=$((totalspace + size))
                    fi
                fi
                
                #E TRUE
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 0 && "$e_flag" -eq 1 ]]; then
                    base_name="$(basename "${entry}")"
                    #It traverse the array with the files not to consider
                    for item in ${array_files[@]}; do
                        #If any of the files on the file it is equal to the one
                        #Passed by argument it does not store
                        if ! [[ "$base_name" =~ ^$item$ ]]; then
                            files["${entry}"]="NA"
                            string=$(dirname "$entry")
                            dirs["$string"]="NA"
                            totalspace=$((totalspace + size))
                        fi
                    done
                fi
                
                #N TRUE
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 1 && "$e_flag" -eq 0 ]]; then
                    base_name="$(basename "${entry}")"
                    #If the name of the file contains (or it is totally equals) it stores
                    #the file name and the directory path (and respective size)
                    if [[ "$base_name" =~ ^$nvalue$ ]]; then
                        files["${base_name}"]="NA"
                        string=$(dirname "$base_name")
                        dirs["$string"]="NA"
                        totalspace=$((totalspace + size))
                    fi
                fi
                
                #N & D & E FALSE
                #If the user passes 0 arguments it stores all the directories and files (and respective size)
                if [[ "$d_flag" -eq 0 && "$n_flag" -eq 0 && "$e_flag" -eq 0 ]]; then
                    files["$entry"]="NA"
                    string=$(dirname "$entry")
                    dirs["$string"]="NA"
                fi
            fi
            
        fi
        
        #DIRETORIES
        #If it is a directory
        if [[ -d "${entry}" ]]; then
            #Needed to do this assign to an local variable because I was having some problems
            local old_value=$totalspace
            #Recursive Call the function with the $entry (that it is an directory)
            walk $entry
            #Increments the totalspace
            totalspace=$((old_value + totalspace))
        fi
    done
    
    #After the for it stores the directory passed ($1) on the argument
    #with the $totalspace size that was incremented with all the files sizes
    dirs[$1]=$totalspace
}

#NUMERICALLY
if [[ "$r_flag" = 0 && "$a_flag" = 0 ]]; then
    #With the directories passed on the arguments calls the recursive function
    #IFS leads with with spaces on the directories or files names
    IFS=$'\n'
    for item in "$@"; do
        walk "${item}"
    done
    unset IFS
    
    #If the -L flag is on it will print from the Files array
    if [ "$L_flag" = 1 ]; then
        for k in "${!files[@]}"; do
            echo ${files["${k}"]} ${k}
        done | sort -rn -k1 | head -${Lvalue}   #Sorts numerically by the sizes column
    fi
    
    #If the -L flag & -l flag is off it will print from the directories array
    if [[ "$L_flag" = 0 && "$l_flag" = 0 ]]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
        done | sort -rn -k1 #Sorts numerically by the sizes column
    fi
    
    #If the -l flag is on it will print from the List_Dirs array
    declare -A l_dirs_array
    if [ "$l_flag" = 1 ]; then
        for item in ${!dirs[@]}; do
            total=0
            soma=$(builtin cd "$item" && ls -al | grep '^[-l]' | sort -nr -k5 | head -${lvalue} | awk '{ print $5 }')
            for i in $soma; do
                total=$((i+total))
            done
            l_dirs_array["$item"]=$total
        done
        for item in ${!l_dirs_array[@]}; do
            echo ${l_dirs_array["${item}"]} "${item}"
        done | sort -rn -k1 #Sorts numerically by the sizes column
    fi
fi

#NUMERICALLY REVERSE
if [[ "$r_flag" = 1 && "$a_flag" = 0 ]]; then
    #With the directories passed on the arguments calls the recursive function
    #IFS leads with with spaces on the directories or files names
    IFS=$'\n'
    for item in $@; do
        walk "${item}"
    done
    unset IFS
    
    #If the -L flag is on it will print from the Files array
    if [ "$L_flag" = 1 ]; then
        for k in "${!files[@]}"; do
            echo ${files["${k}"]} ${k}
        done | sort -rn -k1 | head -${Lvalue} | sort -n -k1 #Sorts numerically by the sizes column in reverse order
    fi
    
    #If the -L flag & -l flag is off it will print from the directories array
    if [[ "$L_flag" = 0 && "$l_flag" = 0 ]]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
        done | sort -n -k1 #Sorts numerically by the sizes column in reverse order
    fi
    
    #If the -l flag is on it will print from the List_Dirs array
    declare -A l_dirs_array
    if [ "$l_flag" = 1 ]; then
        for item in ${!dirs[@]}; do
            total=0
            soma=$(builtin cd "$item" && ls -al | grep '^[-l]' | sort -nr -k5 | head -${lvalue} | awk '{ print $5 }')
            for i in $soma; do
                total=$((i+total))
            done
            l_dirs_array["$item"]=$total
        done
        for item in ${!l_dirs_array[@]}; do
            echo ${l_dirs_array["${item}"]} "${item}"
        done | sort -n -k1 #Sorts numerically by the sizes column in reverse order
    fi
fi

#ALPHABETICALLY
if [[ "$r_flag" = 0 && "$a_flag" = 1 ]]; then
    #With the directories passed on the arguments calls the recursive function
    #IFS leads with with spaces on the directories or files names
    IFS=$'\n'
    for item in $@; do
        walk "${item}"
    done
    unset IFS
    
    #If the -L flag is on it will print from the Files array
    if [ "$L_flag" = 1 ]; then
        for k in "${!files[@]}"; do
            echo ${files["${k}"]} ${k}
        done | sort -rn -k1 | head -${Lvalue} | sort -r -k2 #Sorts alphabetically by the files column
    fi
    #If the -L flag & -l flag is off it will print from the directories array
    if [[ "$L_flag" = 0 && "$l_flag" = 0 ]]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
        done | sort -k2 #Sorts alphabetically by the directories column
    fi
    
    #If the -l flag is on it will print from the List_Dirs array
    declare -A l_dirs_array
    if [ "$l_flag" = 1 ]; then
        for item in ${!dirs[@]}; do
            total=0
            soma=$(builtin cd "$item" && ls -al | grep '^[-l]' | sort -nr -k5 | head -${lvalue} | awk '{ print $5 }')
            for i in $soma; do
                total=$((i+total))
            done
            l_dirs_array["$item"]=$total
        done
        for item in ${!l_dirs_array[@]}; do
            echo ${l_dirs_array["${item}"]} "${item}"
        done | sort -k2 #Sorts alphabetically by the directories column
    fi
fi

#ALFABETICAMENTE PELOS PATHS REVERSE
if [[ "$r_flag" = 1 && "$a_flag" = 1 ]]; then
    #With the directories passed on the arguments calls the recursive function
    #IFS leads with with spaces on the directories or files names
    IFS=$'\n'
    for item in $@; do
        walk "${item}"
    done
    unset IFS
    
    #If the -L flag is on it will print from the Files array
    if [ "$L_flag" = 1 ]; then
        for k in "${!files[@]}"; do
            echo ${files["${k}"]} ${k}
        done | sort -rn -k1 | head -${Lvalue} | sort -k2 #Sorts alphabetically by the files column in reverse order
    fi
    #If the -L flag & -l flag is off it will print from the directories array
    if [[ "$L_flag" = 0 && "$l_flag" = 0 ]]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
        done | sort -r -k2 #Sorts alphabetically by the directories column in reverse order
    fi
    
    #If the -l flag is on it will print from the List_Dirs array
    declare -A l_dirs_array
    if [ "$l_flag" = 1 ]; then
        for item in ${!dirs[@]}; do
            total=0
            soma=$(builtin cd "$item" && ls -al | grep '^[-l]' | sort -nr -k5 | head -${lvalue} | awk '{ print $5 }')
            for i in $soma; do
                total=$((i+total))
            done
            l_dirs_array["$item"]=$total
        done
        for item in ${!l_dirs_array[@]}; do
            echo ${l_dirs_array["${item}"]} "${item}"
        done | sort -r -k2 #Sorts alphabetically by the directories column
    fi
fi