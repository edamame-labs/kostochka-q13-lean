#!/bin/bash
# Exhaustive search (search.py + selc) over all forests on n vertices and all k-list
# assignments from a palette of size p. Results go to scripts/out/n<n>_k<k>_p<p>.txt.
# The runs below finish in minutes to hours on a laptop; larger palettes are infeasible.
cd "$(dirname "$0")"
gcc -O2 -o selc selc.c || exit 1
mkdir -p out
for args in "6 3 5" "7 3 5" "8 3 5" "9 3 4" "10 3 4" "11 3 4" "12 3 4" \
            "6 4 5" "7 4 6" "8 4 5" "9 4 5" "10 4 5" "11 4 5" \
            "7 5 6" "8 5 6" "9 5 6" "10 5 6"; do
  set -- $args
  python3 search.py $1 $2 $3 --first > out/n$1_k$2_p$3.txt 2>&1
  grep SUMMARY out/n$1_k$2_p$3.txt
done
