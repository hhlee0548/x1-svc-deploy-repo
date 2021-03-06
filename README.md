# x1-svc-deploy-repo
시스템 소프트웨어(WEB, WAS, DB, LB) 배포 용 Ansible 소스.

## Ansible Controller 환경 구성
- 배포 실행 
```
bin/install.sh
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

## 공통 테그
- roles 은 공용으로 다음의 테그 값을 제공
  - install : 서비스 패키지 설치
  - remove : 서비스 패키지 삭제
  - config : 설정 업데이트 및 서비스 재시동
  - start : 서비스 시작
  - stop : 서비스 중지
  - restart : 서비스 재시동
  
## 배포
- 인증서 등록
  - 사용자 인증서 등록 시 사전 조치
    - ansible controller 의 임의 위치에 인증서 파일을 등록
    - 인증서 파일은 private key > public key > parent public key 를 모두 포함
  - OpenSSL 인증서 직접 생성 시에는 다음 명령을 실행
    - 실행후 /etc/ssl/crt/[web-app-name].one 위치에 haproxy 용 파일이 생성
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
ansible-playbook lb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/lb/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/lb/common.yml \
  -t $*
```
- LB 배포
  - keepalived 설정 [common.yml](vars/keepalived/common.yml) | [hosts](vars/keepalived/hosts)
  - haproxy 설정 [common.yml](vars/haproxy/common.yml) | [hosts](vars/haproxy/hosts)
```
bin/lb.sh [ install | config | remove | start | stop | restart | status | info | deploy ]
```
- Nginx 배포
  - nginx 설정 [common.yml](vars/nginx/common.yml) | [hosts](vars/nginx/hosts)  
```
bin/nginx.sh [ install | config | remove | start | stop | restart | status | info | deploy ]
```
- Tomcat 배포
  - tomcat 설정 [common.yml](vars/tomcat/common.yml) | [hosts](vars/tomcat/hosts)  
```
bin/tomcat.sh [ install | config | remove | start | stop | restart | status | info | deploy ]
```
- Mariadb 배포
  - mariadb 설정 [common.yml](vars/mariadb/common.yml) | [hosts](vars/mariadb/hosts)  
```
bin/mariadb.sh [ install | config | remove | start | stop | restart | status | info ]
```
- 공통 명령
  - install: 신규 설치
  - config: 설정 업데이트 및 적용
  - remove: 설치 리소스 삭제
  - start: 서비스 시작
  - stop: 서비스 중지
  - restart: 서비스 재시작
  - status: 서비스 프로세스 상태 및 실행 상태 정보
  - info: 서비스 설치 경로
  - deploy: 배포
    - haproxy: SSL 인증서 배포
    - nginx: zip 웹리소스 배포
    - tomcat: war 웹리소스 배포
  
