#!/bin/bash

# TODO: handle first connection instead of just after the fact
# https://help.github.com/articles/testing-your-ssh-connection/

expected_fingerprints_url=https://help.github.com/articles/github-s-ssh-key-fingerprints/
expected_fingerprints=$(curl --silent $expected_fingerprints_url | grep -o 'SHA[^ <]*')
status=0

for domain in github.com gist.github.com; do
  known_hosts_fingerprint=$(ssh-keygen -l -f ~/.ssh/known_hosts | grep " $domain," | grep -o 'SHA\S*')

  if echo $expected_fingerprints | grep $known_hosts_fingerprint; then
    echo "$domain ssh host fingerprint verified"
  else
    echo "=================================================="
    echo "DANGER!  ROGUE $domain SSH FINGERPRINT?"
    echo "=================================================="
    echo "Your known_hosts has: $known_hosts_fingerprint"
    echo "Compare to $expected_fingerprints_url"
    status=1
  fi
done
exit $status
