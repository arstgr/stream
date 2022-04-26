#! /bin/bash

VM_SKU=$(curl --connect-timeout 10 -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2018-04-02" | jq '.compute.vmSize')
VM_SKU="${VM_SKU%\"}"
VM_SKU="${VM_SKU#\"}"

if test -f "stream.c"; then
    rm stream.c
fi

wget https://developer.amd.com/wordpress/media/files/aocc-compiler-3.2.0.tar
tar -xf aocc-compiler-3.2.0.tar
cd aocc-compiler-3.2.0
./install.sh
cd ../
source ./setenv_AOCC.sh

wget https://raw.githubusercontent.com/jeffhammond/STREAM/master/stream.c

clang stream.c -fopenmp -mcmodel=large -DSTREAM_TYPE=double -mavx2 -DSTREAM_ARRAY_SIZE=260000000 -DNTIMES=100 -ffp-contract=fast -fnt-store -O3 -ffast-math -ffinite-loops -arch zen2 -o stream


