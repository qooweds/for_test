#!/bin/env python

import sys,os
import subprocess

from server_list import *

def exec_remote_ctl(cmd,host,basedir):
    cmd="/usr/bin/ssh %s  /%s/server_ctl.sh %s"%(host,basedir,cmd)
    try:
        result = subprocess.check_call(cmd,shell=True,stdout=sys.stdout,stderr=sys.stderr)
    except subprocess.CalledProcessError:
        print "exec [%s] failed" % cmd
        return False

    print "exec [%s] success" % cmd
    

def main(argv):
    arg_size = len(argv)
    if arg_size < 3 :
        print "%s {stop|start|status|check} server" % argv[0]
        exit(1)
    cmd = argv[1]
    for i in range(2,arg_size) :
        server = argv[i]
        if server_list.has_key(server):
            exec_remote_ctl(cmd,server_list[server][0],server_list[server][1])
        else:
            print "cannot find [%s]  , ignore ..." % server
    

if __name__ == "__main__":
    try:
        main(sys.argv)
    except KeyboardInterrupt:
        pass
