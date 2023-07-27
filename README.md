# Test setup for ansible

To test ansible deployment, it is useful to have a local VM to which to deploy.
The script `create_test_setup.sh` performs several steps to make a test setup:

1. Create an SSH key
2. Deploy a Vagrant VM with this key
3. Write an ssh config to your ~/.ssh/config
4. Write an ansible inventory

FIRST READ THE SCRIPT CAREFULLY SO YOU KNOW WHAT IS GOING TO HAPPEN.

Then execute the script:

    ./create_test_setup.sh

Afterwards, you can use ansible to deploy to it as follows:

    ansible-playbook -i ansible-test ...
