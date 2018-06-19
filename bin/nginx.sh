ansible-playbook ../nginx.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i ../vars/nginx/hosts \
  --key-file=/tmp/lb.pem \
  --extra-vars @../vars/nginx/common.yml \
  -t install 
#  -vv
