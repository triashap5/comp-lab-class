#!/bin/bash

for i in 0.5 0.6 0.7 0.8 0.9 1.0 1.1
do 
	mpirun lmp -var density $i  -in 2dWCA.in -log LOGFILE_$i.log 
done
