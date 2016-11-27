#!/bin/bash

socket_ip="$1"

echo "'UC outer ip'or 'ZhongShan inner ip' is $socket_ip"

rsync -av --port=8733 ./tools/* kingnet@$socket_ip::data/xy/
