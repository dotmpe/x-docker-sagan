This is part of dev/Cloud/SIEM

A test setup for Sagan.

- Sagan is a log processor.
- Meer is a log spooler
- EveBox is a web frontend (for Suricata+ES, but can read EVE JSON into sqlite)
- Enterprise Log Search and Archive (ELSA)


# Containerized Sagan

Build from ./Dockerfile.

To compile `sagan-dev:baseimage-${base}` and run use:
```
./run-sagan.sh
```
Where `base` is `master|latest|0.11|...` (`phusion/baseimage` tag)

To test:
```
docker exec -ti sagan_dev logger -t sshd "User ubuntu not allowed because shell /etc/passwd is not executable"
```

To use, point rsyslog to send logs to UDP 5514.

Run sa-mode EveBox ``./run-evebox.sh`` web UI at :5636


# Syslog receiver
Not sure why using SyslogNG iso rsyslog

10-sagan-pipe.conf works, but even when using HOST the hostnames do not show
up anywhere in Sagan, even if dns lookup seems to work OK (otherwise default-
host is used).

10-sagan-json.conf does not work with almost same setup, it defaults the source
adress.


# Status
Using baseimage so syslog-ng receiver can run beside sagan.

See syslog section.

Occasionally the FIFO open seems to stall but have not figured out why. Normal
startup should report something like this:
```

  Dec 23 20:44:39 sagan-dev sagan[87]: [*] 
  Dec 23 20:44:39 sagan-dev sagan[87]: [*] Attempting to open syslog FIFO (/var/run/sagan.fifo).
  Dec 23 20:44:39 sagan-dev sagan[87]: [*] Successfully opened FIFO (/var/run/sagan.fifo).
  Dec 23 20:44:39 sagan-dev sagan[87]: [*] FIFO capacity is 65536 bytes.  Changing to 1048576 bytes.
```


# Log

[2022-12-21]
: Committing accumulated, some initial script to build ELSA image as well but
  that is pretty stale and EveBox runs fine as UI.
  Looked at (but not using) quadrantsec/meer, a spooler that can enrich as well.

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
