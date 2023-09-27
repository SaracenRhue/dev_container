FROM nvidia/cuda:12.1.0-base-ubuntu22.04

# Update package repositories and install dependencies
RUN apt update && apt upgrade -y
ENV HOSTNAME=helix
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata. 
RUN apt install -y sudo ssh build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl git llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev

# RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
#     curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list && \
#     apt update && \
#     apt install -y tailscale && \
#     tailscale up -authkey "${TAILSCALE_KEY}"

# Add a new user
RUN useradd -ms /bin/bash saracen && \
    echo "saracen:nodlehs" | chpasswd && \
    echo "root:nodlehs" | chpasswd && \
    adduser saracen sudo
# COPY ./.zshrc /home/saracen/

# WORKDIR /home/saracen
# # setup zsh
# RUN apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting && \
#     git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k && \
#     cd /home/saracen && curl -L http://install.ohmyz.sh | sh && \
#     chsh -s $(which zsh) saracen

# Install Pyenv
RUN curl https://pyenv.run | bash
# Add Pyenv to the shell environment
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
# Install Python 3.10 using Pyenv
RUN pyenv install 3.11 && \
    pyenv global 3.11
# Install Node.js   
RUN apt install -y nodejs npm
# RUN npm install -g typescript && \
#     npm install -g sass && \
#     npm install -g @angular/cli


# Install Docker
RUN apt install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && \
    apt install -y docker-ce docker-ce-cli containerd.io && \
    adduser saracen docker

# Install Geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.32.2/geckodriver-v0.32.2-linux64.tar.gz && \
    tar -xvzf geckodriver* && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin/ && \
    rm geckodriver* && \
    export PATH=/usr/local/bin:$PATH

# Install Rust compiler
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

COPY ./apt_packs.txt .
COPY ./python_packs.txt .

# additional packages
RUN apt install -y < apt_packs.txt

# python packages
RUN pip install --upgrade pip && \
    pip install -r python_packs.txt

RUN rm -fr ./apt_packs.txt ./python_packs.txt
RUN mkdir /home/saracen/projects 
# Expose port 22
ENV PORT=22
EXPOSE 22

ENV PORT=3000
EXPOSE 3000
ENV PORT=8000
EXPOSE 8000
# VOLUME /home/user/projects

# Start SSH service and docker deamon
RUN mkdir /var/run/sshd
CMD service docker start && \
    /usr/sbin/sshd -D