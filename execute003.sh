#!/bin/bash

# Update Ubuntu packages
echo -e "\nUpdating Ubuntu packages..."
sudo apt-get update -y | pv -pterb 2>&1 | \
    dialog --title "Updating Ubuntu Packages" --progressbox "Please wait..." 10 70

sudo apt-get upgrade -y | pv -pterb 2>&1 | \
    dialog --title "Upgrading Ubuntu Packages" --progressbox "Please wait..." 10 70

sudo apt-get dist-upgrade -y | pv -pterb 2>&1 | \
    dialog --title "Performing Distribution Upgrade" --progressbox "Please wait..." 10 70

# Install Anaconda
ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh"
ANACONDA_SCRIPT="Anaconda3-2023.03-1-Linux-x86_64.sh"

echo -e "\nDownloading Anaconda..."
curl -L ${ANACONDA_URL} -o ${ANACONDA_SCRIPT} 2>&1 | \
    dialog --title "Downloading Anaconda" --gauge "Please wait..." 10 70 0

echo -e "\nInstalling Anaconda..."
bash ${ANACONDA_SCRIPT} -b -p $HOME/anaconda3 2>&1 | \
    dialog --title "Installing Anaconda" --gauge "Please wait..." 10 70 0

rm ${ANACONDA_SCRIPT}

# Install Nginx
echo -e "\nInstalling Nginx..."
sudo apt-get install nginx -y | pv -pterb 2>&1 | \
    dialog --title "Installing Nginx" --progressbox "Please wait..." 10 70

# Install Streamlit
echo -e "\nInstalling Streamlit..."
$HOME/anaconda3/bin/pip install streamlit | pv -pterb 2>&1 | \
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
dialog --title "Installation Completed" --msgbox "Ubuntu update, Anaconda installation, Nginx installation, and Streamlit installation completed.\nYou can access your Streamlit app at http://localhost." 10 70
