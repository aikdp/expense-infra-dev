#!/bin/bash

dnf install ansible -y
cd /tmp

git clone https://github.com/aikdp/expense-ansi.git
# git clone https://github.com/daws-81s/expense-ansible.git

# git clone https://github.com/aikdp/expense-ansible/tree/main/practicing.git

cd expense-ansi

cd practicing

# ansible-playbook -i inventory.ini mysql.yaml

# ansible-playbook -i inventory.ini backend.yaml

# ansible-playbook -i inventory.ini frontend.yaml

ansible-playbook -i inventory.ini pra-mysql.yaml

ansible-playbook -i inventory.ini pra-backend.yaml

ansible-playbook -i inventory.ini pra-frontend.yaml