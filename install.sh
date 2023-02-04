#! /bin/bash

check_overwrite () {
    if [ -f "$1" ]; then
        if [ -n "$FORCE" ]; then
            echo "WARNING: will overwrite $1"
            rm $1
        else
            echo "ERROR: $1 already exists"
            exit 1
        fi
    fi  
}

echo "##### Installing BluePulsePi #####"

set -e

# TODO: should be provided by command line parameter
FORCE=1

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

NUM_INTERFACES=`ls /var/lib/bluetooth | wc -l`
if [ "$NUM_INTERFACES" -ne 1 ]; then
    echo "Found $NUM_INTERFACES bluetooth interfaces instead of one"
    exit 1
fi

#### set up paths, check for existing files and remove them if in force-mode
LOCAL_MAC=`ls /var/lib/bluetooth`
CONFIG_FILE="/var/lib/bluetooth/$LOCAL_MAC/config"
check_overwrite "$CONFIG_FILE"

AUDIO_CONF_FILE="/etc/bluetooth/audio.conf"
check_overwrite "$AUDIO_CONF_FILE"

RULES_FILE="/etc/udev/rules.d/99-input.rules"
check_overwrite "$RULES_FILE"

UDEV_SCRIPT_FILE="/usr/lib/udev/bluetooth"
check_overwrite "$UDEV_SCRIPT_FILE"

SERVICE_FILE="/etc/systemd/system/bluetooth-attach@.service"
check_overwrite "$SERVICE_FILE"

INIT_SCRIPT_FILE="/etc/init.d/bluetooth-agent"
check_overwrite "$INIT_SCRIPT_FILE"

SPEECH_SCRIPT_FILE="/usr/bin/speech.sh"
check_overwrite "$SPEECH_SCRIPT_FILE"

#### install
echo "Setting up $AUDIO_CONF_FILE..."
cp audio.conf "$AUDIO_CONF_FILE"

echo "Setting up $CONFIG_FILE..."
# TODO: device name should be a parameter
echo "name Pioneer" >> $CONFIG_FILE
echo "class 0x20041C" >> $CONFIG_FILE

echo "Setting up $RULES_FILE..."
echo 'SUBSYSTEM=="input", GROUP="input", MODE="0660"' >> $RULES_FILE
echo 'KERNEL=="input[0-9]*", TAG+="systemd", ENV{SYSTEMD_WANTS}="bluetooth-attach@%n.service"' >> $RULES_FILE

echo "Setting up $UDEV_SCRIPT_FILE..."
cp bluetooth $UDEV_SCRIPT_FILE

echo "Setting up $SERVICE_FILE"
cp bluetooth-attach.service $SERVICE_FILE

echo "Setting up $INIT_SCRIPT_FILE"
cp bluetooth-agent $INIT_SCRIPT_FILE

echo "Setting up $SPEECH_SCRIPT_FILE"
cp speech.sh $SPEECH_SCRIPT_FILE

update-rc.d bluetooth-agent defaults

udevadm control --reload-rules && udevadm trigger

systemctl daemon-reload

# TODO: update /etc/bluetooth/main.conf with correct name and class
