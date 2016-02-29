#!/bin/bash

xmessage "test" -buttons WiFi,Hotspot,Cancel
RESULT=$?

if [ $RESULT -eq 101 ]; then
	file="/etc/network/interfaces-wifi"
	if [ -f "$file" ]; then
		echo "$file found."
		echo "Setting up WiFi."
		sudo cp /etc/network/interfaces-wifi /etc/network/interfaces
	else
		echo "$file not found."
		echo "Creating new file."
		echo "auto lo
iface lo inet loopback
iface eth0 inet manual
allow-hotplug wlan0
iface wlan0 inet static
	address 10.5.5.1
	netmask 255.255.255.0
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces-wifi
		echo "New file created"
		sudo cp /etc/network/interfaces-wifi /etc/network/interfaces
		sudo ifdown wlan0
		sudo ifup wlan0
		echo "Setup complete"
	fi
elif [ $RESULT -eq 102 ]; then
	file="/etc/network/interfaces-hotspot"
	if [ -f "$file" ]; then
		echo "$file found."
		echo "Setting up Hotspot."
		sudo cp /etc/network/interfaces-hotspot /etc/network/interfaces
		echo "Setup complete"
	else
		echo "$file not found."
                echo "Creating new file."
                echo "auto lo
allow-hotplug wlan0
iface wlan0 inet static
        address 10.5.5.1
        netmask 255.255.255.0" >> /etc/network/interfaces-wifi
		sudo cp /etc/network/interfaces-hotspot /etc/network/interfaces
	echo "Setup complete"
	fi
	xmessage "A reboot is now required to complete setup. Okay?" -buttons Okay,No
	BOOTQUERY=$?
	if [ $BOOTQUERY -eq 101 ]; then
		sudo reboot
	else
		echo "No hotspot for you then."
	fi
else
	echo "Cancelled"
fi
