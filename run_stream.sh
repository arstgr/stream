#!/bin/bash
export wdir=$(pwd)

sudo yum install pssh -y

echo "beginning date: $(date)"
echo $(hostname) > hosts.txt
if command -v pbsnodes --version &> /dev/null
then
	pbsnodes -avS | grep free | awk -F ' ' '{print $1}' >> hosts.txt
fi

if [ "${VM_SERIES}" == "hbrs_v3" ]; then
	pssh -p 194 -t 0 -i -h hosts.txt "sync; echo 3 | sudo tee /proc/sys/vm/drop_caches; export OMP_SCHEDULE=static; export OMP_DYNAMIC=false; export OMP_THREAD_LIMIT=256; export OMP_NESTED=FALSE; export OMP_STACKSIZE=256M; export OMP_NUM_THREADS=16; export GOMP_CPU_AFFINITY='0,8,16,24,30,38,46,54,60,68,76,84,90,98,106,114'; cd $wdir; ./stream" >> stream_pssh.log 2>&1
elif [ "${VM_SERIES}" == "hbrs_v2" ]; then
	pssh -p 194 -t 0 -i -h hosts.txt "sync; echo 3 | sudo tee /proc/sys/vm/drop_caches; export OMP_SCHEDULE=static; export OMP_DYNAMIC=false; export OMP_THREAD_LIMIT=256; export OMP_NESTED=FALSE; export OMP_STACKSIZE=256M; export OMP_NUM_THREADS=32; export GOMP_CPU_AFFINITY='0,1,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,61,64,68,72,76,80,84,88,92,96,100,104,108,112,116'; cd $wdir; ./stream" >> stream_pssh.log 2>&1
fi

sleep 60
echo "end date: $(date)"
