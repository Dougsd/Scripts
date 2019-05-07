#!/bin/sh

#Autor:Karan Luciano (karanluciano1@gmail.com)
#Script simples com funcionalidade de agilizar a configuração do som a cada vez que o sistema é inicializado

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
