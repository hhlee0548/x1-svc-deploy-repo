if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" ]]; then
    echo "$0 [install | config | remove]"
    exit 1
fi

ansible-playbook tomcat.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/tomcat/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/tomcat/common.yml \
  -t $* 
