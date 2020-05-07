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
#   |* _________________________________________Ladder_5/7/2020_____________________________________ *|
#   | /                                                                                             \ |
#   | |                                    Written by: Joshua Hoffman                               | |
#   | |                                 joshua.hoffman.ray@protonmail.com                           | |
#   | |                                                                                             | |
#   | \________________________________________Modulation_Project___________________________________/ |
#   |_________________________________________________________________________________________________|


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
