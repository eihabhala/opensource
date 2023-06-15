#!/bin/bash

# ==========
# Mine Code =================================

# Installing Dialog && pv and other tools

sudo apt-get install -y dialog pv git
clear 

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
clear
source ~/.bashrc
clear

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc
clear
clear

sudo brew install gh

if [ -d "Projects" ]; then
    # Directory exists, perform action
    echo "Directory already exists."
else
    mkdir Projects
    mkdir Projects/Project

# End Mine Code =============================

# =========

# Update Ubuntu packages
echo -e "\nUpdating Ubuntu packages..."
sudo apt-get update -y | pv -pterb 2>&1 | \
    dialog --title "Updating Ubuntu Packages" --progressbox "Please wait..." 10 70

# sudo apt-get upgrade -y | pv -pterb 2>&1 | \
#     dialog --title "Upgrading Ubuntu Packages" --progressbox "Please wait..." 10 70

# Install Conda
CONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh"
CONDA_SCRIPT="Anaconda3-2023.03-1-Linux-x86_64.sh"

# Install Conda
echo -e "\nDownloading and installing Conda..."
curl -L ${CONDA_URL} -o ${CONDA_SCRIPT} 2>&1 | \
    dialog --title "Downloading and Installing Conda" --gauge "Please wait..." 10 70 0

bash ${CONDA_SCRIPT} -b -p Anaconda3/ -u 2>&1 | \
    dialog --title "Installing Conda" --gauge "Please wait..." 10 70 0

rm ${CONDA_SCRIPT}

# Activate Conda
source $HOME/miniconda3/bin/conda init

# Create Conda environment from environment.yml
echo -e "\nCreating Conda environment..."
conda env create -f environment.yml | pv -pterb 2>&1 | \
    dialog --title "Creating Conda Environment" --progressbox "Please wait..." 10 70

# Install Nginx
echo -e "\nInstalling Nginx..."
sudo apt-get install nginx -y | pv -pterb 2>&1 | \
    dialog --title "Installing Nginx" --progressbox "Please wait..." 10 70

# Install Streamlit
echo -e "\nInstalling Streamlit..."
conda activate base001 && conda install streamlit -y | pv -pterb 2>&1 | \
    dialog --title "Installing Streamlit" --progressbox "Please wait..." 10 70

# Configure Nginx for Streamlit
echo -e "\nConfiguring Nginx for Streamlit..."
sudo tee /etc/nginx/sites-available/default >/dev/null <<EOF
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:8501;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Restart Nginx
sudo service nginx restart

# Display completion message
dialog --title "Installation Completed" --msgbox "Ubuntu update, Conda installation, Conda environment creation, Nginx installation, and Streamlit installation completed.\nYou can access your Streamlit app at http://localhost."
