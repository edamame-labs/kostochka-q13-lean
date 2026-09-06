#!/bin/bash
cd "$(dirname "$0")"
for args in "9 3 5" "10 3 5" "9 3 6" "11 3 5" "10 3 6" "12 3 5" "9 4 6" "10 4 6" "11 3 6"; do
  set -- $args
  python3 cegis.py $1 $2 $3 > out/cegis_n$1_k$2_p$3.txt 2>&1
done
echo DONE > out/CEGIS_DONE
