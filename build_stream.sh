#! /bin/bash

#export ARRY_SIZE=560000000 #full system
#export ARRY_SIZE=280000000 #half system
export ARRY_SIZE=2621440000

if test -f "stream.c"; then
    rm stream.c
fi

wget https://download.amd.com/developer/eula/aocc/aocc-5-0/aocc-compiler-5.0.0.tar
tar -xf aocc-compiler-5.0.0.tar
cd aocc-compiler-5.0.0
./install.sh
cd ../
source ./setenv_AOCC.sh

wget https://raw.githubusercontent.com/jeffhammond/STREAM/master/stream.c

clang stream.c -fopenmp -mcmodel=large -DSTREAM_TYPE=double -DSTREAM_ARRAY_SIZE=${ARRY_SIZE} -DNTIMES=100 -ffp-contract=fast -fnt-store -O3 -Ofast -ffast-math -ffinite-loops -march=native -zopt -fremap-arrays -mllvm -enable-strided-vectorization -fvector-transform  -o stream


