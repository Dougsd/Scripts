#!/usr/bin/env bash

#####   NAME:               samba.sh
#####   VERSION:            0.1
#####   DESCRIPTION:        Adds new path and user to SAMBA
#####   DATE OF CREATION:   03/06/2019
#####   WRITTEN BY:         KARAN LUCIANO SILVA
#####   E-MAIL:             karanluciano1@gmail.com         
#####   DISTRO:             ARCH LINUX
#####   LICENSE:            GPLv3           
#####   PROJECT:            https://github.com/lkaranl/Scrits

_checks=`id -u`
_currentuser=`whoami`

if [ $_checks != 0 ]; then
	echo “Your user is ${_currentuser}. Need be root…”
	exit 1
else
	_path=$(zenity --title="PATH" --text "Which path do you want to put?" --entry --width="350" --height="50")
	_name=$(zenity --title="NAME" --text "What is the name of the share?" --entry --width="350" --height="50")

	sudo echo "[$_name]
	comment = compar
	path = $_path
	browseable = yes
	writable = yes" >> /etc/samba/smb.conf

	zenity --title="SAMBA" --question --text "WANT TO ADD A NEW USER/PASSWORD TO SAMBA?" --width="400" --height="50" && echo $?

	if [ $? == 0 ]; then
		_user=$(zenity --title="USER" --text "What is the username?" --entry --width="350" --height="50")
		zenity --info --text="PLACE THE PASSWORD IN THE TERMINAL" --width="350" --height="50"
		sudo smbpasswd -a $_user
	fi
	sudo systemctl enable smb nmb
	sudo systemctl restart smb nmb
	zenity --info --title="Changing Path" --text="Path changed to: $_path" --width="200" height="200"
fi