#!/bin/bash -x

TARGET_HOST=10.0.0.212
BENCH_HOST=10.0.0.250

ssh -T isu-bench-01 << EOSSH > /dev/null
set -x
cd /home/isucon/isucari
bin/benchmarker -target-url=https://$TARGET_HOST/ -shipment-url=http://$BENCH_HOST:7000 -payment-url=http://$BENCH_HOST:5555
EOSSH
