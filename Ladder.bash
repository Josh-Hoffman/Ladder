#!/bin/bash

Ladder () {

Input=$1
cat $1 > .$1.bak

declare -ag Checks=( $(awk '/#MD5/ && !/awk/ {print $2}' .$1.bak | tr -d \#) )
declare -AG ${Checks[@]}

	for Steps in ${!MD5[@]}; do
	declare -Ag Functions[$Steps]="$(awk '/'"$Steps \(\) \{"'/,/'${MD5[$Steps]}'/' .$1.bak )"
	done
	
	if [[ ${Ladder_1:=1} = 1 ]]; then
	
		for Verify in ${!Functions[@]}; do
		declare -Ag MD5_New[$Verify]="$(echo "${Functions[$Verify]}" | awk '{gsub(/'${MD5[$Verify]}'/, ""); print $0}' | md5sum | cut -c 1-32)"
		done
		
	fi
		
	for Edit in ${!Functions[@]}; do
		
		if [[ ${MD5[$Edit]} != ${MD5_New[$Edit]} ]]; then
		declare -Ag Functions_New[$Edit]="$(echo "${Functions[$Edit]}" | awk '{gsub(/'${MD5[$Edit]}'/, "'${MD5_New[$Edit]}'"); print $0}')"
		awk '{gsub(/'${MD5[$Edit]}'/, "'${MD5_New[$Edit]}'"); print $0}' .$1.bak | tee .$1.bak
		fi
		
	done
	
}

Ladder $@