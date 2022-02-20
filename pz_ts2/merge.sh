#!/bin/sh
awk '(NR == 1) || (FNR > 1)' pz_ts2_p*.csv > merged.csv
