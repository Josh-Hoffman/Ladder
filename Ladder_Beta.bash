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


Ladder () {

Input=$1
cat $1 > .$1.bak
declare -ag Checks=( $(awk -F'_|=|#|}' '/#MD5/ && !/awk/ {gsub("\t", "");print $3"="$4}' $1)
$(awk -F'[_|=|#|}]' '/#MD5/ && !/awk/ {gsub("MD5", "Size");print $3"="$5}' $1) )
declare -Ag ${Checks[@]}
MD5_All=$(echo ${MD5[@]} | tr ' ' '|')
Unchecked="$(awk '{gsub(/'${MD5_All}'/, ""); print $0}' .$1.bak)"

	for Steps in ${!MD5[@]}; do
	declare -Ag Functions[$Steps]="$(echo "$Unchecked" | awk '/'"$Steps \(\) \{"'/,/'#MD5[$Steps]'/')"
	declare -Ag MD5_New[$Steps]="$(echo "${Functions[$Steps]}" | awk '{gsub(/'${MD5[$Steps]}'/, ""); print $0}' | md5sum | cut -c 1-32)"
	declare -Ag Size_New[$Steps]=$(echo ${Functions[$Steps]} | wc -c)
	
		if [[ ${MD5_New[${Steps}]} != ${MD5[${Steps}]} ]]; then
		Updated=$(date +'%H_%M_%S-%m/%d/%y')
		Substring="gsub("/${MD5[${Steps}]}"_"${Size[${Steps}]}"/, \""${MD5_New[${Steps}]}_${Size_New[${Steps}]}_${Updated}"\");$Substring"
		fi

	done

awk '{'"$Substring"'print $0}' .$1.bak > $1

}

Ladder $@
