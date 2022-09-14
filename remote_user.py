#!/usr/bin/python3

import sys,os,cgi

remuser = os.environ["REMOTE_USER"]

uniqname = remuser.split("@")

print('Content-type: text/html\n')
print('<!DOCTYPE html>')
print('<html>')
print('<head>')
print('<meta charset="utf-8">')
print('<title>Remote User</title>')
print('</head>')
print('<body>')
print('<tt>')

print(remuser)
print(uniqname[0])

print('</tt>')
print('</body>')
print('</html>')
