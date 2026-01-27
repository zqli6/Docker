#!/bin/sh
# 注意：alpine镜像默认没有bash，此处使用sh
#********************************************************************
# Date: 2023-11-13
# FileName: docker-entrypoint.sh
# Description: The test script
# Copyright (C): 2023 All rights reserved
#********************************************************************
mkdir -p ${DIR:-/usr/local/nginx}/conf/conf.d /data/website
# 注意：${DIR:-/usr/local/nginx}如果指定DIR则使用DIR,如没有指定，使用/usr/local/nginx

cat > ${DIR:-/usr/local/nginx}/conf/conf.d/www.conf <<EOF
server {
    listen ${PORT:-80};
    server_name ${SERVER:-www.wang.org};
    root /data/website;
}
EOF
echo ${SERVER:-www.wang.org} > /data/website/index.html
#nginx -g 'daemon off;'
#  也可以直接在nginx.conf配置文件全局段中增加 daemon off;
exec "$@"
