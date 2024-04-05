#!/bin/bash

cmd="taskset -c 24-47 ./schbench_lx -r30 -n10 -F128 $@"
echo "$cmd"

$cmd
