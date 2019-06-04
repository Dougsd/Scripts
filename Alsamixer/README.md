# alsamixer
Script Audio Activation.

Recently I bought a notebook for my wife, I came across a problem, the audio did not work. After a few quick searches I realized that it was not a problem with drives or hardware, but a bug that disables the audio in Ausamixer. I made these scripts to help anyone going through the same problem. In my case I made a small modification and put it to start with the system, problem solved.

![alt text](https://github.com/lkaranl/Scripts/raw/master/Youtube/QR-alsamixer.png)

# What do you need to use this software?
You will need the "ZENITY"

Zenity is software that allows you to create several types of simple dialogs for interaction with users in a Linux environment, which can be used in shell scripts.

# How to use it?
Install Zenity:<br/>
In debian-based distributions:<br/>
`$sudo apt install zenity`<br/>

In arch-based distributions:<br/>
`$sudo pacman -S zenity`<br/>

Execution permission to samba.sh with the command:<br/>
`$sudo chmod +x alsamixer.sh`<br/>

Then run the program:<br/>
`$sudo ./alsamixer.sh`