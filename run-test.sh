#!/usr/bin/env bash
docker exec -ti sagan_dev logger -t sshd "User ubuntu not allowed because shell /etc/passwd is not executable"
logger -t sshd "User ubuntu not allowed because shell /etc/passwd is not executable"
#
