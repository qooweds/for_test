#!/bin/bash

rsync -av --port=8733 --exclude=".svn" $1/* kingnet@192.168.110.154::data/tools/$1/

rsync -av --port=8733 --exclude=".svn" $1/* kingnet@42.62.56.227::data/tools/$1/

ssh kingnet@192.168.110.154 "/usr/bin/rsync -av --port=8733 /data/tools/$1/* kingnet@210.65.163.28::data/tools/$1/"
