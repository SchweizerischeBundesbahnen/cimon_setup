#!/usr/bin/env bash
# ensure the hdmi output is turned on even if started without attached screen 
# copied from https://raspberrypi.stackexchange.com/questions/2169/how-do-i-force-the-raspberry-pi-to-turn-on-hdmi

# store original file
cp -f /boot/config.txt /boot/config.txt.orig

# first, attempt to remove comment of entries that already exist in the file (default shipped state)
sed "s:#hdmi_force_hotplug:hdmi_force_hotplug:g" /boot/config.txt > /boot/config.tmp
sed "s:#hdmi_drive:hdmi_drive:g" /boot/config.tmp > /boot/config.tmp2
mv -f /boot/config.tmp2 /boot/config.txt
rm -f /boot/config.tmp

# second, to be on the safe side, if the entries are missing, add them
grep hdmi_force_hotplug < /boot/config.txt >> /dev/null
RC_FORCE=$?
grep hdmi_drive < /boot/config.txt >> /dev/null
RC_DRIVE=$?

if [[ $RC_FORCE -ne 0 ]] || [[ $RC_DRIVE -ne 0 ]]; then
  echo "[all]" >> /boot/config.txt
  if [[ $RC_FORCE -ne 0 ]] ; then
    echo "hdmi_force_hotplug=1" >> /boot/config.txt
  fi
  if [[ $RC_DRIVE -ne 0 ]]; then
    echo "hdmi_drive=2" >> /boot/config.txt
  fi
fi
