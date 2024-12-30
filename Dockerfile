FROM ubuntu:22.04

# Don't ask stdin anything to install software automatically.
ENV DEBIAN_FRONTEND=noninteractive

# Install softwares.
RUN apt update
RUN apt upgrade -y
RUN apt install -y bison
RUN apt install -y build-essential
RUN apt install -y clang
RUN apt install -y curl
RUN apt install -y dejagnu
RUN apt install -y dosfstools
RUN apt install -y flex
RUN apt install -y git
RUN apt install -y gnupg
RUN apt install -y iasl
RUN apt install -y libexpat-dev
RUN apt install -y libgcrypt20-dev
RUN apt install -y libglib2.0-dev
RUN apt install -y libgmp-dev
RUN apt install -y libmpfr-dev
RUN apt install -y libpixman-1-dev
RUN apt install -y libslirp-dev
RUN apt install -y lld
RUN apt install -y nasm
RUN apt install -y netcat-openbsd
RUN apt install -y ninja-build
RUN apt install -y pkg-config
RUN apt install -y python3
RUN apt install -y python3-venv
RUN apt install -y texinfo
RUN apt install -y tmux
RUN apt install -y tzdata
RUN apt install -y uuid-dev
RUN apt install -y vim
RUN apt install -y wget
RUN apt install -y zip

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

# Build WasabiOS.
WORKDIR /root
RUN git clone https://github.com/hikalium/wasabi.git
WORKDIR wasabi

# Expose VNC port.
ARG vnc_port
EXPOSE $vnc_port

