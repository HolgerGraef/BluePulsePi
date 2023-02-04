## Download and flash image

```sh
wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-26/2022-09-22-raspios-bullseye-armhf-lite.img.xz
xz -d 2022-09-22-raspios-bullseye-armhf-lite.img.xz
sudo dd if=2022-09-22-raspios-bullseye-armhf-lite.img of=<path to SD card> bs=4M conv=fsync
```

## Set up headless boot

```sh
mkdir /tmp/boot
sudo mount /dev/<boot partition of SD card> /tmp/boot

touch /tmp/boot/ssh
# TODO: wpa_supplicant.conf
# TODO: user setup?

sudo umount /dev/<boot partition of SD card>
```

## Boot and connect via SSH

```sh
ssh pi@<IP address of Raspberry Pi>

# to avoid having to enter password every time:
ssh-copy-id pi@<IP address of Raspberry Pi>
```

## Install dependencies

```sh
sudo apt update
sudo apt upgrade
sudo apt install git mplayer bluez bluez-tools pulseaudio-module-bluetooth
```

### Set up auto login (so that PulseAudio starts)

* Run: `sudo raspi-config`
* Choose option: 1 System Options
* Choose option: S5 Boot / Auto Login
* Choose option: B2 Console Autologin
* Select Finish, and reboot the Raspberry Pi

## Clone the GitHub repository

```sh
git clone https://github.com/HolgerGraef/BluePulsePi.git
```

## Install

```
cd BluePulsePi
sudo ./install.sh
```

## Logs

### bluetooth-agent

```
tail -f /tmp/bt-agent.log
```

### bluetooth-handler

```
tail -f /var/log/bluetooth-handler.log
```

## Debugging udev

### set log level

```sh
sudo udevadm control --log-priority=debug
```

### view logs with udevadm

```sh
udevadm monitor --environment
```

### view logs with syslog

```sh
tail -f /var/log/syslog
```

## References

- https://www.instructables.com/Turn-your-Raspberry-Pi-into-a-Portable-Bluetooth-A/
- https://linuxembedded.fr/2018/03/kernel-udev-et-systemd-la-gestion-du-hotplug
- https://flatcar-linux.org/docs/latest/setup/systemd/udev-rules/
