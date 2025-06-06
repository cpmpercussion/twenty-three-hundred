#!/bin/sh

sudo sh -c 'cat > /etc/udev/rules.d/49-stm32.rules' <<EOF
# 0483:374b - STM32F4 Dsicovery in USB Serial Mode (CN5)
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0666"

# 0483:df11 - STM32F4 Discovery in DFU mode (CN5)
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE:="0666"
EOF

sudo udevadm control --reload-rules

echo "Unplug and replug your device to activate the new rules."
