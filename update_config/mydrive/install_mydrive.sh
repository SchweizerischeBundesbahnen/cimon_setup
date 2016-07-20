#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# setup the cloud drive mydrive via webdav for remote configuration
if [[ ! $1 || ! $2 ]]; then
    echo "2 parameters required: mydrive username and password"
    exit 7
fi
# install and configure davfs2
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install davfs2
echo "davfs2 davfs2/suid_file boolean true" | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive davfs2
# does only work after restart...
sudo usermod -aG davfs2 pi
# configure mydrive
mkdir -p ~/.davfs2
echo -e "\n#configuration for sbb cimon mydrive, FSe 2016\nask_auth 0\nuse_locks 0" > ~/.davfs2/davfs2.conf
echo -e "#configuration for sbb cimon mydrive, FSe 2016\nhttps://webdav.mydrive.ch $1 $2\n" > ~/.davfs2/secrets
chmod 600 ~/.davfs2/secrets
sudo mkdir -p /mnt/mydrive
sudo bash -c "echo -e '\n#configuration for sbb cimon mydrive, FSe 2016\nhttps://webdav.mydrive.ch /mnt/mydrive davfs noauto,defaults,user,rw\n' >> /etc/fstab"