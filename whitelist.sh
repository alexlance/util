#!/bin/bash

address=$(cat /dev/stdin | grep -iE '^From:' | sed -s 's/^From: \?//' | sed -s 's/.*<//' | sed -s 's/>$//')

echo "whitelist_from ${address}" >> /home/alla/.spamassassin/whitelist_from.txt

