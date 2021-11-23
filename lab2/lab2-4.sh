#!/bin/bash

echo "리눅스가 재미있나요?(yes/no)"
read num
case $num in
	y*|Y*) echo "yes";;
	n*|N* ) echo "no";;
	*) echo "yes or no로 입력해 주세요.";;
esac
