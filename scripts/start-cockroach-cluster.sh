#!/bin/bash

cockroach start \
--insecure \
--store=db/cockroach/node1 \
--listen-addr=localhost:26257 \
--http-addr=localhost:8070 \
--join=localhost:26257,localhost:26258,localhost:26259 \
--background

cockroach start \
--insecure \
--store=db/cockroach/node2 \
--listen-addr=localhost:26258 \
--http-addr=localhost:8071 \
--join=localhost:26257,localhost:26258,localhost:26259 \
--background

cockroach start \
--insecure \
--store=db/cockroach/node3 \
--listen-addr=localhost:26259 \
--http-addr=localhost:8072 \
--join=localhost:26257,localhost:26258,localhost:26259 \
--background

cockroach init --insecure --host=localhost:26257

grep 'node starting' db/cockroach/node1/logs/cockroach.log -A 11
#grep 'node starting' db/cockroach/node2/logs/cockroach.log -A 11
#grep 'node starting' db/cockroach/node3/logs/cockroach.log -A 11

cockroach sql --insecure --host=localhost:26257
