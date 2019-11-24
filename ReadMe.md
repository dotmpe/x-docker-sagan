This is part of dev/SIEM

To compile `sagan-dev:baseimage-${base}` and run:
```
./run-sagan.sh
```
Where `base` is `master|latest|0.11|...` (`phusion/baseimage` tag)

To test:
```
docker exec -ti sagan_dev logger -t sshd "User ubuntu not allowed because shell /etc/passwd is not executable"
```

v0.2
: New build based on phusion/baseimage. Configured to receive local syslog-ng.
  Still uses the old `docker/run.sh` and config generator.

v0.1
: Initial running server [2019-11-23](log/2019-11-23.md)

#### Bugs
- Alert shows two events for test-case, why?
- Cannot build with `configure.sh --disable-syslog`:
  ```
  config-yaml.c: In function ‘Load_YAML_Config’:
  config-yaml.c:2816:1: error: expected declaration or statement at end of input
   }
  ```
