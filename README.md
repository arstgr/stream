# stream
Stream Memory Benchmark: builds the stream benchmark using AMD's AOCC, and runs it on AMD's H series VMs on Azure.

## Getting Started
The test depends on clang (AMD's AOCC). 

To Build:
```
sh build_stream.sh
```

To Run:
```
sh stream_run_script.sh $PWD $SKU
```
where "SKU" is the hardware type (currently AMD's Genoa aka hbrs_v4, MilanX aka hbrs_v3 and Naple aka hbrs_v2).

Stream triad numbers of greater than 750 MB/s and 350 MB/s are generally a pass for hbrs_v4 and hbrs_v3 (and v2) respectively. More SKU types to be added in future. 

