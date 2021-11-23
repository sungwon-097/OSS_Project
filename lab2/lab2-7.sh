#!/bin/bash

file=$1
if [ ! -d $file ]; then
        mkdir $file
        cd $file
        for i in 0 1 2 3 4
                do
                        touch $file$i.txt
			mkdir $file$i
			cd $file$i
			ln -s ./$file$i.txt $file$i.txt
			cd ..
                done
        ls
else
        rm -rf $file
fi
