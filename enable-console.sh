#!/bin/sh
if [ "$USER" != "root" ]; then
  exec /usr/bin/sudo /bin/sh $0 $*
fi

wd=`dirname $0`

config="/etc/default/grub"
backup="/etc/default/grub.`/bin/date +%Y-%m-%d-%H-%M-%S`"
echo "Backing up $config to $backup"
cp "$config" "$backup" || exit 1

echo "Applying patch"
cp "$config" "/tmp/grub"
cd /tmp
patch -p 1 < "$wd/grub.patch" || exit 1

echo "Updating grub"
cp "/tmp/grub" "$config"
update-grub || exit 1

echo "Done"
