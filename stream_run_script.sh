#!/bin/bash

#current directory
wdir=$1
#SKU name
SKU=$2

cd $wdir
mkdir stream-$(hostname | tr "[:upper:]" "[:lower:]")
cd stream-$(hostname | tr "[:upper:]" "[:lower:]")
cp ../stream .
source ../setenv_AOCC.sh

if [[ $SKU == "hbrs_v2" ]]; then
    export OMP_NUM_THREADS=32
    export GOMP_CPU_AFFINITY="0,1,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,61,64,68,72,76,80,84,88,92,96,100,104,108,112,116"
elif [[ $SKU == "hbrs_v3" ]]; then
    export OMP_NUM_THREADS=16
    export GOMP_CPU_AFFINITY="0,8,16,24,30,38,46,54,60,68,76,84,90,98,106,114"
elif [[ $SKU == "hbrs_v4" ]]; then
    export OMP_NUM_THREADS=176
    export GOMP_CPU_AFFINITY="0-175"
elif [[ $SKU == "hbrs_v5" ]]; then
    export OMP_NUM_THREADS=384
    export GOMP_CPU_AFFINITY="0-383"
elif [[ $SKU == "ndm_v4" ]]; then
    export OMP_NUM_THREADS=24
    export GOMP_CPU_AFFINITY="0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76,80,84,88,92"
elif [[ $SKU == "ndm_v4_asr112" ]]; then
    export OMP_NUM_THREADS=28
    export GOMP_CPU_AFFINITY="0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76,80,84,88,92,96,100,104,108"
fi

sync; echo 3 | sudo tee /proc/sys/vm/drop_caches
echo always | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo always | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
#echo 3 | sudo tee /proc/sys/vm/drop_caches
#echo 1 | sudo tee /proc/sys/kernel/numa_balancing

export OMP_SCHEDULE=static
export OMP_DYNAMIC=false
export OMP_THREAD_LIMIT=512
#export OMP_NESTED=FALSE
export OMP_STACKSIZE=8192M

./stream | tee stream-$(hostname | tr "[:upper:]" "[:lower:]").log

#echo "system: $(hostname | tr "[:upper:]" "[:lower:]") stream: $(grep 'Triad:' stream-$(hostname | tr "[:upper:]" "[:lower:]").log | awk '{print $2}') MB/s" >> ../stream-test-results.log

echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
