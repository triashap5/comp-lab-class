#!/bin/bash

for i in 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5
do 
	mpirun -np 1 lmp -var density $i  -in 3dWCA.in -log LOGFILE_$i.log 
done
