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

