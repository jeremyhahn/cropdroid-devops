require dhcp_server_identifier
slaac private

interface eth0
static ip_address={{ eth0_cidr }}
static routers={{ eth0_routers }}
static domain_name_servers={{ eth0_dns }}

interface wlan0
static ip_address={{ wlan_cidr }}
static routers={{ wlan_routers }}
static domain_name_servers={{ wlan_dns }}
