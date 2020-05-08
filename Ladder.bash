#!/bin/bash
#    _________________________________________________________________________________________________
#   |* ___________________________________________GPL-3_Licence_____________________________________ *|
#   | /                                                                                             \ |
#   | |         This program is free software: you can redistribute it and/or modify                | |
#   | |         it under the terms of the GNU General Public License as published by                | |
#   | |         the Free Software Foundation, either version 3 of the License, or                   | |
#   | |         (at your option) any later version.                                                 | |
#   | |                                                                                             | |
#   | |         This program is distributed in the hope that it will be useful,                     | |
#   | |         but WITHOUT ANY WARRANTY; without even the implied warranty of                      | |
#   | |         MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                       | |
#   | |         GNU General Public License for more details.                                        | |
#   | |                                                                                             | |
#   | |         You should have received a copy of the GNU General Public License                   | |
#   | |         along with this program.  If not, see <http://www.gnu.org/licenses/>.               | |
#   | |                                                                                             | |
#   | \_____________________________________________________________________________________________/ |
#   |* _________________________________________Ladder_5/8/2020_____________________________________ *|
#   | /                                                                                             \ |
#   | |                                    Written by: Joshua Hoffman                               | |
#   | |                                 joshua.hoffman.ray@protonmail.com                           | |
#   | |                                                                                             | |
#   | \________________________________________Modulation_Project___________________________________/ |
#   |_________________________________________________________________________________________________|


Ladder () { #System
	
	Osha () { #Safty
	
	Safty=$(awk -F'[\{| ]' '/#Safty/ {print $3}' $0 | tr -d '\n')
	First=$(awk '/#Safty-/,/'$First'/ {gsub(/'$Safty'/, "");print $0}' "$0" | md5sum | cut -c 1-32) 
	
		if [[ $Safty = $First ]]; then 
		Looks=$(awk -F'[\{| ]' '/#System/ {print $3}' "$0" | tr -d '\n')
		Twice=$(awk '/"#System-"/,/'$Looks'/ {gsub(/'$Looks'|'$Safty'/, "");print $0}' "$0" | md5sum | cut -c 1-32)
		
			if [[ $Looks = $Twice ]]; then
			return 0
			fi
	
		fi
	${Ladder_Error:+echo -e "Source system checksum mismatch!\\nIntegrity cannot be verfied!"}
	${Ladder_Return:=exit} 1
	} #Safty: 90e9d598dac7ad8c34dd2e239a9aa1a3

Osha

Input=$Input && Input=${Input:=$0}
cat "$Input" > .$Input.bak
declare -ag Checks=( $(awk -F'_|=|#|}' '/#MD5/ && !/awk/ {gsub("\t", "");print $3"="$4}' "$Input")
$(awk -F'[_|=|#|}]' '/#MD5/ && !/awk/ {gsub("MD5", "Size");print $3"="$5}' "$Input") )
declare -Ag ${Checks[@]}
MD5_All=$(echo ${MD5[@]} | tr ' ' '|')
Unchecked="$(awk '{gsub(/'${MD5_All}'/, ""); print $0}' ".$Input.bak")"

	for Steps in ${!MD5[@]}; do
	declare -Ag Functions[$Steps]="$(echo "$Unchecked" | awk '/'"$Steps \(\) \{"'/,/'#MD5[$Steps]'/')"
	declare -Ag MD5_New[$Steps]="$(echo "${Functions[$Steps]}" | awk '{gsub(/'${MD5[$Steps]}'/, ""); print $0}' | md5sum | cut -c 1-32)"
	declare -Ag Size_New[$Steps]=$(echo ${Functions[$Steps]} | wc -c)

		if [[ ${MD5_New[${Steps}]} != ${MD5[${Steps}]} ]]; then
		Updated=$(date +'%H_%M_%S-%m/%d/%y') 
		Substring="gsub("/${MD5[${Steps}]}"/, \""${MD5_New[${Steps}]}"\");$Substring"
		fi

	done

awk '{'"$Substring"'print $0}' ".$Input.bak" > $Input

} #System: 6227e7c25056323b44a1cec860f6f766

Ladder
