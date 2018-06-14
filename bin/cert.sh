ansible-playbook ../cert.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  --extra-vars @../vars/haproxy/common.yml \
  -t cert 
  #-vvv

