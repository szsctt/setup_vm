#!/bin/bash
set -e

sudo apt-get update && sudo apt-get install -y tmux wget git nodejs bzip2 tar libfuse2

mkdir -p /home/ubuntu/.config/nvim
cp init.vim /home/ubuntu/.config/nvim/init.vim

cd /home/ubuntu

# mamba
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
bin/micromamba shell init -s bash -p /home/ubuntu/conda
  
eval "$(bin/micromamba shell hook --shell=bash --prefix /home/ubuntu/conda)"
bin/micromamba activate base
bin/micromamba install -c conda-forge pip -y
/home/ubuntu/conda/bin/pip install oci-cli pynvim
  
echo 'alias mamba=micromamba' >> /home/ubuntu/.bashrc
echo 'alias conda=micromamba' >> /home/ubuntu/.bashrc
echo 'export PATH="/home/ubuntu/bin:$PATH' >> /home/ubuntu/.bashrc

source /home/ubuntu/.bashrc

# nvim
sudo add-apt-repository universe -y && sudo apt-get install -y libfuse2
wget -O /home/ubuntu/bin/nvim.appimage  https://github.com/neovim/neovim/releases/download/v0.9.0/nvim.appimage
chmod u+x /home/ubuntu/bin/nvim.appimage

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install stable --reinstall-packages-from=current

git clone https://github.com/github/copilot.vim \
   /home/ubuntu/.config/nvim/pack/github/start/copilot.vim

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

echo 'export PATH=/usr/local/go/bin:$PATH' >> /home/ubuntu/.bashrc && \
  source /home/ubuntu/.bashrc

export VERSION=3.11.0 && # adjust this as necessary \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION}

./mconfig && \
    make -C builddir && \
    sudo make -C builddir install
fi
