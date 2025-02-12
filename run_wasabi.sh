#!/bin/bash

source /root/.cargo/env
make vnc > vnc.log 2>&1 &
make run WITH_APP_BIN=/root/saba/target/x86_64-unknown-none/release/saba

