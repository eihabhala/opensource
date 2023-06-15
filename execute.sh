#!/bin/bash

# Update and upgrade Ubuntu silently
sudo apt-get update -yq
sudo apt-get upgrade -yq

# Install Anaconda silently
wget -q https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh -O anaconda.sh
bash anaconda.sh -b -p $HOME/anaconda
rm anaconda.sh

# Add Anaconda to PATH
echo 'export PATH="$HOME/anaconda/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Create Conda environment
conda create -y -n condafu python=3.10
conda activate condafu

# Install Streamlit silently
pip install -q streamlit

# Install Nginx silently
sudo apt-get install -yq nginx

# Configure Streamlit with Nginx
sudo tee /etc/nginx/sites-available/streamlit.conf > /dev/null << EOF
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:8501;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/streamlit.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Install git silently
sudo apt-get install -yq git

# Install GCC silently
sudo apt-get install -yq gcc

# Install Homebrew silently
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Activate Homebrew
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install GitHub with Homebrew
brew install gh

# Install Git
# brew install git

# Print installation completed message
echo "Installation completed successfully!"
