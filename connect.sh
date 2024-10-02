MAC="6C:93:08:62:70:00"

is_device_paired() {
  bluetoothctl paired-devices | grep -qi "$MAC"
}

pair_and_connect_device() {
  echo "Pairing and connecting to device $MAC..."
  bluetoothctl power on || { echo "Failed to power on Bluetooth"; exit 1; }
  bluetoothctl agent on || { echo "Failed to activate agent"; exit 1; }
  sleep 5
  bluetoothctl pair $MAC || { echo "Failed to pair device"; exit 1; }
  bluetoothctl trust $MAC || { echo "Failed to trust device"; exit 1; }
  bluetoothctl connect $MAC || { echo "Failed to connect device"; exit 1; }
  echo "Device paired and connected successfully"
}

unpair_device() {
  echo "Unpairing device $MAC..."
  bluetoothctl remove $MAC || { echo "Failed to unpair device"; exit 1; }
  echo "Device unpaired successfully"
}

if is_device_paired; then
  echo "Device already connected"
  unpair_device
  pair_and_connect_device
else
  pair_and_connect_device
fi