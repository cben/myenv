# Virtual machines stuff on fedora. Untested for some time.

sudo dnf install libvirt
sudo service libvirtd start

sudo dnf install virt-manager
# https://github.com/simon3z/virt-deploy/issues/8 - run virt-manager to actually create default storage pool.

cd /etc/yum.repos.d/
sudo curl -O https://copr.fedorainfracloud.org/coprs/fsimonce/virt-deploy/repo/fedora-23/fsimonce-virt-deploy-fedora-23.repo
sudo dnf install virt-deploy

sudo virt-deploy create go-week01 centos-7.1
