#!/bin/bash

# credit: https://elinux.org/RPi_Text_to_Speech_(Speech_Synthesis)

say() { local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=en"; }
say $*
