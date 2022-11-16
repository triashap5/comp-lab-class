#!/bin/bash

for i in 1.4 1.5
do 
	mpirun -np 1 lmp -var density $i  -in 3dWCA-vel-change.in -log LOGFILE_$i.log 
done
