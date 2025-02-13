#!/bin/bash

source /root/.cargo/env
make
make run_deps
cp target/x86_64-unknown-uefi/debug/os.efi mnt/EFI/BOOT/BOOTX64.EFI
cp /root/saba/target/x86_64-unknown-none/release/saba mnt/saba
zip -r wasabi.zip mnt

