#!/bin/sh
echo "Flushing iptables rule in 5 seconds (ctrl-c to stop it)..."
sleep 5
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
