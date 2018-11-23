# files["$entry"]=$size
# totalspace=$((size + totalspace))
declare -A authors
authors=( [Pushkin]=10050 [Gogol]=23 [Dostoyevsky]=9999 [Tolstoy]=23 )

for k in "${!authors[@]}"
do
    echo $k ' - ' ${authors["$k"]}
done | sort -rn -k3