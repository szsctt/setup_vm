#!/bin/bash
set -e

sudo apt-get update && sudo apt-get install -y tmux wget git nodejs bzip2 tar libfuse2



cd /home/ubuntu

# mamba
if [ ! -e bin/micromamba ]; then
  curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
  bin/micromamba shell init -s bash -p /home/ubuntu/conda
  bin/micromamba config set auto_activate_base true
fi

export MAMBA_EXE="/home/ubuntu/bin/micromamba"
export MAMBA_ROOT_PREFIX="/home/ubuntu/conda"
eval "$(bin/micromamba shell hook --shell=bash)"
bin/micromamba install -n base -c conda-forge pip rclone -y
/home/ubuntu/conda/bin/pip install oci-cli pynvim
  
echo 'alias mamba=micromamba' >> /home/ubuntu/.bashrc
echo 'alias conda=micromamba' >> /home/ubuntu/.bashrc
echo 'export PATH="/home/ubuntu/bin:$PATH"' >> /home/ubuntu/.bashrc
export PATH="/home/ubuntu/bin:$PATH"

# set up oci cli
echo 'export OCI_CLI_AUTH=instance_principal' >> ~/.bashrc 
source ~/.bashrc 
oci setup autocomplete --auth instance_principal 

# nvim
sudo add-apt-repository universe -y && sudo apt-get install -y libfuse2
wget -O /home/ubuntu/bin/nvim.appimage  https://github.com/neovim/neovim/releases/download/v0.9.0/nvim.appimage
chmod u+x /home/ubuntu/bin/nvim.appimage
mv /home/ubuntu/bin/nvim.appimage /home/ubuntu/bin/nvim

mkdir -p /home/ubuntu/.config/nvim
cp /home/ubuntu/setup_vm/init.vim /home/ubuntu/.config/nvim/init.vim

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install stable --reinstall-packages-from=current

git clone https://github.com/github/copilot.vim \
   /home/ubuntu/.config/nvim/pack/github/start/copilot.vim

# OCI utils - not included by default on ubuntu
git clone https://github.com/oracle/oci-utils.git
cd oci-utils
python3 ./setup.py build
sudo python3 ./setup.py install

# chrome remote desktop
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -P /tmp
sudo apt install /tmp/chrome-remote-desktop_current_amd64.deb

# docker
if ! which docker; then
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
rm get-docker.sh
fi

# apptainer
# https://apptainer.org/docs/admin/main/installation.html#installation-on-linux
if ! which singularity; then
sudo apt-get install -y \
   software-properties-common

sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt update
sudo apt install -y apptainer

fi
