ansible-playbook nginx.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  --key-file=~/.ssh/id_rsa \
  -i vars/nginx/hosts \
  --extra-vars @vars/nginx/common.yml \
  -t install 
#  -vv
