# Tomcat 설계


## Tomcat 설정
```
java_package: openjdk-8-jdk  //  openjdk-9-jdk 두 옵션 지원

tomcat_download_url: http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz
tomcat_version: tomcat-7.0.61
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


