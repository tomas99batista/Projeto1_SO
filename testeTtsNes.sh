#!/bin/bash

echo "Totalspace: Caso -a pasta:"

bash totalspace.sh -a $1

echo "=================================================================="

echo "Totalspace: Caso -r pasta:"

bash totalspace.sh -r $1

echo "=================================================================="

echo "Totalspace: Caso -a -r pasta:"

bash totalspace.sh -a -r $1

echo "=================================================================="

echo "Totalspace: Caso -r -a pasta:"

bash totalspace.sh -a -r $1

echo "=================================================================="

echo "Totalspace: Caso -l 10 pasta:"

bash totalspace.sh -l 10 $1

echo "=================================================================="

echo "Totalspace: Caso -L 50 pasta:"

bash totalspace.sh -L 10 $1

echo "=================================================================="

echo "Totalspace: Caso -L 50 pasta:"

bash totalspace.sh -L 10 $1

echo "=================================================================="

echo "Totalspace: Caso -n .*sh pasta:"

bash totalspace.sh -n ".*sh" $1

echo "=================================================================="

echo "Totalspace: Caso -d 2020/02/02 pasta:"

bash totalspace.sh -d "2020/02/02" $1

echo "=================================================================="

echo "Totalspace: Caso -n .*sh -d 2020/02/02 pasta:"

bash totalspace.sh -n ".*sh" -d "2020/02/02" $1

echo "=================================================================="

echo "Totalspace: Caso -a -r - l 4 -n .*sh -d 2020/02/02 pasta:"

bash totalspace.sh -a -r -l 4 -n ".*txt" -d "2020/02/02" $1

echo "=================================================================="

echo "Totalspace: Caso -a -r -L 4 -n .*sh -d 2020/02/02 pasta:"

bash totalspace.sh -a -r -L 4 -n ".*sh" -d "2020/02/02" $1

echo "=================================================================="

echo "Totalspace: Caso -a -r -L 3 -l 4 -n .*sh -d 2020/02/02 pasta:"

bash totalspace.sh -a -r -L 3 -l 4 -n ".*sh" -d "2020/02/02" $1

echo "------------------------------------------nespace---------------------------------------------"

echo "Nespace: Caso -a pasta:"

bash nespace -a $1

echo "=================================================================="

echo "Nespace: Caso -r pasta:"

bash nespace.sh -r $1

echo "=================================================================="

echo "NespaceCaso -a -r pasta:"

bash nespace.sh -a -r $1

echo "=================================================================="

echo "Nespace: Caso -r -a pasta:"

bash nespace.sh -a -r $1

echo "=================================================================="

echo "Nespace: Caso -l 10 pasta:"

bash nespace.sh -l 10 $1

echo "=================================================================="

echo "Nespace: Caso -L 50 pasta:"

bash nespace.sh -L 10 $1

echo "=================================================================="

echo "Nespace: Caso -L 50 pasta:"

bash nespace.sh -L 10 $1

echo "=================================================================="

echo "Nespace: Caso -n .*sh pasta:"

bash nespace.sh -n ".*sh" $1

echo "=================================================================="

echo "Nespace:Caso -d 2020/02/02 pasta:"

bash nespace.sh -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -n ".*sh" -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -a -r - l 4 -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -a -r -l 4 -n ".*txt" -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -a -r -L 4 -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -a -r -L 4 -n ".*sh" -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -a -r -L 3 -l 4 -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -a -r -L 3 -l 4 -n ".*sh" -d "2020/02/02" $1

echo "Nespace: Caso -e 1.txt -a pasta:"

bash nespace.sh -e 1.txt -a $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -r pasta:"

bash nespace.sh -e 1.txt -r $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -a -r pasta:"

bash nespace.sh -e 1.txt -a -r $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -r -a pasta:"

bash nespace.sh -e 1.txt -a -r $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -l 10 pasta:"

bash nespace.sh -e 1.txt -l 10 $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -L 50 pasta:"

bash nespace.sh -e 1.txt -L 10 $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt-L 50 pasta:"

bash nespace.sh -e 1.txt -L 10 $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt-n .*sh pasta:"

bash nespace.sh -e 1.txt -n ".*sh" $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -d 2020/02/02 pasta:"

bash nespace.sh -e 1.txt -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -e 1.txt -n ".*sh" -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -a -r - l 4 -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -e 1.txt -a -r -l 4 -n ".*txt" -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -a -r -L 4 -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -e 1.txt -a -r -L 4 -n ".*sh" -d "2020/02/02" $1

echo "=================================================================="

echo "Nespace: Caso -e 1.txt -a -r -L 3 -l 4 -n .*sh -d 2020/02/02 pasta:"

bash nespace.sh -e 1.txt -a -r -L 3 -l 4 -n ".*sh" -d "2020/02/02" $1


