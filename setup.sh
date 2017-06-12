set -e
sudo -v

INTERNAL="eth0"
EXTERNAL="eth1"

mkdir /tmp/netboot
tar -xf netboot.tar.gz -C /tmp/netboot
sudo ifconfig $INTERNAL 192.168.13.1/16 # Make sure NetworkManager doesn't override this
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo iptables -t nat -A POSTROUTING -o $EXTERNAL -j MASQUERADE
sudo iptables -A FORWARD -i $EXTERNAL -o $INTERNAL -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $INTERNAL -o $EXTERNAL -j ACCEPT
sudo dnsmasq -d -C dnsmasq.conf
