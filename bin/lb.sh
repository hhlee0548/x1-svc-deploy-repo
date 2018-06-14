ansible-playbook ../lb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i ../vars/lb/hosts \
  --key-file=/tmp/lb.pem \
  --extra-vars @../vars/lb/common.yml \
  -t install
