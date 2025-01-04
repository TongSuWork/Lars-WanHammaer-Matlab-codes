#!/usr/bin/env bash

#Copyright (C) 2008 Anton Blad, Oscar Gustafsson.
#This file is licensed under a modified version of GPL v2, see the file
#LICENSE for details.

if [ $# -lt 2 ]; then
	echo "usage $0 problem.sol workdir"
	exit 1
fi

solfile="$1"
workdir="$2"

extracts1="OutBits"
extracts2="bits FA HA regs cinput inbits"

statusfile="${workdir}/struc.status"

status=`cat ${solfile} | sed -n "/^solution status:/s/^solution status:[[:space:]]*\(.*\)$/\1/; T; p"`
if [ "${status}" = "infeasible" ]; then
	echo 0 > ${statusfile}
elif [ "${status}" = "optimal solution found" ]; then
	echo 1 > ${statusfile}
else
	echo -1 > ${statusfile}
fi

for ext in ${extracts1}; do
	extfile=${workdir}/struc.${ext}
	cat ${solfile} | sed -n "/^${ext}/s/^${ext}(\([[:digit:]]*\))[[:space:]]*\([[:digit:]]*\).*$/\1 \2/; T; p" | sort -nk1 > ${extfile}
done

for ext in ${extracts2}; do
	extfile=${workdir}/struc.${ext}
	cat ${solfile} | sed -n "/^${ext}/s/^${ext}(\([[:digit:]]*\),\([[:digit:]]*\))[[:space:]]*\([[:digit:]]*\).*$/\1 \2 \3/; T; p" | sort -nk1 -k2 > ${extfile}
done

