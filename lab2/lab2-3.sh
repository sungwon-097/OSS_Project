#!/bin/bash

weight=${1}
height=`expr ${2} \* ${2}`
bmi=$(bc <<< "scale=1; (10000 * $weight / $height)")
echo $bmi
if (( $(echo "$bmi < 18.5" |bc -l) )); then
	echo "저체중"
elif (( $(echo "$bmi < 23" |bc -l) )); then
	echo "정상체중"
else
	echo "과체중"
fi

