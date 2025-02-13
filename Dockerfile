FROM ubuntu:22.04

# Don't ask stdin anything to install software automatically.
ENV DEBIAN_FRONTEND=noninteractive

# Install softwares.
RUN apt-get update && apt-get upgrade -y && apt-get install -y bison
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential
RUN apt-get update && apt-get upgrade -y && apt-get install -y clang
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl
RUN apt-get update && apt-get upgrade -y && apt-get install -y dejagnu
RUN apt-get update && apt-get upgrade -y && apt-get install -y dosfstools
RUN apt-get update && apt-get upgrade -y && apt-get install -y flex
RUN apt-get update && apt-get upgrade -y && apt-get install -y git
RUN apt-get update && apt-get upgrade -y && apt-get install -y gnupg
RUN apt-get update && apt-get upgrade -y && apt-get install -y iasl
RUN apt-get update && apt-get upgrade -y && apt-get install -y libexpat-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y libgcrypt20-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y libglib2.0-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y libgmp-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y libmpfr-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y libpixman-1-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y libslirp-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y lld
RUN apt-get update && apt-get upgrade -y && apt-get install -y nasm
RUN apt-get update && apt-get upgrade -y && apt-get install -y netcat-openbsd
RUN apt-get update && apt-get upgrade -y && apt-get install -y ninja-build
RUN apt-get update && apt-get upgrade -y && apt-get install -y pkg-config
RUN apt-get update && apt-get upgrade -y && apt-get install -y python3
RUN apt-get update && apt-get upgrade -y && apt-get install -y python3-venv
RUN apt-get update && apt-get upgrade -y && apt-get install -y texinfo
RUN apt-get update && apt-get upgrade -y && apt-get install -y tmux
RUN apt-get update && apt-get upgrade -y && apt-get install -y tzdata
RUN apt-get update && apt-get upgrade -y && apt-get install -y uuid-dev
RUN apt-get update && apt-get upgrade -y && apt-get install -y vim
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget
RUN apt-get update && apt-get upgrade -y && apt-get install -y zip

# Install Rust.
RUN curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y

# Install QEMU.
WORKDIR /root
RUN git clone --branch v8.0.0 --depth 1 --recursive --shallow-submodules --single-branch https://gitlab.com/qemu-project/qemu.git
WORKDIR qemu
RUN ./configure --enable-gcrypt --enable-slirp --target-list=x86_64-softmmu CFLAGS="-O0 -g -fno-inline" CXXFLAGS="-O0 -g -fno-inline"
RUN make
RUN make install
WORKDIR roms/edk2
RUN ./OvmfPkg/build.sh -a X64

# Install WasabiOS.
WORKDIR /root
RUN git clone https://github.com/hikalium/wasabi.git
WORKDIR wasabi
RUN git checkout 8e23542da41be26f37d52f2be1b728c06c53fffa
COPY build_wasabi.sh build_wasabi.sh
COPY run_wasabi.sh run_wasabi.sh

# Install saba.
WORKDIR /root
RUN git clone https://github.com/d0iasm/saba.git
WORKDIR saba
RUN git checkout 29b43505168a2be021509bd25061342a4fd30004
COPY build_saba.sh build_saba.sh

# Expose VNC port.
ARG vnc_port
EXPOSE $vnc_port

