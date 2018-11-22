declare -A dirs
for entry in $@; do
    if [[ -d "${entry}" ]]; then
        root=$entry
        # echo $root
        dirs["${root}"]=0;
    fi
done
declare -A files
walk() {
    # Se e um diretorio chama a walk() ---> recursiva
    for entry in "$1"/*; do
        # dir["${entry}"]=0
        if [[ -f "$entry" ]]; then
            
            if [[ -v files[$entry] ]]; then
                file="${file}"
                size="$(stat $file | head -2 | tail -1 | awk '{print $2}')"
                old_size=files["$file"]
                new_size=$((old_size+size))
                files[$file]=$new_size
            else
                file="${entry}"
                # dir=${entry##*/}
                # echo $dir
                files["$file"]=0
                size="$(stat $file | head -2 | tail -1 | awk '{print $2}')"
                files["$file"]=$size
            fi
        fi
        if [[ -d "${entry}" ]]; then
            dirs[$entry]=0
            # echo $entry
            walk $entry
        fi
    done
}