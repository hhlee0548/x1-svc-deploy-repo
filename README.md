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

sudo apt-get install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install pyopenssl
EOF
```
- 배포 실행 
```
. install.sh
```
## 디렉토리 구성
- bin: 배포 실행 파일
  - lb.sh: keepalived & haproxy 배포
  - keepalived.sh: keepalived 배포 (vip 서비스 제공)
  - haproxy.sh: port forwarding 서비스 (Software LB 역할)
- vars : 배포시 설정 파일
  - */hosts : 호스트명 및 IP
  - */common.yml : 서비스 설정
- roles : ansible role 정의 파일

## LB 배포
- 인증서 등록
  - 사용자 인증서 등록 시 사전 조치
    - ansible controller 의 /etc/ssl/crt/[web-app-name].one 위치에 파일을 등록
    - 해당 파일은 private key > public key > parent public key 를 모두 포함
  - OpenSSL 인증서 직접 생성 시에는 다음 명령을 실행
```
bin/cert.sh
```
- lb 배포
```
bin/lb.sh
```
- bin/lb.sh 
  - hosts, lb.pem, common.yml 설정은 실 배포 환경에 맞게 재 지정하여 사용
```
ansible-playbook ../lb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i ../vars/lb/hosts \
  --key-file=/tmp/lb.pem \
  --extra-vars @../vars/lb/common.yml \
  -t install
```
