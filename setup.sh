#!/bin/bash
set -e


# general stuff
sudo apt-get update &&\
	sudo apt-get -y install \
	tmux \
	wget \
	git

cp vimrc ~/.vimrc


if [ ! which conda ]; then
PYTHON_MINICONDA_VER='py39'
MINICONDA_VER='4.12.0'

# miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-${PYTHON_MINICONDA_VER}_${MINICONDA_VER}-Linux-x86_64.sh
bash Miniconda3-${PYTHON_MINICONDA_VER}_${MINICONDA_VER}-Linux-x86_64.sh
fi
# docker

curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

# singularity 

sudo apt-get install -y \
   build-essential \
   libseccomp-dev \
   pkg-config \
   squashfs-tools \
   cryptsetup

wget https://go.dev/dl/go1.19.linux-amd64.tar.gz &&\
      sudo tar -C /usr/local -xzvf go1.19.linux.tar.gz	
sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \ # Extracts the archive
  rm go$VERSION.$OS-$ARCH.tar.gz

echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && \
  source ~/.bashrc

export VERSION=3.10.0 && # adjust this as necessary \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION}

./mconfig && \
    make -C builddir && \
    sudo make -C builddir install
