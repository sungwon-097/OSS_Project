#!/bin/bash

file=$1
if [ ! -d $file ]; then
        mkdir $file
        cd $file
        for i in 0 1 2 3 4
                do
                        touch $file$i.txt
                done
        tar -cvf $file.tar *.txt
        mkdir $file
        ls
        mv $file.tar $file/.
        tar -xf $file/$file.tar -C $file
else
        rm -rf $file
fi