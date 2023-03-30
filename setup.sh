#!/bin/bash
set -e

# general stuff
sudo apt-get update &&\
	sudo apt-get -y install \
	tmux \
	wget \
	git \
    nodejs


cp vimrc ~/.vimrc

# miniconda
if  ! which conda; then
PYTHON_MINICONDA_VER='py39'
MINICONDA_VER='4.12.0'

wget https://repo.anaconda.com/miniconda/Miniconda3-${PYTHON_MINICONDA_VER}_${MINICONDA_VER}-Linux-x86_64.sh
bash Miniconda3-${PYTHON_MINICONDA_VER}_${MINICONDA_VER}-Linux-x86_64.sh
rm Miniconda3-${PYTHON_MINICONDA_VER}_${MINICONDA_VER}-Linux-x86_64.sh
source ~/.bashrc
conda update -y conda
fi
conda install -y -c conda-forge mamba
conda config --set channel_priority strict
conda install -y -c conda-forge mamba pip


# nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mkdir ~/nvim && mv nvim.appimage ~/nvim/nvim

echo 'export PATH=~/nvim:$PATH' >> ~/.bashrc && \
  source ~/.bashrc

python3 -m pip install --user --upgrade pynvim

# plugins
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# nvim config
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim

# node.js for nvim
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install stable --reinstall-packages-from=current

# gituhub copilot
git clone https://github.com/github/copilot.vim \
   ~/.config/nvim/pack/github/start/copilot.vim

# docker

if ! which docker; then
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
rm get-docker.sh
fi

# singularity 

if ! which singularity; then
sudo apt-get install -y \
   build-essential \
   libseccomp-dev \
   pkg-config \
   squashfs-tools \
   cryptsetup \
   libglib2.0-dev

wget https://go.dev/dl/go1.19.linux-amd64.tar.gz &&\
      sudo tar -C /usr/local -xzvf go1.19.linux-amd64.tar.gz &&\
      rm go1.19.linux-amd64.tar.gz

echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && \
  source ~/.bashrc

export VERSION=3.10.0 && # adjust this as necessary \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION}

./mconfig && \
    make -C builddir && \
    sudo make -C builddir install
fi
