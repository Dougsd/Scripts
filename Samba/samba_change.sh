#!/usr/bin/env bash

#author: Karan Luciano
#describle: Configuracao REDE, Servidor DHCP e DNS
#version: 0.1
#license: GNU GENERAL PUBLIC LICENSE

caminho=$(zenity --title="Nome?" --text "Qual o caminho que deseja colocar?" --entry --width="350" --height="50")

echo  "[global]
   workgroup = WORKGROUP
   dns proxy = no
   log file = /var/log/samba/%m.log
   max log size = 1000
   client max protocol = NT1
   server role = standalone server
   passdb backend = tdbsam
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *New*UNIX*password* %n\\n *ReType*new*UNIX*password* %n\n *passwd:*all*authentication*tokens*updated*successfully*
   pam password change = yes
   map to guest = Bad Password
   usershare allow guests = yes
   name resolve order = lmhosts bcast host wins
   security = user
   guest account = nobody
   usershare path = /var/lib/samba/usershare
   usershare max shares = 100
   usershare owner only = yes
   force create mode = 0070
   force directory mode = 0070

[homes]
   comment = Home Directories
   browseable = no
   read only = yes
   create mask = 0700
   directory mask = 0700
   valid users = %S

[printers]
   comment = All Printers
   browseable = no
   path = /var/spool/samba
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700

[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no
" > /etc/samba/smb.conf

echo  "[karan]
	comment = compar
	path = $caminho
	browseable = yes
	writable = yes" >> /etc/samba/smb.conf

smbpasswd -a karan

sudo systemctl enable smb nmb
sudo systemctl start smb nmb

zenity --info --title="Alterando Caminho" --text=" Caminho alterado para: $caminho" --width="200" height="200"
