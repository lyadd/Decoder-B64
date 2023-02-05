#!/bin/bash

# Base64 routine de décodage écrite entièrement en bash, sans dépendances externes. 
#
# Utilisation :
#   base64decode < input > output
#
# Ce code est absurdement inefficace; il fonctionne environ 12 000 fois plus lentement que
# le décodeur basé sur perl. La différence est que ce code ne vous oblige pas à
# installez tous les programmes externes, ce qui peut être important dans certains cas.
#
# Pour voir le decoder perl -> /decoder.pl

base64decode() {
	L=0
	A=0
	P=0
	while read -n1 C ; do
		printf -v N %i \'"$C"
		if (( $N == 61 )) ; then
			P=$(( $P + 1 )) # = (padding)
			V=0
		elif (( $N == 43 )) ; then
			V=62 # +
		elif (( $N == 47 )) ; then
			V=63 # /
		elif (( $N < 48 )) ; then
			continue
		elif (( $N < 58 )) ; then
			V=$(( $N + 4 )) # -48 + 52 (0-9)
		elif (( $N < 65 )) ; then
			continue
		elif (( $N < 91 )) ; then
			V=$(( $N - 65 )) # -65 + 0 (A-Z)
		elif (( $N < 97 )) ; then
			continue
		elif (( $N < 123 )) ; then
			V=$(( $N - 71 )) # -97 + 26 (a-z)
		else
			continue
		fi
			
		A=$(( ($A << 6) | $V ))
		L=$(( $L + 1 )) 

		if [ $L == 4 ] ; then
			printf -v X "%x" $(( ($A >> 16) & 0xFF ))
			printf "\x$X"
			if (( $P < 2 )) ; then
				printf -v X "%x" $(( ($A >> 8) & 0xFF ))
				printf "\x$X"
			fi
			if (( $P == 0 )) ; then
				printf -v X "%x" $(( $A & 0xFF ))
				printf "\x$X"
			fi 
			A=0
			L=0
			P=0
		fi
	done
}

base64decode 