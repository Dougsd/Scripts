#!/usr/bin/env bash

#author: Karan Luciano
#describle: Configuracao DNS
#version: 0.1
#license: GNU GENERAL PUBLIC LICENSE

clear
_ip4=$(ip a |grep "inet "|awk '{print $2}'|tail -n 1|sed 's/\/.*//g')
_ip6=$(ip a |grep "inet6 "|awk '{print $2}'|tail -n 2|head -n 1|sed 's/\/.*//g')
auxip4=$(ip a |grep "inet "|awk '{print $2}'|tail -n 1|sed 's/\/.*//g'|sed 's/192.168.0.//g')
auxip6=$(ip a |grep "inet6 "|awk '{print $2}'|tail -n 2|head -n 1|sed 's/\/.*//g'|sed 's/.*:://g')
endip4=$(echo $ip4 |sed 's/192.168.0.//g')
endip6=$(echo $ip6 |sed 's/.*:://g')

Menu(){
	echo "[ 1 ] CONFIGURAR A REDE NETPLAN"
	echo "[ 2 ] COLOCAR HOSTNAME NO /ETC/HOSTS"
	echo "[ 3 ] LIMPA SCOPO/RESERVAS E COMECAR UM NOVO"
	echo "[ 4 ] ADCIONAR RESERVA"
	echo "[ 5 ] LIMPAR TODAS AS ZONAS E COMECAR UMA NOVA"
	echo "[ 6 ] ADICIONAR A UM ZONA JA EXISTENTE"
	echo "[ 0 ] SAIR"
	echo -e '\033[05;31mQUAL A OPCAO DESEJADA?\033[00;37m' 
	read opcao

	case $opcao in
		1) Rede ;;
		2) Hostname ;;
		3) Scopo ;;
		3) Reserva ;;
		5) Novo ;;
		6) Adicionar ;;
		0) exit ;;
	esac
}

Rede(){
	DIR=/etc/netplan/

	ls $DIR 2> /dev/null

	if [ $? -ne 0 ]; then
		echo -e "\033[05;31mVOCE NAO TEM O NETPLAN\033[00;37m" 
	else
		echo -e "\033[05;31mCONFIGURA REDES NETPLAN\033[00;37m" 
		echo -e "\033[05;31mCONFIGURA APENAS OS DISPOSITIVOS 'ENP'\033[00;37m" 
		echo "Qual o IPv4 com a mascara reduzida (ex: 192.168.0.1/24): "
		read ip4
		echo "Qual o Gateway4: "
		read gate4
		echo "Qual o IPv6 com a mascara reduzida (ex: cafe:dead:face::1/64): "
		read ip6
		echo "Qual o Gateway6: "
		read gate6
		dispo=$(ip a |grep enp |awk '{print $2}' |head -n 1)
		aux=$(ls /etc/netplan/)
		echo -e "network:
		ethernets:
		$dispo
		dhcp4: false
		dhcp6: false
		addresses: [$ip4, \"$ip6\"]
		gateway4: $gate4
		gateway6: $gate6
		version: 2" > /etc/netplan/$aux	
		netplan apply
	fi
	Menu
}

Novo(){
	hostname=$(cat /etc/hostname)

	echo -e "\n;\n; BIND data file for local loopback interface\n;\n\$TTL    604800\n@	IN	SOA	$hostname.ubuntu.local. root.$hostname.ubuntu.local. (\n			      2		; Serial\n			 604800		; Refresh\n			  86400		; Retry\n			2419200		; Expire\n			 604800 )	; Negative Cache TTL\n;" > /etc/bind/db.local

	echo -e "\n;\n; BIND data file for local loopback interface\n;\n\$TTL   604800\n@	IN	SOA	$hostname.ubuntu.local. root.$hostname.ubuntu.local. (\n			      2		; Serial\n			 604800		; Refresh\n			  86400		; Retry\n			2419200		; Expire\n			 604800 )	; Negative Cache TTL\n;" > /etc/bind/db.127

	echo -e "\nubuntu.local.	IN	NS	$hostname.ubuntu.local.\nubuntu.local.	IN	A	$_ip4\nubuntu.local.	IN	AAAA	$_ip6\n" >>  /etc/bind/db.local
	echo -e "\n$hostname	IN	A	$_ip4\n$hostname	IN	AAAA	$_ip6\nservidor	IN	CNAME	$hostname" >> /etc/bind/db.local

	echo -e '\033[05;31mADICIONANDO  NOVAS MAQUINAS AO DNS\033[00;37m'   

	echo "Diga o NOME da maquina: "
	read nome
	echo "Diga o IPv4 da maquina: "
	read ip4
	echo "Diga o IPv6 da maquina: "
	read ip6
	echo "Diga um apelido: "
	read apelido

	endip4=$(echo $ip4 |sed 's/192.168.0.//g')
	endip6=$(echo $ip6 |sed 's/.*:://g')

	echo -e "\n	IN	NS	$hostname.\n$auxip4	IN	PTR	$hostname.ubuntu.local.\n$auxip6.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0	IN	PTR	$hostname.ubuntu.local.\n\n$endip4	IN	PTR	$nome.ubuntu.local.\n$endip6.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0	IN	PTR	$nome.ubuntu.local." >>  /etc/bind/db.127

	echo -e "\n$nome	IN	A	$ip4\n$nome	IN	AAAA	$ip6\n$apelido	IN	CNAME	$nome" >> /etc/bind/db.local
	/etc/init.d/bind9 restart
	Menu
}

Adicionar(){	
	hostname=$(cat /etc/hostname)

	echo -e '\033[05;31mADICIONANDO  NOVAS MAQUINAS AO DNS\033[00;37m'   
	echo "Diga o NOME da maquina: "
	read nome
	echo "Diga o IPv4 da maquina: "
	read ip4
	echo "Diga o IPv6 da maquina: "
	read ip6
	echo "Diga um apelido: "
	read apelido

	endip4=$(echo $ip4 |sed 's/192.168.0.//g')
	endip6=$(echo $ip6 |sed 's/.*:://g')

	echo -e "\n$endip4	IN	PTR	$nome.ubuntu.local.\n$endip6.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0	IN	PTR	$nome.ubuntu.local." >>  /etc/bind/db.127
	echo -e "\n$nome	IN	A	$ip4\n$nome	IN	AAAA	$ip6\n$apelido	IN	CNAME	$nome" >> /etc/bind/db.local
	
	/etc/init.d/bind9 restart
	Menu
}

Hostname(){
	hostname=$(cat /etc/hostname)
	aux6=$(echo $_ip6    $hostname.ubuntu.local    $hostname)
	sed -i "1s/^/$aux6\n/" /etc/hosts
	aux4=$(echo $_ip4    $hostname.ubuntu.local    $hostname)
	sed -i "1s/^/$aux4\n/" /etc/hosts
	echo -e '\033[05;31mADICIONADO, REINICIE O SEU COMPUTADOR PARA QUE A MUDANCA TENHA EFEITO\033[00;37m' 
	Menu 
}

Scopo(){
	echo -e "#CRIANDO SCOPO PARA DHCP\n#Subnet adicionado pelo Sript. By: Karan\n#option domain-name 'example.org';\noption domain-name-servers ns1.example.org, ns2.example.org;\ndefault-lease-time 600;\nmax-lease-time 7200;\nddns-update-style none;\nauthoritative;" > /etc/dhcp/dhcpd.conf
	echo "Diga a REDE: "
	read rede
	echo "Diga a MASCARA: "
	read mask
	echo "Diga quando o RANGE comeca: "
	read rangec
	echo "Diga quando o RANGE termina: "
	read ranget
	echo -e "\n#RESERVAS IPV4\nsubnet $rede netmask $mask {\nrange $rangec $ranget;\n}" >> /etc/dhcp/dhcpd.conf
	clear
	/etc/init.d/isc-dhcp-server restart
	clear
	/etc/init.d/isc-dhcp-server status
	Menu
}	

Reserva(){
	echo -e '\033[05;31mCRIANDO RESERVAS\033[00;37m'   
	echo "Diga o MAC: "
	read mac
	if [[ $mac =~ ^[0-9A-Fa-f]{12}$ ]]
	then
		echo -e "MAC Valido"
	else
		clear
		echo -e "MAC Invalido"
		Reserva
	fi
	mac=$(echo $mac | sed -e 's!\.!!g;s!\(..\)!\1:!g;s!:$!!' -e 'y/abcdef/ABCDEF/')
	echo  "Diga o nome do HOST: "
	read host
	echo "Diga o IP: "
	read ip
	echo -e "\nhost $host {\nhardware ethernet $mac;\nfixed-address $ip;\n}" >> /etc/dhcp/dhcpd.conf
	/etc/init.d/isc-dhcp-server restart
	clear
	/etc/init.d/isc-dhcp-server status
	Menu
}		
Menu
