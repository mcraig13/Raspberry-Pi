#!/bin/bash

wifiFile="/etc/network/interfaces-wifi"
hotspotFile="/etc/network/interfaces-hotspot"

function setToWiFi {
    sudo rm /etc/network/interfaces
    sudo cp interfaces-wifi /etc/network/interfaces
    sudo ifdown wlan0
    sudo ifup wlan0
    xmessage "Network has been set to WiFi." -buttons Thanks
}

function createWiFi {
    echo "auto lo
iface lo inet loopback
iface eth0 inet manual
allow-hotplug wlan0
iface wlan0 inet static
        address 10.5.5.1
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
    xmessage "Network has been set to Hotspot, a reboot is now required. Okay?" -buttons Okay,No
	BOOTQUERY=$?
	if [ $BOOTQUERY -eq 101 ]; then
		sudo reboot
	else
		echo "No hotspot for you then."
	fi
}

xmessage "Choose from the following options:" -buttons WiFi,Hotspot,Cancel
RESULT=$?

if [ $RESULT -eq 101 ]; then
    if [ -f "$file" ]; then
        setToWifi()
    else
        createWifi()
        setToWifi()
    fi
elif [ $RESULT -eq 102 ]; then
    if [ -f "$file" ]; then
        setToHotspot()
    else
        createHotspot()
        setToHotspot()
        reboot()
    fi
else
    xmessage "Operation cancelled." -buttons Thanks
fi