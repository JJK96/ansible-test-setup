#!/usr/bin/env bash

SSH_CONFIG=~/.ssh/config
SSH_KEY=$(pwd)/ssh_key
ANSIBLE_INVENTORY=./ansible-test
HOSTNAME=ansible-test
OS="debian/bullseye64"
PORT=2222

echo -ne "\n\n" | ssh-keygen -t ed25519 -f "$SSH_KEY"

# Create vagrantfile
function create_vagrantfile() {
    cat << EOF > Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "$OS"
  config.vm.provision "file", source: "${SSH_KEY}.pub", destination: "~/.ssh/me.pub"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL
end
EOF
}
create_vagrantfile

function write_ssh_config() {
    cat << EOF >> "$SSH_CONFIG"

Host ${HOSTNAME}
 User vagrant
 IdentityFile ${SSH_KEY}
 HostName localhost
 Port ${PORT}
 StrictHostKeyChecking=no
 UserKnownHostsFile=/dev/null
EOF
}
write_ssh_config

function write_ansible_inventory() {
    echo "${HOSTNAME} ansible_user=vagrant" > "$ANSIBLE_INVENTORY"
}
write_ansible_inventory

vagrant up
