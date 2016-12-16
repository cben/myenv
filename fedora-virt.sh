#!/bin/bash -x

# Thing needed to use kvm/qemu, virt-manager, etc.  Probably incomplete.

sudo dnf -y install virt-manager

# http://unix.stackexchange.com/a/195995/17113
# minus python-virtinst (no such pkg?) plus virtlogd
sudo dnf -y install qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer
sudo systemctl enable libvirtd libvirt-guests virtlogd
sudo systemctl start libvirtd libvirt-guests virtlogd
sleep 1
sudo systemctl status libvirtd libvirt-guests virtlogd --no-pager

# TODO virt-deploy

# Does it work?
virsh -c qemu:///system list --all
virsh list --all
