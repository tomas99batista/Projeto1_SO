#!/bin/bash
#89296 Tomas Batista
#89236 Joao Dias
#SO Trabalho Pratico 1
set -e
set -u
set -o pipefail

#-------------------------------------------------------------------------------------------------------------------------------------------------------
#//TODO: Tratar da -l depois da walk()
#//TODO: NA (fix)
#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Initializes all flags at 0
#If they are passed by the user they will be set to 1
n_flag=0
l_flag=0
d_flag=0
L_flag=0
r_flag=0
a_flag=0

#GETOPTS WILL GET THE OPTIONS PASSED BY THE USER
while getopts ':n:f:l:d:L:ra' OPTION; do
    case "$OPTION" in
        n)
            n_flag=1
            nvalue="$OPTARG"
        ;;
        l)
            l_flag=1
            lvalue="$OPTARG"
        ;;
        d)
            d_flag=1
            dvalue="$OPTARG"
        ;;
        L)
            L_flag=1
            Lvalue="$OPTARG"
        ;;
        r)
            r_flag=1
        ;;
        a)
            a_flag=1
        ;;
        \?)
            echo "$(basename $0) OPTIONS: [-n arg] [-l arg] [-d arg] [-L arg] [-r] [-a]" >&2
            exit 1
        ;;
    esac
done
shift "$((OPTIND - 1))"

#If -l and -L are passed to the function, display an error message and exits the script
if [[ $l_flag == 1 && $L_flag == 1 ]]; then
    printf "Not possible to combine -l and -L, try again please.\n"
    exit 1  #1=code error
fi

#This if checks if the -d option argument (a date) is true, $? -eq 0 means true
#If it is true it convert the argument of -d to a date
if [ "$d_flag" = 1 ]; then
    if [ $? -eq 0 ]; then
        arg_date=$(date -d $dvalue "+%s")
    fi
fi

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
            
            #If it is readable
            if [[ -r "$entry" ]]; then
                #Get the size and the data of the file
                size=$(stat $entry | head -2 | tail -1 | awk '{print $2}')
                file_data=$(stat $entry | tail -4 | head -1 | awk '{print $2, $3}')
                #If l FALSE
                if [[ "$l_flag" -eq 0 ]]; then
                    #D & N TRUE
                    if [[ "$d_flag" -eq 1 && "$n_flag" -eq 1 ]]; then
                        base_name="$(basename "${entry}")"
                        #If the file name it contains parts (or it is totally equal) it passes
                        if [[ "$base_name" =~ ^$nvalue$ ]]; then
                            file_d=$(date -d "$file_data" +%s)
                            #If the file it is older than the date passed on argument it will store
                            if [[ "$arg_date" -ge "$file_d" ]]; then
                                #It stores the path with file on the files array and it stores the size value
                                files["${entry}"]=$size
                                string=$(dirname "$entry")
                                #It stores the path on the directories array and it stores the size
                                dirs["$string"]+=$size
                                #Increment the total space
                                totalspace=$((totalspace + size))
                            fi
                        fi
                    fi
                    
                    #D TRUE
                    if [[ "$d_flag" -eq 1 && "$n_flag" -eq 0 ]]; then
                        file_data=$(date -d "$file_data" +%s)
                        #If the last modify on the file it is older than the date passed on the argument
                        #it stores the file and the directory path (and respective size)
                        if [ "$arg_date" -ge "$file_data" ]; then
                            files["${entry}"]=$size
                            string=$(dirname "$entry")
                            dirs["$string"]+=$size
                            totalspace=$((totalspace + size))
                        fi
                    fi
                    
                    #N TRUE
                    if [[ "$d_flag" -eq 0 && "$n_flag" -eq 1 ]]; then
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
                    
                    #N & D FALSE
                    #If the user passes 0 arguments it stores all the directories and files (and respective size)
                    if [[ "$d_flag" -eq 0 && "$n_flag" -eq 0 ]]; then
                        files["$entry"]=$size
                        string=$(dirname "$entry")
                        dirs["$string"]+=$size
                        totalspace=$((size + totalspace))
                    fi
                fi
            fi
            
            #If the file it is not readable it will store the value of 'NA'
            if ! [[ -r "$entry" ]]; then
                size="NA"
                file_data=$(stat $entry | tail -4 | head -1 | awk '{print $2, $3}')
                #l FALSE
                if [[ "$l_flag" -eq 0 ]]; then
                    
                    #D & N TRUE
                    if [[ "$d_flag" -eq 1 ]] && [[ "$n_flag" -eq 1 ]]; then
                        base_name="$(basename "${entry}")"
                        #If the file name it contains parts (or it is totally equal) it passes
                        if [[ "$base_name" =~ ^$nvalue$ ]]; then
                            file_d=$(date -d "$file_data" +%s)
                            #If the file it is older than the date passed on argument it will store
                            if [[ "$arg_date" -ge "$file_d" ]]; then
                                #It stores the path with file on the files array and it stores the size value
                                files["${entry}"]="NA"
                                #It stores the path on the directories array and it stores the size
                                string=$(dirname "$entry")
                                #Increment the total space
                                dirs["$string"]="NA"
                            fi
                        fi
                    fi
                    
                    #D TRUE
                    if [[ "$d_flag" -eq 1 ]]; then #only d true
                        file_data=$(date -d "$file_data" +%s)
                        #If the last modify on the file it is older than the date passed on the argument
                        #it stores the file and the directory path (and respective size)
                        if [ "$arg_date" -ge "$file_data" ]; then
                            files["${entry}"]="NA"
                            string=$(dirname "$entry")
                            dirs["$string"]="NA"
                        fi
                    fi
                    
                    #N TRUE
                    if [[ "$n_flag" -eq 1 ]]; then
                        base_name="$(basename "${entry}")"
                        #If the name of the file contains (or it is totally equals) it stores
                        #the file name and the directory path (and respective size)
                        if [[ "$base_name" =~ ^$nvalue$ ]]; then
                            files["${base_name}"]="NA"
                            string=$(dirname "$base_name")
                            dirs["$string"]="NA"
                        fi
                    fi
                    
                    #N & D FALSE
                    #If the user passes 0 arguments it stores all the directories and files (and respective size)
                    if [[ $d_flag -eq 0 && $n_flag -eq 0 ]]; then
                        files["$entry"]="NA"
                        string=$(dirname "$entry")
                        dirs["$string"]="NA"
                    fi
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
    #If the -L flag is off it will print from the directories array
    if [ "$L_flag" = 0 ]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
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
    #If the -L flag is off it will print from the directories array
    if [ "$L_flag" = 0 ]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
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
    #If the -L flag is off it will print from the directories array
    if [ "$L_flag" = 0 ]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
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
    #If the -L flag is off it will print from the directories array
    if [ "$L_flag" = 0 ]; then
        for item in ${!dirs[@]}; do
            echo ${dirs["${item}"]} "${item}"
        done | sort -r -k2 #Sorts alphabetically by the directories column in reverse order
    fi
fi