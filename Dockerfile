FROM ubuntu:22.04

# Don't ask stdin anything to install software automatically.
ENV DEBIAN_FRONTEND=noninteractive

# Install softwares.
RUN apt update && apt upgrade -y && apt install -y bison
RUN apt update && apt upgrade -y && apt install -y build-essential
RUN apt update && apt upgrade -y && apt install -y clang
RUN apt update && apt upgrade -y && apt install -y curl
RUN apt update && apt upgrade -y && apt install -y dejagnu
RUN apt update && apt upgrade -y && apt install -y dosfstools
RUN apt update && apt upgrade -y && apt install -y flex
RUN apt update && apt upgrade -y && apt install -y git
RUN apt update && apt upgrade -y && apt install -y gnupg
RUN apt update && apt upgrade -y && apt install -y iasl
RUN apt update && apt upgrade -y && apt install -y libexpat-dev
RUN apt update && apt upgrade -y && apt install -y libgcrypt20-dev
RUN apt update && apt upgrade -y && apt install -y libglib2.0-dev
RUN apt update && apt upgrade -y && apt install -y libgmp-dev
RUN apt update && apt upgrade -y && apt install -y libmpfr-dev
RUN apt update && apt upgrade -y && apt install -y libpixman-1-dev
RUN apt update && apt upgrade -y && apt install -y libslirp-dev
RUN apt update && apt upgrade -y && apt install -y lld
RUN apt update && apt upgrade -y && apt install -y nasm
RUN apt update && apt upgrade -y && apt install -y netcat-openbsd
RUN apt update && apt upgrade -y && apt install -y ninja-build
RUN apt update && apt upgrade -y && apt install -y pkg-config
RUN apt update && apt upgrade -y && apt install -y python3
RUN apt update && apt upgrade -y && apt install -y python3-venv
RUN apt update && apt upgrade -y && apt install -y texinfo
RUN apt update && apt upgrade -y && apt install -y tmux
RUN apt update && apt upgrade -y && apt install -y tzdata
RUN apt update && apt upgrade -y && apt install -y uuid-dev
RUN apt update && apt upgrade -y && apt install -y vim
RUN apt update && apt upgrade -y && apt install -y wget
RUN apt update && apt upgrade -y && apt install -y zip

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

