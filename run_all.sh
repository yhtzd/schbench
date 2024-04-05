#!/bin/bash

tag=$1
dir=results_24_$tag

cmd="sudo chrt 99 taskset -c 24-47 ./schbench_lx -n10 -F128 -m1 -r10"

mkdir -p $dir
echo "cores,lat99,rps50" > $dir/all.csv

cores="4 8 16 24 32 40 48 64 72 80 96 112 128 144 160 176 192 208 224 240 256"
for i in $cores; do
    echo "Running with $i cores"
    output="$dir/$i.txt"
    $cmd -t$i 2>&1 | tee $output

    wake=$(cat $output | grep -a "* 99.0th" | tail -n2 | head -n1 | awk '{print $3}')
    lat=$(cat $output | grep -a "* 99.0th" | tail -n1 | awk '{print $3}')
    rps=$(cat $output | grep -a "* 50.0th" | tail -n1 | awk '{print $3}')
    echo "$i,$wake,$rps,$lat"
    echo "$i,$wake,$rps,$lat" >> $dir/all.csv
done
