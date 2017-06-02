#!/bin/bash

# Stuff I needed for manageiq container management team.
# Untested for some time.

sudo dnf group install "Development Tools"

#sudo dnf install ruby ruby-devel rubygem-bundler
#sudo dnf builddep rubygem-nokogiri

sudo dnf install go docker etcd

sudo dnf install openssl-devel  # for ruby

sudo /usr/local/bin/ruby-install --system ruby 2.2

# node.js for MIQ

# openshift-ansible
dnf install -y ansible-1.9.4 rubygem-thor rubygem-parseconfig util-linux pyOpenSSL libffi-devel python-cryptography
sudo dnf install -y dnsmasq ebtables genisoimage libselinux-python

# https://github.com/openshift/openshift-ansible/blob/master/README_libvirt.md

# Grant libvirt access.  Test with:
#     virsh -c qemu:///system pool-list
sudo /bin/sh -c "cat - > /etc/polkit-1/rules.d/50-org.libvirt.unix.manage.rules" << EOF
polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.user == "$USER") {
                return polkit.Result.YES;
                polkit.log("action=" + action);
                polkit.log("subject=" + subject);
        }
});
EOF

# Grant homedir access.  Test with:
#     sudo -u qemu ls -d $HOME/Pictures
setfacl -m g:kvm:--x ~

# TODO: https://github.com/openshift/openshift-ansible/blob/master/README_libvirt.md#-enabling-dns-resolution-to-your-guest-vms-with-networkmanager
