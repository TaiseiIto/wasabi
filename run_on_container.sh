#!/bin/bash

source /root/.cargo/env
make vnc > vnc.log 2>&1 &
make run

