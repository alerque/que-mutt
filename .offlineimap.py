#!/usr/bin/env python
import subprocess

def gpg_pw(acct):
  path = ".private/%s" % acct
  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
  try:
    return subprocess.check_output(args).strip()
  except subprocess.CalledProcessError:
    return ""
