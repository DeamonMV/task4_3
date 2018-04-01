#!/bin/bash

if [ ! "$#" -eq 2 ]; then
	echo "Vrong number of parametrs" >&2
	exit 1
fi 

if [ ! -d /tmp/backups ]; then
	mkdir -p /tmp/backups
fi


if [ ! -f "${1}" ] && [ ! -d "${1}" ]; then
	echo "There are nothing to backup" >&2
	exit 1
fi

if [[ ! "$2" =~ ^[0-9]+$ ]] || [[ "$2" -le 0 ]]; then
	echo "Amount of backups is not integer" >2&
	exit 1
fi

if [ -d "${1}" ]; then
	 BN=$(echo ${1} | sed -e 's/^\/\+//' | sed -e 's/\/\+$//g' | sed -e 's/\/\+/-/g')
elif [ -f "${1}" ]; then
	 BN=$(echo ${1} | sed -e 's/^\/\+//' | sed -e 's/\/\+/-/g')
fi

DT=`date +%Y-%m-%d--%H%M%S`

tar -zcf /tmp/backups/"$BN"-"$DT".tar.gz "$1"


archcount=$(ls -1 /tmp/backups/ | grep -c "^$BN-[0-9]*-[0-9]*-[0-9]*--[0-9]*.tar.gz")

if [ $archcount -gt $2 ] ; then
	let head="$archcount-$2"
	RM=$(ls -1 -d /tmp/backups/* | grep "^$BN-[0-9]*-[0-9]*-[0-9]*--[0-9]*.tar.gz" | head -$head)
	ls -1 -d /tmp/backups/* | grep "\/$BN-[0-9]*-[0-9]*-[0-9]*--[0-9]*.tar.gz" | head -$head | xargs -d '\n' -t rm  
fi
