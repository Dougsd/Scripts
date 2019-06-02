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

export minusculo=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
export maiusculo=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
export especiais=(\! \@ \# \$ \% \( \) \- \_ \+ \= \{ \[ \^ \~ \] \} \/ \? \: \; \. \> \< \, \\ \| \*)
export numeros=(0 1 2 3 4 5 6 7 8 9)
export all=(${especiais[@]} ${minusculo[@]} ${maiusculo[@]} ${numeros[@]})
export Mnu=(${minusculo[@]} ${maiusculo[@]})
export Mnun=(${minusculo[@]} ${maiusculo[@]} ${numeros[@]})
export permutacao1=${#maiusculo[@]}
export permutacao2=${#minusculo[@]}
export permutacao3=${#numeros[@]}
export permutacao4=${#especiais[@]}
export permutacao5=$((${#minusculo[@]}+${#maiusculo[@]}))
export permutacao6=$((${#minusculo[@]}+${#maiusculo[@]}+${#numeros[@]}))
export permutacao7=$((${#especiais[@]}+${#minusculo[@]}+${#maiusculo[@]}+${#numeros[@]}))


factorial()
{
factorial=1
    if [ $1 > 1 ]; then
     cnt=0
     while :
     do
      let cnt=$cnt+1
      factorial=$(echo "$factorial*$cnt" | bc -l)  
      [ $cnt == $1 ] && break
     done
    else
        echo 1
    fi
}; factorial $permutacao

clear
echo  "
         +-----------------------------------+
         | Choose combinations:              |
         |                                   |
         | (1) Uppercase                     |
         | (2) Lowercase                     |
         | (3) Numbers                       |
         | (4) Special Characters            |
         | (5) Uppercase+Lowercase           |
         | (6) Uppercase+Lowercase+Numbers   |
         | (7) All combinations              |
         +-----------------------------------+"
read -p "Enter the desired option:" opcao
read -p "How many combinations do you want (>1)?: " combinacao
         
for (( i=1; i<=$combinacao; i++ ))
do
case $opcao in
	1) echo -n "${maiusculo[$(((RANDOM%$(($permutacao1-1)))))]}" ;;
	2) echo -n "${minusculo[$(((RANDOM%$(($permutacao2-1)))))]}" ;;
	3) echo -n "${numeros[$(((RANDOM%$(($permutacao3-1)))))]}" ;;
	4) echo -n "${especiais[$(((RANDOM%$(($permutacao4-1)))))]}" ;;
	5) echo -n "${Mnu[$(((RANDOM%$(($permutacao5-1)))))]}" ;;
	6) echo -n "${Mnun[$(((RANDOM%$(($permutacao6-1)))))]}" ;;
	7) echo -n "${all[$(((RANDOM%$(($permutacao7-1)))))]}" ;;
	*) echo "INVALID NUMBER!" ;;
esac
done
echo
