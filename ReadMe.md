This is part of dev/SIEM

## Log

### [2019-11-23] 
Trying to give quadrantsec's Sagan a spin in docker. Found a year old docker
image.

After cloning `sagan-rules`, and adding a file config_data to its checkout,
e.g.:
```
include $RULE_PATH/apache.rules
include $RULE_PATH/apc-emu.rules
include $RULE_PATH/arp.rules
include $RULE_PATH/asterisk.rules
```

Then the following goes a long way:
```
docker run -ti --rm -v $HOME/project/sagan-rules:/usr/local/etc/sagan-rules defensative/def-sagan:defensative-1.8
```
But startup still fails at sagan user, or some missing dir.

Need ``--env default_host=192.168.9.31`` probably?

###### Other observations
The installation instructions are slightly stale
<https://wiki.quadrantsec.com/bin/view/Main/SaganInstall>,
missing some bit on ``autogen.sh``. Just like `jonschipp`'s Dockerfile.
<https://github.com/jonschipp/dockerfiles/blob/master/islet-sagan/Dockerfile>

Maybe `defensative` will run still, did not test yet.
<https://hub.docker.com/r/defensative/def-sagan/dockerfile/>

##### Conclusion
``/root/run.sh`` is not up to run latest version.

Hacking gets it running to read rsyslog pipe, but not JSON. No mention of failed
or successful mapping.

TODO: remote rsyslog

