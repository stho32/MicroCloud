### Entrance Router Config (MikroTik rb951g-2HnD)

  - **ether1** uses the environment LAN as "internet provider", it is the outer boundary of the "cloud"
  - **ether2** is the local area network that contains the "cloud"

```
# jan/02/1970 00:24:18 by RouterOS 6.40.4
# software id = 82QZ-DS00
#
# model = 951G-2HnD
# serial number = 8A7008DD3EE3

# we do not need wireless, but its built in anyhow...
/interface wireless
set [ find default-name=wlan1 ] ssid=MikroTik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik

# we add an dhcp pool for our cloud.
# the first 10 ips are reserved for static addresses
/ip pool
add name=dhcp_cloud_internal ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=dhcp_cloud_internal disabled=no interface=ether2 lease-time=3d name=dhcp1
/ip address
add address=192.168.88.1/24 interface=ether2 network=192.168.88.0

/ip dhcp-server network
add address=192.168.88.0/24 dns-server=4.2.2.2 gateway=192.168.88.1

# ether1 is our external network
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=ether1

/ip dns static
add address=192.168.88.1 name=router.lan
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/system identity
set name=EntranceRouter
/system ntp client
set enabled=yes primary-ntp=50.19.122.125

```
