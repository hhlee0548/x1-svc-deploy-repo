ansible-playbook ../keepalived.yml ../haproxy.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i ../vars/keepalived/hosts \
  -i ../vars/haproxy/hosts \
  --key-file=/tmp/lb.pem \
  --extra-vars @../vars/keepalived/common.yml \
  --extra-vars @../vars/haproxy/common.yml \
  -t install
