#!/bin/bash
if [ $# -lt 2 ] ; then
    echo "usage: $0 src_dir dst_dir"
    exit 1
fi
src_dir=$1
dst_dir=$2
echo "sync game config from $src_dir to $dst_dir ..."

for server in dirty_word quest streams maps ; do
    rsync -av --exclude=".svn" --exclude="*.log"  ${src_dir}/${server} ${dst_dir}/
done
