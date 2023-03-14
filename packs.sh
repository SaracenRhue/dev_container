#!/bin/bash

# Install Docker
wget https://github.com/mozilla/geckodriver/releases/download/v0.32.0/geckodriver-v0.32.0-linux64.tar.gz
tar -xvzf geckodriver*
chmod +x geckodriver
mv geckodriver /usr/local/bin/
rm geckodriver*
export PATH=/usr/local/bin:$PATH

# Install Java
# apt install -y openjdk-11-jdk
# Install C++ compiler
apt install -y gcc
# Install go compiler
apt install -y golang
# Install Rust compiler
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# additional packages
apt install -y ffmpeg firefox htop nano

# python packages
pip install --upgrade pip
pip install torch selenium pyautogui opencv-python matplotlib numpy pillow

# node packages
npm install -g typescript
npm install -g sass
npm install -g @angular/cli