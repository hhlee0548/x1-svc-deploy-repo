# haproxy

## UI

- 모니터링 비밀번호: haproxy
- 모니터링 접속URL: 

- 서비스명: web-xxx
  - 서비스타입: web-LB
  - 도메인명: www.dom.com   # CXRouter 등록을 위한 도메인
  - 서비스 포트: 80
  - SSL 활성 [v]
    - SSL 서비스 포트: 443
    - 인증서
      - Textfield: Private Key
      - Textfield: Public Key
      - Textfield: CA Key
  - 로드밸런스 옵션: 라운드로빈 / 소스
  - 타겟 서비스: Nginx-80
  - 타켓 서비스 점검 주기: 5초

- 서비스명: mariadb-xyz
  - 서비스타입: MySQL-LB
  - 서비스 포트: 3306
  - 로드밸런스 옵션: 라운드로빈 / 소스
  - 타겟 서비스: Mariadb-3306
  - 타겟 포트: 3306
  - 타켓 서비스 점검 주기: 5초
  - 점검 사용자 아이디: haproxy
  
- 서비스명: mariadb-xyz
  - 서비스타입: Redis-LB
  - 서비스 포트: 6379
  - 로드밸런스 옵션: 라운드로빈 / 소스
  - 타겟 서비스: Redis-6379
  - 타겟 포트: 6379
  - 타켓 서비스 점검 주기: 5초

- 서비스명: comm
  - 서비스타입: API-LB
  - 서비스 포트: 4443
  - 로드밸런스 옵션: 라운드로빈 / 소스
  - 타겟 서비스: Comm-8080
  - 타겟 포트: 8080
  - 점검 URI: /ping
  - 타켓 서비스 점검 주기: 5초


# 설정
```
webs:
  web-xxx:
    ssl_cert_type: self
    ssl_cert_common_name: x1dev.crossent.com
    ssl_cert_file: /etc/ssl/crt/web-xxx.one # user inserted cert file is put
    ssl_source_port: 443 # default: 443
    source_port: 80
    target_port: 80
    target_ips: 
      - 172.19.2.2
      - 172.19.2.10
      - 172.19.2.13
    balance: roundrobin # default: source
    check_inter: 5s

  web-yyy:
    ssl_cert_type: user_input
    ssl_cert_file: /etc/ssl/crt/web-yyy.one # user inserted cert file is put
    ssl_source_port: 443 # default: 443
    source_port: 80
    target_port: 80
    target_ips:
      - 172.19.2.2
      - 172.19.2.10
      - 172.19.2.13
    balance: roundrobin # default: source
    check_inter: 5s


mariadbs:
  mariadb-xyz:
    source_port: 13306
    target_port: 3306
    target_ips: 
    - 192.168.10.4
    - 192.168.10.6
    - 192.168.10.10
    check_user: haproxy
    check_inter: 3s

redises:
  redis-xyz:
    source_port: 16379
    target_port: 6379
    target_ips: 
    - 192.168.10.4
    - 192.168.10.6
    - 192.168.10.10
    check_inter: 3s

apps:
  comm:
    source_port: 14443
    target_port: 4443
    target_ips: 
    - 192.168.10.4
    - 192.168.10.6
    - 192.168.10.10
    monitor_uri: /ping
    check_inter: 3s

  api:
    source_port: 14444
    target_port: 4444
    target_ips:
    - 192.168.10.4
    - 192.168.10.6
    - 192.168.10.10
    monitor_uri: /ping
    check_inter: 3s
```    
- 배포 형상
```
listen iaas
    bind *:4444
    balance source
    mode http
    monitor-uri   /swagger-ui.html
    server api1 172.19.2.11:4444 check inter 3s
    server api2 172.19.2.19:4444 check inter 3s
    server api3 172.19.2.6:4444 check inter 3s
    server 10.0.0.x:80 10.0.0.x:80 maxconn 25 check inter 5s rise 3 fall 2
    
frontend www
    bind *:80
    option httplog
    #option httpclose
    mode http
    log /dev/log local0 debug

    acl xxx hdr(Host) -i xxx.com
    acl yyy hdr(Host) -i yyy.com

    use_backend xxxcom if xxx
    use_backend yyycom if yyy

    default_backend xxxcom

backend xxxcom
    #option httpclose
    mode http
    server app_1 192.168.10.4:8080 check

backend yyycom
    #option httpclose
    mode http
    server app_2 192.168.10.4:8081 check
    
```
