
# SAMBA 

This script adds a new path to samba sharing besides adding a new user or setting the old user password (samba user).

![alt text](https://github.com/lkaranl/Scripts/raw/master/Samba/QR-samba.png)

# What do you need to use this software?
You will need the "ZENITY"

Zenity is software that allows you to create several types of simple dialogs for interaction with users in a Linux environment, which can be used in shell scripts.

* The script takes into account that you already have samba installed and configured on your system.

# How to use it?
Install Zenity:<br/>
In debian-based distributions:<br/>
`$sudo apt install zenity`<br/>

In arch-based distributions:<br/>
`$sudo pacman -S zenity`<br/>

Execution permission to samba.sh with the command:<br/>
`$sudo chmod +x samba.sh`<br/>

Then run the program (need root permission):<br/>
`$sudo ./samba.sh`
