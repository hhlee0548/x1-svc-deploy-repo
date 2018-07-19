# Tomcat 설계

## Tomcat UI
- JDK Version: 8 
- 버전: Tomcat-7 (Tomcat-8 지정 가능)
- 서비스 포트: 8084
- 최소 메모리: 512M
- 최대 메모리: 1024M
- 관리자 유저명: admin
- 관리자 비밀번호: **** 
- 설치 위치: /usr/local/tomcat/tomcat-7/
- War 리소스
  - App 명: "homepage" 
    - 파일 경로: /usr/local/tomcat/tomcat-7/webapps/homepage/
    - 지정 방식: Zip 파일 직접 업로드 [ ] 릴리즈 다운로드 위치 지정 [ ]
  - App 명: "uaa" 
    - 파일 경로: /usr/local/tomcat/tomcat-7/webapps/uaa/
    - 지정 방식: Zip 파일 직접 업로드 [ ] 릴리즈 다운로드 위치 지정 [ ]

## Tomcat 설정
```
java_package: openjdk-8-jdk  //  openjdk-9-jdk 두 옵션 지원
tomcat_version: tomcat-7 // 8
tomcat_memory_ms: 512M
tomcat_memory_mx: 1024M
admin_username: admin
admin_password: admin
http_port: 8084
```

## Tomcat 배포 conf
- 서비스 명 단위로 생성 : www.kpaata.cloud
- /usr/local/tomcat/conf/server.xml
```
<?xml version='1.0' encoding='utf-8'?>
<Server port="8005" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <Listener className="org.apache.catalina.core.JasperListener" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />

  <GlobalNamingResources>
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>
  <Service name="Catalina">
    <Connector port="8084" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
   <Engine name="Catalina" defaultHost="localhost">
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>
      <Host name="localhost"  appBase="webapps" unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
      </Host>
    </Engine>
  </Service>
</Server>
```
- /usr/local/tomcat/tomcat-7.0.61/conf/tomcat-users.xml
```
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
  <user username="admin" password="admin" roles="manager-gui" />
</tomcat-users>
```

## WebApp 배포 


