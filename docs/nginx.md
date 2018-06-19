# Nginx Web Server 설계

## 설정 conf
```
domains:
  www.kpaasta.cloud:
    listen: 8080 default_server
    client_max_body_size: 100M
    server_name: kpaasta.cloud www.kpaasta.cloud  portal.kpaasta.cloud
    https_only: https://www.kpaasta.cloud
    error_page_404: /404.html
    error_page_50x: /50x.html
    resources:
      location1:
        location: "/"
        root: /home/ubuntu/nginx/portal
        index: index.html index.htm
      location2:
        location: "/comm/"
        alias: /home/ubuntu/nginx/comm/
      location3:
        location: "/comm-api/"
        rewrite_expression:
          - ^/comm-api/(.*)$ /$1 break; // Rewrite optional
        proxy_pass: http://portal_lb_vip:4443   // 타겟LB: Port   
      location4:
        location: "~ \.php$"
        proxy_pass: http://portal_lb_vip:4443   // 타겟LB: Port     

  www.kpaasta2.cloud:
    listen: 8081
    server_name: kpaasta2.cloud www.kpaasta2.cloud 
    resources:
      location1:
        location: "/"
        root: /home/ubuntu/nginx/portal2
        index: index.html index.htm
```


## 배포 conf
- 서비스 명 단위로 생성 : www.kpaata.cloud
```
server {
    listen 8080 default_server;  // 서비스 포트 (default_server는 기본 서버에만 표시)
    client_max_body_size 100M;   // Client 파일 업로드 최대 파일 크기

    server_name kpaasta.cloud www.kpaasta.cloud  portal.kpaasta.cloud ;  // 서비스 도메인 지정

    if ($http_x_forwarded_proto != 'https') {  // HTTPS Only 옵션
       return 301 https://www.kpaasta.cloud;   // 리다이렉트 도메인 (서비스 도메인 중 선택)
    }

    # 기본 Proxy Service: Path proxy
    location /comm-api/ {   # comm api
        rewrite ^/comm-api/(.*)$ /$1 break; // Rewrite optional
        proxy_pass http://portal_lb_vip:4443; // 타겟LB: Port
    }

    # 기본 Proxy Service: Ext proxy
    location ~ \.php$ {
        proxy_pass http://portal_lb_vip:4443; // 타겟LB: Port
    }

    # 추가 Web 리소스
    location /comm/ {
        alias /home/ubuntu/nginx/comm/;  
    }

    # 기본 Web 리소스
    location / {
        root /home/ubuntu/nginx/portal;
        index index.html;
    }

    # Error 페이지 설정
    error_page 404              /404.html; // Error page path (기본 Web 리소스 Path)
    error_page 500 502 503 504  /50x.html; // Error page path (기본 Web 리소스 Path)  
}
  ```
