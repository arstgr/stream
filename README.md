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
export VM_SERIES=hbrs_v3
sh run_stream.sh
```


