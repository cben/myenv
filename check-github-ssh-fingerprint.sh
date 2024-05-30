#!/bin/bash

# TODO: handle first connection instead of just after the fact
# https://help.github.com/articles/testing-your-ssh-connection/

expected_fingerprints_url=https://help.github.com/en/articles/github-s-ssh-key-fingerprints
expected_fingerprints=$(curl --location --silent $expected_fingerprints_url | grep -o 'SHA[^ <]*')
status=0

for domain in github.com gist.github.com; do
  known_hosts_fingerprints=$(ssh-keygen -l -f ~/.ssh/known_hosts | grep " $domain" | grep -o 'SHA\S*')
  echo "For $domain your known_hosts has: $known_hosts_fingerprints"

  for fp in $known_hosts_fingerprints; do
    if echo $expected_fingerprints | grep --quiet $fp; then
      echo "$domain ssh host fingerprint '$fp' verified"
    else
      echo "=================================================="
      echo "DANGER!  ROGUE $domain SSH FINGERPRINT '$fp'?"
      echo "=================================================="
      status=1
    fi
  done
done

[ $status != 0 ] && echo "Compare to $expected_fingerprints_url"
exit $status
