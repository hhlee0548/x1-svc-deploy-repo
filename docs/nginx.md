# Nginx Web Server 설계

## 설정 conf
- 서비스 명 단위로 생성 : www.kpaata.cloud
```
server {
    listen 8080 default_server;  // 서비스 포트 
    client_max_body_size 100M;   // Client 파일 업로드 최대 파일 크기

    server_name kpaasta.cloud www.kpaasta.cloud  portal.kpaasta.cloud ;  // 서비스 도메인 지정

    if ($http_x_forwarded_proto != 'https') {  // HTTPS Only 옵션
       return 301 https://www.kpaasta.cloud;   // 리다이렉트 도메인 (서비스 도메인 중 선택)
    }

    # 기본 Web 리소스
    location / {
        root /home/ubuntu/nginx/portal;
        index index.html;
    }

    # Error 페이지 설정
    error_page 404              /404.html; // Error page path (기본 Web 리소스 Path)
    error_page 500 502 503 504  /50x.html; // Error page path (기본 Web 리소스 Path)
    
    # 추가 Web 리소스
    location /comm/ {
        alias /home/ubuntu/nginx/comm/;  
    }

    # 기본 Proxy Service: Path proxy
    location ^~ /comm-api/ {   # comm api
        rewrite ^/comm-api/(.*)$ /$1 break; // Rewrite optional
        proxy_pass http://portal_lb_vip:4443; // 타겟LB: Port
    }

    # 기본 Proxy Service: Ext proxy
    location ~ \.php$ {
        proxy_pass http://portal_lb_vip:4443; // 타겟LB: Port
    }
  }
  ```
