#!/bin/bash
as --noexecstack -g -mfpu=vfpv2 -al -o $1.o $1.s > $1.lst
gcc -o $1 $1.o
rm $1.o
./$1 ; echo $?