#!/usr/bin/env bash

#####   NAME:               youtube.sh
#####   VERSION:            0.2
#####   DESCRIPTION:        Get data Youtube video and chanel details
#####   DATE OF CREATION:   03/03/2019
#####   WRITTEN BY:         KARAN LUCIANO SILVA
#####   E-MAIL:             karanluciano1@gmail.com         
#####   DISTRO:             ARCH LINUX
#####   LICENSE:            GPLv3           
#####   PROJECT:            https://github.com/lkaranl/Scrits

function youtube(){
	(

    #Cria a variavel _video em uma pasta temporaria com o comando "mktemp"
    _video=$(mktemp)
    
    #Faz o mesmo com o video
    _channel=$(mktemp)
    
    #Cria a variavel _url e armazena uma String nela
    _url="https://youtube.com/channel"
    
    #Cria a caixa do zenity, pegando as informacoes do usuario
    _a=$(zenity --title="YOUTUBE?" --text "Enter URL" --entry --width="350" --height="50" )
    
    #Comando wget, 1 sera pego no final do codigo como parametro, -O (maisculo) vai jogar o arquivo na variavel _video, modo silencioso
    wget "$_a" -O "$_video" 2>/dev/null
    
    #Cria as variaveis com os comandos 
    _title=$(grep '<title>' "$_video" | sed 's/<[^>]*>//g' | sed 's/ - You.*//g')
    _viesw=$(grep 'watch-view-count' "$_video" | sed 's/<[^>]*>//g')
    _like=$(grep 'like-button-renderer-like-button-unclicked' "$_video" | sed 's/<[^>]*>//g;s/ //g')
    _dislike=$(grep 'like-button-renderer-dislike-button-unclicked' "$_video" | sed 's/<[^>]*>//g;s/ //g')
    _id=$(sed 's/channel/\n&/g' "$_video" | grep '^channelId' |sed -n 1p | sed 's/isCrawlable.*//g;s/..,.*//g;s/.*"//g')
    _subscriber=$(sed -n '/subscriber-count/{p; q;}' "$_video" |sed 's/.*subscriber-count//g' | sed 's/<[^>]*>//g;s/.*>//g')
    _descricao=$(grep 'watch-description-text' "$_video" |sed 's/.*id="watch-description-text" class=""//g' |sed 's/<[^>]*>//g' |cut -c1-100 |sed 's/>//g')
    
    #Comando wget juntas as variaveis _url, _id e joga a juncao na variavel _channel
    wget "$_url/$_id" -O "$_channel" 2>/dev/null
    
    #Variavel comando  
    _tchannel=$(sed -n '/title/{p; q;}' "$_channel" | sed 's/<title> //g')
    
    #Porcentagem da Barra de progresso Zenity
    echo "5"
    echo "# Make variables..." ; sleep 1
    echo "25"
    echo "# Download..." ; sleep 1
    echo "50" ;  sleep 1
    echo "75" ;  sleep 1
    echo "100"
    echo "# Finish!"
    
    #Caixa de resultado exibindo as informacoes ao usuario
    zenity --info --title="YOUTUBE" --text="TITLE CHANNEL: $_tchannel\nTITLE VIDEO: $_title\nID VIDEO: $_id\nVIEWS: $_viesw\nLIKES: $_like\nDISLIKES: $_dislike\nINSCRIBLES: $_subscriber\nDESCRIPTION 100 LINES: $_descricao" --width="450" --height="50" 2>/dev/null
    
    #Barra de progresso Zenity
    ) |
	    zenity --progress \
	    --title="Download YouTube" \
	    --text="Loading..." \
	    --percentage=0 --width="250" --height="50"

    #Tratamento de erro
    if [ "$?" = -1 ] ; then
	    zenity --error \
		    --text="Download canceled."
    fi
    clear
}
#Chama a funcao youtube
youtube
