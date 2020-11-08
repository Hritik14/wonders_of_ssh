#!/usr/bin/env bash
# Setups the servers used in ssh session given in DSC

# Thanks to https://manytools.org/hacker-tools/ascii-banner/
motd="
 ██████████    █████████    █████████
░░███░░░░███  ███░░░░░███  ███░░░░░███
 ░███   ░░███░███    ░░░  ███     ░░░
 ░███    ░███░░█████████ ░███
 ░███    ░███ ░░░░░░░░███░███
 ░███    ███  ███    ░███░░███     ███
 ██████████  ░░█████████  ░░█████████
░░░░░░░░░░    ░░░░░░░░░    ░░░░░░░░░

Wonders of SSH.
https://twitter.com/MrHritik (@MrHritik)
"
USER=wos


if [[ ! -e sshd_config ]]; then
	echo "sshd_config does not exist. Quitting"
	exit 1
fi

red(){
	printf "\033[0;31m[!] %s" "$1"
	printf "\033[0m\n"
}

green(){
	printf "\033[0;32m[+] %s" "$1"
	printf "\033[0m\n"
}

bullet(){
	printf "\033[0;33m[*] %s" "$1"
	printf "\033[0m\n"
}

echo -n "Enter hostname: "
read -r hostname
sudo hostnamectl set-hostname "$hostname" && green "Hostname setup complete" || red "Failed"

bullet "Making these changes to SSH"
diff --suppress-common-lines /etc/ssh/sshd_config sshd_config
sudo cp sshd_config /etc/ssh/sshd_config && green "SSHD Setup complete" || red "Failed"
sudo systemctl restart sshd

bullet "Disabling update-motd and setting up motd message"
sudo update-motd --disable && green "update-motd disabled" || red "Failed"
sudo echo "$motd" | sudo tee /etc/motd && green "motd updted" || red "Failed"

bullet "Creating a new user"
sudo useradd -m $USER
bullet "setting up password"
#echo "wos:hritik" | sudo chpasswd && green "Password changed" || red "Failed"
printf "hritik\nhritik\n" | sudo passwd -n 7 wos

bullet "TERM=linux"
echo "export TERM=linux" | tee -a /home/$USER/.bashrc
green "$hostname setup complete"
