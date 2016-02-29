#!/bin/bash

wifiFile="interfaces-wifi"
hotspotFile="interfaces-hotspot"

function setToWifi {
    	sudo ifdown wlan0
    	sudo rm /etc/network/interfaces
    	sudo cp interfaces-wifi /etc/network/interfaces
    	sudo systemctl daemon-reload
	sudo service networking restart
	sudo ifup wlan0
	whiptail --title "Network Switch" --msgbox "Network has been set to Wifi. Choose Ok to continue." 10 60
}

function createWifi {
    	echo "auto lo
iface lo inet loopback
iface eth0 inet manual
allow-hotplug wlan0
iface wlan0 inet static
        address 192.168.0.40
        netmask 255.255.255.0
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> interfaces-wifi
}

function setToHotspot {
	sudo rm /etc/network/interfaces
    	sudo cp interfaces-hotspot /etc/network/interfaces
}

function createHotspot {
    echo "auto lo
allow-hotplug wlan0
iface wlan0 inet static
        address 10.5.5.1
        netmask 255.255.255.0" >> interfaces-hotspot
}

function reboot {
	if (whiptail --title "Network Switch" --yesno "Network has been set to hotspot, would you like to reboot now?" 10 60) then
    		sudo reboot
	else
		echo "No hotspot for you then."
	fi
}

OPTION=$(whiptail --title "Network Switch" --menu "Choose your option" 15 60 4 \
"1" "Wifi" \
"2" "Hotspot" 3>&1 1>&2 2>&3)

if [ $OPTION = 1 ]; then
	if [ -f "$wifiFile" ]; then
		setToWifi
  	else
        	createWifi
        	setToWifi
    	fi
elif [ $OPTION = 2 ]; then
    	if [ -f "$hotspotFile" ]; then
        	setToHotspot
		reboot
    	else
	       	createHotspot
        	setToHotspot
        	reboot
    	fi
else
    	whiptail --title "Network Switch" --msgbox "Operation cancelled. Choose Ok to continue." 10 60
fi
