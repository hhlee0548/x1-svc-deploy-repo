# System software 로그 syslog 전환 설정

## nginx
- nginx -> syslog 출력 설정
- 파일 : /etc/nginx/nginx.conf
```
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log;
==>
access_log syslog:server=unix:/dev/log,nohostname,facility=local7,severity=info combined;
error_log syslog:server=unix:/dev/log,nohostname,facility=local7,severity=error warn;
```

## haproxy 
- 설정 파일 변경
- 파일 /etc/rsyslog.d/49-haproxy.conf의 다음 라인 주석처리
```
if $programname startswith 'haproxy' then /var/log/haproxy.log
==>
#if $programname startswith 'haproxy' then /var/log/haproxy.lo
```

## mariadb
- mariadb은 디폴트 syslog사용

## tomcat8 
- syslog handler 커스터마이징(com.agafua.syslog.SyslogHandler)
- 기존 오픈소스 com.agafua.syslog.SyslogHandler를 수정하여 기존 syslog포멧에 맞도록 변경 및 빌드 (agafua-syslog-0.3.jar)

### tomcat8 syslog 환경 설정

1. rsyslog - 설정
  파일 : /etc/rsyslog.conf
```
# provides TCP syslog reception
#module(load="imtcp")
#input(type="imtcp" port="514")
==>
# provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" address="127.0.0.1" port="514")
```
2. rsyslog - 재기동
```
sudo service rsyslog restart
```

3. tomcat8 - agafua-syslog-0.3.jar추가
```
/usr/share/tomcat8/lib/agafua-syslog-0.3.jar
```

4. tomcat8 - classpath 추가
- /usr/local/tomcat/{{ tomcat_version }}/bin/setenv.sh 파일 생성
```
#!/bin/bash
CLASSPATH="${CLASSPATH}:/usr/local/tomcat/{{ tomcat_version }}/lib/agafua-syslog-0.3.jar"
```
```
sudo chmod 744  /usr/local/tomcat/{{ tomcat_version }}/bin/setenv.sh
```
5. tomcat8 - log 설정 추가
- 파일 : /usr/local/tomcat/{{ tomcat_version }}/conf/logging.properties
```
handlers = 1catalina.org.apache.juli.FileHandler, 2localhost.org.apache.juli.FileHandler, java.util.logging.ConsoleHandler
.handlers = 1catalina.org.apache.juli.FileHandler, java.util.logging.ConsoleHandler
==> 
handlers = 1catalina.org.apache.juli.FileHandler, 2localhost.org.apache.juli.FileHandler, java.util.logging.ConsoleHandler, com.agafua.syslog.SyslogHandler
.handlers = 1catalina.org.apache.juli.FileHandler, java.util.logging.ConsoleHandler, com.agafua.syslog.SyslogHandler

#syslog 추가
com.agafua.syslog.SyslogHandler.transport = tcp
com.agafua.syslog.SyslogHandler.facility = local7
com.agafua.syslog.SyslogHandler.port = 514
com.agafua.syslog.SyslogHandler.hostname = 127.0.0.1
com.agafua.syslog.SyslogHandler.tag = tomcat8
com.agafua.syslog.SyslogHandler.formatter = java.util.logging.SimpleFormatter
```

6. tomcat8 - 재기동
```
sudo service tomcat8 restart
```

7. syslog 확인
![image](https://user-images.githubusercontent.com/29765201/42433201-3d4e0596-8389-11e8-8c79-fc5d6790882a.png)


8. elasticsearh 조회
![image](https://user-images.githubusercontent.com/29765201/42433379-14214826-838a-11e8-9aaf-d11539b554a0.png)


## 참고자료
- https://github.com/KMK-ONLINE/SyslogValve
