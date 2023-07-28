## Configuration
| Parameter | Description | Default
| --------- | ----------- | -------
| config | Bind9 ConfigMap data | 
| env | Bind9 image environment variables | 
| replicas | The number of replicas to create | 1
| service.ports | Ports to connect to Bind9 | 
| service.type | Type of Kubernetes service |
| strategy  | The deployment strategy to use to replace existing pods with new ones | "rollingUpdate"

`values.yaml` example:
```yaml
config:
  named.conf: |
    acl trusted { 192.168.1.0/24; localhost; };
    acl guest   { 10.1.30.0/24; };

    options {
    directory "/var/cache/bind";

    allow-query { trusted; };
    allow-recursion { any; };

    forwarders {
        1.1.1.1;
        8.8.8.8;
    };
    };

    view trusted {
    match-clients { trusted; };
    allow-recursion { any; };

    zone "my.zone" IN {
        type primary;
        file "/etc/bind/my.zone.zone";
    };
    };

    view guest {
    match-clients { guest; };
    allow-recursion { any; };
    };  
  my.zone.zone: |
    $TTL 1d;
    $ORIGIN my.zone.;

    @         IN      SOA   ns.my.zone. info.my.zone (

                            2023072000 ; serial number
                            12h        ; refresh
                            15m        ; update retry
                            3w         ; expiry
                            2h         ; minimum
                            )
              IN      NS    ns.my.zone.
    ns        IN      A     192.168.1.1

    server1   IN      A     192.168.1.11
    server2   IN      A     192.168.1.12
env:
  - name: TZ
    value: Europe/Moscow
  - name: BIND9_USER
    value: bind
service:
  type: LoadBalancer
  ports:
    - name: 53-53-tcp
      port: 53
      protocol: TCP
      target: 53
    - name: 53-53-udp
      port: 53
      protocol: UDP
      target: 53
```