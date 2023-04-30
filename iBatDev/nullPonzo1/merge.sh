#!/bin/sh
awk '(NR == 1) || (FNR > 1)' *p*.csv > merged.csv
