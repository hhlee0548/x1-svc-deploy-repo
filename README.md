# x1-svc-deploy-repo
Ansible Repository for Service Deployment

## Ansible Controller 환경 구성
- 배포 실행 파일 생성
```
cat << EOF >> install.sh
#!/bin/bash
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
EOF
```
- 배포 실행 
```
. install.sh
```

## LB 배포
- lb keepalived 설정
  - (호스트 정의 파일 사례) keepalived-hosts 
  - (파라미터 설정 파일 사례) roles/keepalived/vars/common.yml 
- lb keepalived 배포
  - 호스트 파일은 임시 파일로 처리: /tmp/hosts-xxx
  - 파라미터 파일은 임시 파일로 처리: /tmp/common-xxx
```
ansible-playbook keepalived.yml \
                 -i /tmp/hosts-xxx  \
                 -e 'ansible_python_interpreter=/usr/bin/python3' \
                 --key-file=/tmp/lb.pem \
                 --extra-vars @/tmp/common-xxx  \
                 -t install
```

- lb haproxy 설정
  - haproxy-hosts
  - roles/haproxy/vars/common.yml

- lb haproxy 배포
```
ansible-playbook haproxy.yml \
                 -i haproxy-hosts \
                 -e 'ansible_python_interpreter=/usr/bin/python3' \
                 --key-file=/tmp/lb.pem \
                 --extra-vars @roles/haproxy/vars/common.yml  \
                 -t install
```
