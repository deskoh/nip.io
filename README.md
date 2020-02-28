# NIP.IO

Dead simple wildcard DNS for any IP Address.

[NIP.IO](http://nip.io) is powered by [PowerDNS](https://powerdns.com) with a simple,
custom [PipeBackend](https://doc.powerdns.com/authoritative/backends/pipe.html):
[backend.py](nipio/backend.py)

Head to [NIP.IO](http://nip.io) for more details.

NIP.IO is licensed under [Apache 2.0](LICENSE.txt), and is a free service run by
[Exentrique Solutions](http://exentriquesolutions.com)

## Features

* Forwarding DNS server (requires PowerDNS < 4.1)
  * Recursive queries are forwarded to Google DNS Server (`8.8.8.8`). (see `pdns/pdns.conf`)
* BIND DNS Server (see `pdns/bind`)
* Wildcard DNS similar to [NIP.IO](http://nip.io) (see `backend.conf` to change domain)
  * Non-wildcard entries are resolved to 127.0.0.1 (see `backend.conf`)

## Getting Started

```sh
# Build docker image
docker build -t pdns .

# Quickstart (Linux)
docker run -d --name pdns -v $(pwd)/pdns/bind:/etc/bind -p 53:53/udp --restart=always pdns

# Quickstart (Windows)
docker run -d --name pdns -v C:/.../pdns/bind:/etc/bind -p 53:53/udp --restart=always pdns

# Run in foreground, remove container when stopped.
docker run --rm -p 53:53/udp pdns

# Open shell in container to inspect, remove container when stopped.
docker run --rm -it -p 53:53/udp pdns /bin/ash
```

## Configurations

### Configure BIND

Overwrite BIND configuration using `-v` flag.

```
docker run --rm -v $(pwd)/bind:/etc/pdns/bind -p 53:53/udp pdns
```

### Configure PowerDNS

To configure values in `pdns.conf`, use `PDNS_{pdns-config-key}={config-value}`. e.g. To change upstream DNS server for recursive query, set `PDNS_recursor=8.8.8.8`.

```
docker run --rm -it -e PDNS_recursor=8.8.8.8 -p 53:53/udp pdns /bin/ash
```

Alternatively, overwrite `pdns.conf` with your own file using `-v` flag.

```
docker run --rm -v $(pwd)/pdns.conf:/etc/pdns/pdns.conf -p 53:53/udp pdns
```

### Configure Wildcard DNS domain

Use `DOMAIN` environment variable to specify wildcard domain (e.g. `DOMAIN=nip.io`).

```
docker run --rm -e DOMAIN=nip.io -p 53:53/udp pdns
```
