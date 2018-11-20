#Function recursiva para listar diretorios
percorrer() {
    printf "\n%s\n\n"  "$1"
    # Se e um diretorio chama a percorrer() ---> recursiva
    for entry in "$1"/*; do [[ -d "$entry" ]] && percorrer "$entry"; done
    # Se e um file vai para file_specs()
    for entry in "$1"/*; do [[ -f "$entry" ]] && file_specs; done
    
}

file_specs() {
    FILE_NAME="$(basename "${entry}")"
    DIR="$(dirname "${entry}")"
    NAME="${FILE_NAME%.*}"
    EXT="${FILE_NAME##*.}"
    
    SIZE="$(stat $entry | head -2 | tail -1 | awk '{print $2}')"
    printf "\n%s\n" "${entry}"
    # printf "\tFile size:\t%s\n" "$SIZE"
    echo $SIZE
    # printf "\tName only:\t%s\n" "$NAME"
    echo $NAME
}
for item in $@; do
    [[ -z "${item}" ]] && ABS_PATH="${PWD}" || cd "${item}" && ABS_PATH="${PWD}"
    percorrer "${ABS_PATH}" 
done