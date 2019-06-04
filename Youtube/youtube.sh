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

    #Create the _video variable in a temporary folder with the command "mktemp"
    _video=$(mktemp)
    
    #Do the same with the video
    _channel=$(mktemp)
    
    #Creates the _url variable and stores a String in it
    _url="https://youtube.com/channel"
    
    #Creates the zenity box by taking user information
    _a=$(zenity --title="YOUTUBE?" --text "Enter URL" --entry --width="350" --height="50" )
    
	#Command wget, 1 will be taken at the end of the code as parameter, -O (muscle) will play the file in variable _video, silent mode
    wget "$_a" -O "$_video" 2>/dev/null
    
    #Creates the variables with commands
    _title=$(grep '<title>' "$_video" | sed 's/<[^>]*>//g' | sed 's/ - You.*//g')
    _viesw=$(grep 'watch-view-count' "$_video" | sed 's/<[^>]*>//g')
    _like=$(grep 'like-button-renderer-like-button-unclicked' "$_video" | sed 's/<[^>]*>//g;s/ //g')
    _dislike=$(grep 'like-button-renderer-dislike-button-unclicked' "$_video" | sed 's/<[^>]*>//g;s/ //g')
    _id=$(sed 's/channel/\n&/g' "$_video" | grep '^channelId' |sed -n 1p | sed 's/isCrawlable.*//g;s/..,.*//g;s/.*"//g')
    _subscriber=$(sed -n '/subscriber-count/{p; q;}' "$_video" |sed 's/.*subscriber-count//g' | sed 's/<[^>]*>//g;s/.*>//g')
    _descricao=$(grep 'watch-description-text' "$_video" |sed 's/.*id="watch-description-text" class=""//g' |sed 's/<[^>]*>//g' |cut -c1-100 |sed 's/>//g')
    
    #Command wget joins the variables _url, _id and throws the junction in the variable _channel
    wget "$_url/$_id" -O "$_channel" 2>/dev/null
    
    #Variable command
    _tchannel=$(sed -n '/title/{p; q;}' "$_channel" | sed 's/<title> //g')
    
    #Zenity Progress Bar Percentage
    echo "5"
    echo "# Make variables..." ; sleep 1
    echo "25"
    echo "# Download..." ; sleep 1
    echo "50" ;  sleep 1
    echo "75" ;  sleep 1
    echo "100"
    echo "# Finish!"
    
    #Result box displaying the information to the user
    zenity --info --title="YOUTUBE" --text="TITLE CHANNEL: $_tchannel\nTITLE VIDEO: $_title\nID VIDEO: $_id\nVIEWS: $_viesw\nLIKES: $_like\nDISLIKES: $_dislike\nINSCRIBLES: $_subscriber\nDESCRIPTION 100 LINES: $_descricao" --width="450" --height="50" 2>/dev/null
    
    #Zenity progress bar
    ) |
	    zenity --progress \
	    --title="Download YouTube" \
	    --text="Loading..." \
	    --percentage=0 --width="250" --height="50"

    #Error Handling
    if [ "$?" = -1 ] ; then
	    zenity --error \
		    --text="Download canceled."
    fi
    clear
}
#Call YouTube function
youtube
