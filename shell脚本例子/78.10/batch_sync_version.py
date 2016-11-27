#!/bin/env python

import sys,os
import subprocess

from server_list import *


def sync_file(version,host,basedir):
    cmd="/usr/bin/rsync -av  --port=8733 --exclude='.svn' %s/* %s::%s/"%(version,host,basedir)
    try:
        result = subprocess.check_call(cmd,shell=True,stdout=sys.stdout,stderr=sys.stdout)
    except subprocess.CalledProcessError:
        print "exec [%s] failed" % cmd
        return False

    print "exec [%s] success" % cmd
    

def main(argv):
    arg_size = len(argv)
    if arg_size < 3 :
        print "%s {version} {server list}" % argv[0]
        exit(1)
    version = argv[1]
    for i in range(2,arg_size) :
        server = argv[i]
        if server_list.has_key(server):
            sync_file(version,server_list[server][0],server_list[server][1])
            #sync_file(server,server_list[server][0],server_list[server][1])
        else:
            print "cannot find [%s]  , ignore ..." % server
    

if __name__ == "__main__":
    try:
        main(sys.argv)
    except KeyboardInterrupt:
        pass
