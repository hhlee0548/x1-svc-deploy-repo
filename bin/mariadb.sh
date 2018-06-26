ansible-playbook mariadb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/mariadb/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/mariadb/common.yml \
  -t $*
#-t install
