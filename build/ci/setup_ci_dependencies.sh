#!/bin/bash -xe
set +o pipefail

python -m pip install --upgrade pip yq
echo yq > dev-requirements.txt

# install gh command
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update
sudo apt-get install gh

# configure git configuration
git config --global user.email csi.block1@il.ibm.com
git config --global user.name csiblock