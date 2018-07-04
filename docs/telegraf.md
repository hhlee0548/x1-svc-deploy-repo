
## objective
- Add or remove system software monitoring configuration block in /etc/telegraf/telegraf.conf


## telegraf
- haproxy monitor example 
```
- name: telegraf add haproxy monitoring
  ini_file:
    path: /etc/telegraf/telegraf.conf
    section: "[inputs.haproxy]"
    option: "{{ item.option }}"
    value: "{{ item.value }}"
    state: present
  with_items:
    - { option: "servers", value: ["http://admin:{% if monitor is defined %}{{ monitor.haproxy_passwd | default('admin') }}{% else %}admin{% endif %}@localhost:1936/haproxy?stats"] }
  notify: restart-telegraf
  when: telegraf_conf.stat.exists
  tags:
  - install
  - config

- name: telegraf remove haproxy monitoring
  ini_file:
    path: /etc/telegraf/telegraf.conf
    section: "[inputs.haproxy]"
    state: absent
  when: telegraf_conf.stat.exists
  tags:
  - remove
```
## haproxy monitoring
- 설정 가용
```
# Read metrics of haproxy, via socket or csv stats page
[[inputs.haproxy]]
  ## An array of address to gather stats about. Specify an ip on hostname
  ## with optional port. ie localhost, 10.10.3.33:1936, etc.
  ## Make sure you specify the complete path to the stats endpoint
  ## including the protocol, ie http://10.10.3.33:1936/haproxy?stats

  ## If no servers are specified, then default to 127.0.0.1:1936/haproxy?stats
  servers = ["http://myhaproxy.com:1936/haproxy?stats"]

  ## You can also use local socket with standard wildcard globbing.
  ## Server address not starting with 'http' will be treated as a possible
  ## socket, so both examples below are valid.
  # servers = ["socket:/run/haproxy/admin.sock", "/run/haproxy/*.sock"]

  ## By default, some of the fields are renamed from what haproxy calls them.
  ## Setting this option to true results in the plugin keeping the original
  ## field names.
  # keep_field_names = true

  ## Optional SSL Config
  # ssl_ca = "/etc/telegraf/ca.pem"
  # ssl_cert = "/etc/telegraf/cert.pem"
  # ssl_key = "/etc/telegraf/key.pem"
  ## Use SSL but skip chain & host verification
  # insecure_skip_verify = false
```
- 설정 적용
```
[[inputs.haproxy]]
  servers = ["http://admin:{{ haproxy_passwd | default('admin') }}@myhaproxy.com:1936/haproxy?stats"]
```
## nginx monitoring
- 설정 가용
```
# # Read Nginx's basic status information (ngx_http_stub_status_module)
# [[inputs.nginx]]
#   # An array of Nginx stub_status URI to gather stats.
#   urls = ["http://localhost/server_status"]
#
#   # TLS/SSL configuration
#   ssl_ca = "/etc/telegraf/ca.pem"
#   ssl_cert = "/etc/telegraf/cert.cer"
#   ssl_key = "/etc/telegraf/key.key"
#   insecure_skip_verify = false
#
#   # HTTP response timeout (default: 5s)
#   response_timeout = "5s"
```
- 설정 적용
```
[[inputs.nginx]]
urls = ["http://localhost/nginx_status","http://localhost:8080/nginx_status"]
```

## tomcat monitoring
- 설정 가용
```
# # Gather metrics from the Tomcat server status page.
# [[inputs.tomcat]]
#   ## URL of the Tomcat server status
#   # url = "http://127.0.0.1:8080/manager/status/all?XML=true"
#
#   ## HTTP Basic Auth Credentials
#   # username = "tomcat"
#   # password = "s3cret"
#
#   ## Request timeout
#   # timeout = "5s"
#
#   ## Optional SSL Config
#   # ssl_ca = "/etc/telegraf/ca.pem"
#   # ssl_cert = "/etc/telegraf/cert.pem"
#   # ssl_key = "/etc/telegraf/key.pem"
#   ## Use SSL but skip chain & host verification
#   # insecure_skip_verify = false
```
- 설정 적용
```
[[inputs.tomcat]]
url = "http://127.0.0.1:8080/manager/status/all?XML=true"
username = "tomcat"
password = "s3cret"
```


## mysql monitoring
- 설정 가용
```
# [[inputs.mysql]]
#   ## specify servers via a url matching:
#   ##  [username[:password]@][protocol[(address)]]/[?tls=[true|false|skip-verify|custom]]
#   ##  see https://github.com/go-sql-driver/mysql#dsn-data-source-name
#   ##  e.g.
#   ##    servers = ["user:passwd@tcp(127.0.0.1:3306)/?tls=false"]
#   ##    servers = ["user@tcp(127.0.0.1:3306)/?tls=false"]
#   #
#   ## If no servers are specified, then localhost is used as the host.
#   #servers = ["tcp(127.0.0.1:3306)/"]
#   servers = ["root:root@tcp(127.0.0.1:3306)/?tls=false"]
#   ## the limits for metrics form perf_events_statements
#   perf_events_statements_digest_text_limit  = 120
#   perf_events_statements_limit              = 250
#   perf_events_statements_time_limit         = 86400
#   #
#   ## if the list is empty, then metrics are gathered from all databasee tables
#   table_schema_databases                    = []
#   #
#   ## gather metrics from INFORMATION_SCHEMA.TABLES for databases provided above list
#   gather_table_schema                       = false
#   #
#   ## gather thread state counts from INFORMATION_SCHEMA.PROCESSLIST
#   gather_process_list                       = true
#   #
#   ## gather thread state counts from INFORMATION_SCHEMA.USER_STATISTICS
#   gather_user_statistics                    = false
#   #
#   ## gather auto_increment columns and max values from information schema
#   gather_info_schema_auto_inc               = false
#   #
#   ## gather metrics from INFORMATION_SCHEMA.INNODB_METRICS
#   gather_innodb_metrics                     = true
#   #
#   ## gather metrics from SHOW SLAVE STATUS command output
#   gather_slave_status                       = false
#   #
#   ## gather metrics from SHOW BINARY LOGS command output
#   gather_binary_logs                        = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.TABLE_IO_WAITS_SUMMARY_BY_TABLE
#   gather_table_io_waits                     = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.TABLE_LOCK_WAITS
#   gather_table_lock_waits                   = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.TABLE_IO_WAITS_SUMMARY_BY_INDEX_USAGE
#   gather_index_io_waits                     = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.EVENT_WAITS
#   gather_event_waits                        = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.FILE_SUMMARY_BY_EVENT_NAME
#   gather_file_events_stats                  = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.EVENTS_STATEMENTS_SUMMARY_BY_DIGEST
#   gather_perf_events_statements             = false
#   #
#   ## Some queries we may want to run less often (such as SHOW GLOBAL VARIABLES)
#   interval_slow                   = "30m"

#   ## Optional SSL Config (will be used if tls=custom parameter specified in server uri)
#   ssl_ca = "/etc/telegraf/ca.pem"
#   ssl_cert = "/etc/telegraf/cert.pem"
#   ssl_key = "/etc/telegraf/key.pem"
```
- 설정 적용
```
[[inputs.mysql]]
servers = ["root:root@tcp(127.0.0.1:3306)/?tls=false"]
```
