#!/bin/bash

INTERFACE_ALIAS_NAME="$(basename -a /sys/class/net/eth*):0"

# create the network interface alias config file for the secondary IP
IP=${1}
NETMASK=${2}
tee /etc/sysconfig/network-scripts/ifcfg-${INTERFACE_ALIAS_NAME} <<EOF
DEVICE=${INTERFACE_ALIAS_NAME}
BOOTPROTO=static
ONBOOT=yes
IPADDR=${IP}
NETMASK=${NETMASK}
EOF

# restart the network
/etc/init.d/network restart
