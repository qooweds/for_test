#!/bin/bash
if [ $# -lt 2 ] ; then
    echo "usage: $0 src_dir dst_dir"
    exit 1
fi
src_dir=$1
dst_dir=$2
echo "sync bin from $src_dir to $dst_dir ..."

for server in gate_server zone_server logic_server name_server log_server datastore_server proxy_server sql server_ctl.sh ; do
    rsync -av  --exclude=".svn" --exclude="file_saver" --exclude="*.log" --exclude="*.data" --exclude="*.dat" --exclude="*.pyc" --exclude="*.txt" --exclude="rank" --exclude="core*" --exclude="*.xml" ${src_dir}/${server} ${dst_dir}/
done
