#!/bin/bash

add=`expr ${1} + ${3}`
sub=`expr ${1} - ${3}`

if [ ${2} = "+" ]; then
	echo $add
else
	echo $sub	
fi
