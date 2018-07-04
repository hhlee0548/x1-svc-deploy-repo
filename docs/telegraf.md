
## objective
- Add or remove system software monitoring configuration block in /etc/telegraf/telegraf.conf


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
{% if monitor is defined %}
  servers = ["http://admin:{{ haproxy_passwd }}@myhaproxy.com:1936/haproxy?stats"]
{% else %}
  servers = ["http://admin:admin@myhaproxy.com:1936/haproxy?stats"]
{% endif %}
```
