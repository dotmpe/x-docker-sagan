#!/usr/bin/env bash

# Trigger OpenSSH 5000020, 5000077
logger -t sshd "User ubuntu not allowed because shell /etc/passwd is not executable"


# Trigger Bash 5002324 SSH agent forwarding
logger -t bash "HISTORY ssh -A blah"


#logger -p 0 "Level zero (emerg)"
logger -p 1 "Level one (alert)"
logger -p 2 "Level two (crit)"
logger -p 3 "Level three (error)"

#
