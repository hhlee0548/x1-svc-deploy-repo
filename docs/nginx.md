# Nginx Web Server 설계

## 사용자 UI
/////////////////////////////

- 서버 포트: 8080
- 서버 도메인: 
  - (기본) kpaasta.cloud
  - (추가) www.kpaasta.cloud  (-)
  - (추가) portal.kpaasta.cloud (+)
- HTTPS 활성화: True/False
  - HTTPS Only: True/False
    - RedirectURL: https://www.kpaasta.cloud
  - SSL 인증서: 
    - Textfield: Private Key 
    - Textfield: Public Key
    - Textfield: CA Key
- 웹 리소스
  - 접속경로 기본: "/" 
    - 파일 지정 [X] LB 지정 [ ]
      - 파일 경로: /home/ubuntu/nginx/default/
      - 지정 방식: Zip 파일 직접 업로드 [ ] Github 위치 지정 [ ]
  - 접속경로 추가: "/comm/" 
    - 파일 지정 [X] LB 지정 [ ]
      - 파일 경로: /home/ubuntu/nginx/comm/
      - 지정 방식: Zip 파일 직접 업로드 [ ] Github 위치 지정 [ ]
  - 접속경로 추가: "/comm-api/" 
    - 파일 지정 [ ] LB 지정 [X]
      - LB 선택: LB-WAS
- 에러 페이지: 
  - 404 에러: /404.html
  - 50x 에러: /50x.html
- 업로드 최대 파일 크기: 10M

/////////////////////////////

- 서버 포트: 8080
- 서버 도메인: 
  - (기본) kpaasta2.cloud
  - (추가) portal.kpaasta2.cloud (+)
- HTTPS 활성화: True/False
  - HTTPS Only: True/False
    - RedirectURL: https://www.kpaasta.cloud
  - SSL 인증서: 
    - Textfield: Private Key 
    - Textfield: Public Key
    - Textfield: CA Key
- 웹 리소스
  - 접속경로 기본: "/" 
    - 파일 지정 [X] LB 지정 [ ]
      - 파일 경로: /home/ubuntu/nginx/default/
      - 지정 방식: Zip 파일 직접 업로드 [ ] Github 위치 지정 [ ]
  - 접속경로 추가: "/comm/" 
    - 파일 지정 [X] LB 지정 [ ]
      - 파일 경로: /home/ubuntu/nginx/comm/
      - 지정 방식: Zip 파일 직접 업로드 [ ] Github 위치 지정 [ ]
  - 접속경로 추가: "/comm-api/" 
    - 파일 지정 [ ] LB 지정 [X]
      - LB 선택: LB-WAS
- 에러 페이지: 
  - 404 에러: /404.html
  - 50x 에러: /50x.html
- 업로드 최대 파일 크기: 10M

/////////////////////////////


## 설정 conf
- resource 의 location 규칙
  - location 값은 필수
  - root 혹은 alias 중 하나 선택 가능
  - proxy_pass 혹은 root/alias 중 하나 선택 가능
  - proxy_pass 선택 시 rewrite_expression 을 추가할 수 있음
    (rewrite_expression 값이 /xxx 로 시작되는 경우 기본값 "^/xxx/(.*)$ /$1 break" 옵션 생성) 
- rosource 위치
  - 기본 설정 기준 /home/ubuntu/nginx/default  
```
servers:
  server-1:
    listen: 8080 default_server
    client_max_body_size: 100M
    server_name: kpaasta.cloud www.kpaasta.cloud  portal.kpaasta.cloud
    https_only_redirect: https://www.kpaasta.cloud
    error_page_404: /404.html
    error_page_50x: /50x.html
    resources:
      location1:
        location: "/"
        root: /home/ubuntu/nginx/default
        index: index.html index.htm
      location2:
        location: "/comm/"
        alias: /home/ubuntu/nginx/comm/
      location3:
        location: "/comm-api/"
        rewrite_expression:
          - ^/comm-api/(.*)$ /$1 break
        proxy_pass: http://www.kpaasta.cloud:4443
      location4:
        location: "~ \\.php$"
        proxy_pass: http://www.kpaasta.cloud:4443

  server-2:
    listen: 8081
    server_name: kpaasta2.cloud www.kpaasta2.cloud
    resources:
      location1:
        location: "/"
        root: /home/ubuntu/nginx/default
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

## Template
```
{% if servers is defined %}
{% for name, v in servers.items() %}
server {
    listen {{ v.listen }};
    client_max_body_size {{ v.client_max_body_size | default("10M") }};
    server_name {{ v.server_name }};
    error_page 404              {{ v.error_page_404 | default("/404.html") }};
    error_page 500 502 503 504  {{ v.error_page_50x | default("/50x.html") }};

{%  if v.https_only_redirect is defined %}
    if ($http_x_forwarded_proto != 'https') {
       return 301 {{ v.https_only_redirect }};
    }
{%  endif %}

{%   if v.resources is defined %}
{%   for loc, lv in v.resources.items() %}
    location {{ lv.location }} {
{%     for exp in lv.rewrite_expression | default({}) %}
        rewrite {{ exp }};
{%     endfor -%}
{%     if lv.proxy_pass is defined %}
        proxy_pass {{ lv.proxy_pass }};
{%     endif -%}
{%     if lv.root is defined %}
        root {{ lv.root }};
{%     endif -%}
{%     if lv.alias is defined %}
        root {{ lv.alias }};
{%     endif -%}
     }
{%  endfor %}
{%  endif %}
}
{% endfor %}
{% endif %}
```
