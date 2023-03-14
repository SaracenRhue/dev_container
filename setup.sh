#!/bin/bash

cd /home/user
if if [[ ! -f .zshrc ]]; then
    wget https://raw.githubusercontent.com/SaracenRhue/dev_container/main/.zshrc
    curl -L http://install.ohmyz.sh | sh
fi
cd

