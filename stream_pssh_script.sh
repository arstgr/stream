#!/bin/bash

#SKU type
SKU=$1

export wdir=$(pwd)
sudo yum install pssh -y
echo "beginning date: $(date)"
echo $(hostname) > hosts.txt

if command -v pbsnodes --version &> /dev/null
then
    pbsnodes -avS | grep free | awk -F ' ' '{print $1}' >> hosts.txt
fi

pssh -p 32 -t 0 -i -h hosts.txt "cd $wdir && ./stream_run_script.sh $wdir $SKU" >> stream_pssh.log 2>&1
sleep 60
