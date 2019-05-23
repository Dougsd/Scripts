#!/usr/bin/env bash

#author: Karan Luciano
#describle: Configuracao REDE, Servidor DHCP e DNS
#version: 0.1
#license: GNU GENERAL PUBLIC LICENSE

_opcao=$(zenity --list --text "Audio" \
--radiolist \
--column "Marcar" \
--column "Opcao" \
TRUE LIGADO FALSE DESLIGADO );
echo "$_opcao" 

if [ "$_opcao" = "LIGADO" ]; then
amixer set Master 100% 
amixer set Headphone playback 100% 
fi
if [ "$_opcao" = "DESLIGADO" ]; then
amixer set Master 0% && clear
amixer set Headphone playback 0% 
fi

clear
