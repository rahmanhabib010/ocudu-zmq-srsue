#!/bin/bash
set -e

ip netns add ue1 2>/dev/null || true
ip netns list

cd /opt/srsRAN_4G/build/srsue/src
./srsue /configs/ue_zmq.conf
