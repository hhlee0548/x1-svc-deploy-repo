ansible-playbook ../tomcat.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i ../vars/tomcat/hosts \
  --key-file=/tmp/lb.pem \
  --extra-vars @../vars/tomcat/common.yml \
  -t install
