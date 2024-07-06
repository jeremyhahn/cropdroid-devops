ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country={{ wlan_country }}

network={
  ssid="{{ wlan_ssid }}"
  scan_ssid=1
  psk="{{ wlan_psk }}"
  key_mgmt={{ wlan_key_mgmt }}
}
