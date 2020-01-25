### Entrance Router Config (MikroTik rb951g-2HnD)

  - **ether1** uses the environment LAN as "internet provider", it is the outer boundary of the "cloud"
  - **ether2** is the local area network that contains the "cloud"

```
# jan/25/2020 15:45:23 by RouterOS 6.40.4

# software id = 82QZ-DS00

#

# model = 951G-2HnD

# serial number = 8A7008DD3EE3

/interface wireless

set [ find default-name=wlan1 ] ssid=MikroTik

/interface wireless security-profiles

set [ find default=yes ] supplicant-identity=MikroTik

/ip pool

add name=dhcp_cloud_internal ranges=192.168.88.10-192.168.88.254

/ip dhcp-server

add address-pool=dhcp_cloud_internal disabled=no interface=ether2 lease-time=3d name=dhcp1

/ip address

add address=192.168.88.1/24 interface=ether2 network=192.168.88.0

/ip dhcp-client

add dhcp-options=hostname,clientid disabled=no interface=ether1

/ip dhcp-server network

add address=192.168.88.0/24 dns-server=4.2.2.2 gateway=192.168.88.1

/ip dns static

add address=192.168.88.1 name=router.lan

/ip firewall nat

add action=dst-nat chain=dstnat comment="IIS Freigabe" dst-address=192.168.0.130 dst-port=8080 protocol=tcp to-addresses=192.168.88.2 to-ports=80

add action=masquerade chain=srcnat out-interface=ether1

/ip service

set telnet disabled=yes

set ftp disabled=yes

set www address=192.168.88.0/24

set api disabled=yes

set winbox address=192.168.88.0/24

set api-ssl disabled=yes

/system clock

set time-zone-name=Europe/Berlin

/system identity

set name=EntranceRouter

/system ntp client

set enabled=yes primary-ntp=50.19.122.125

```
