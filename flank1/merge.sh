#!/bin/sh
awk '(NR == 1) || (FNR > 1)' f*.csv > merged.csv
