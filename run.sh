#!/bin/bash

args="-i1 -r5 -n5 -F256 $@"
echo "./schbench $args"

./schbench_lx $args
