#!bin/bash

if [ ! -d DB.txt ]; then
	touch DB.txt
fi
echo $* > DB.txt
