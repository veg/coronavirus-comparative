#!/bin/bash

git clone https://github.com/veg/hyphy-analyses.git
git clone https://github.com/veg/hyphy.git hyphy-develop
cd hyphy-develop

#git checkout latest hyphy 
git checkout origin/develop


cmake -DNOAVX=ON .
make  -j MP
make -j MPI
cd ..


#unzip tar_ball/02JUN2020.zip

#mv 02JUN2020/refs/* refs/
#mv 02JUN2020/fasta/* data/fasta

