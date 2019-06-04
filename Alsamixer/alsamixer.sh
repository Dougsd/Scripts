#!/usr/bin/env bash

#####   NAME:               senha.sh
#####   VERSION:            0.1
#####   DESCRIPTION:        ALGORITMO PARA GERAR SENHAS
#####   DATE OF CREATION:   31/05/2019
#####   WRITTEN BY:         KARAN LUCIANO SILVA
#####   E-MAIL:             karanluciano1@gmail.com         
#####   DISTRO:             ARCH LINUX
#####   LICENSE:            GPLv3           
#####   PROJECT:            https://github.com/lkaranl/Scrits

option=$(zenity --list --text "Audio" \
	--radiolist \
	--column "Mark" \
	--column "Option" \
	TRUE ON FALSE OFF );
	echo "$option" 

	if [ "$option" = "ON" ]; then
		amixer set Master 100% 
		amixer set Headphone playback 100% 
	fi
	
	if [ "$option" = "OFF" ]; then
		amixer set Master 0% && clear
		amixer set Headphone playback 0% 
	fi

clear
