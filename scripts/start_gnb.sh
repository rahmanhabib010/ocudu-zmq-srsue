#!/bin/bash
set -e

cd /opt/ocudu/build/apps/gnb
./gnb -c /configs/gnb_zmq.yaml
