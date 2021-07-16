#!/bin/bash
# This script is to connect remote server using name instead of ip.


WORK_DIR=$(dirname $(readlink -f $0))


ali="***"
vultr="***"
sensetime="***"


# The ${1} is the user name and the ${2} is the remote server name.
sshpass ${1}@${!2}
