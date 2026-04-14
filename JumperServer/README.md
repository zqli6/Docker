# Jumperserver
#### 介绍

#### 软件架构

#### 安装教程
docker 镜像加速
```
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1panel.live",
        "https://docker.1ms.run",
        "https://docker.xuanyuan.me"
    ],
    "insecure-registries": ["harbor.wang.org"]
}
EOF
```
1.  安装
官方网站：https://github.com/jumpserver/Dockerfile/tree/master/allinone#dockerfile 
[lzq的文档](https://www.yuque.com/jianglai-iayzx/sa1zul/nidzdheqlwsgp4au#HQSCi) 
   1. 创建自定网络，让三个容器在同一个网络实现容器名通信
   ```
   docker network create --subnet 172.30.0.0/16 jumpserver-net
   ```
   1. 安装数据库MySQL  
   ```
   docker run --name mysql \
     -e MYSQL_ROOT_PASSWORD=123456 \
     -e MYSQL_DATABASE=jumpserver \
     -e MYSQL_USER=jumpserver \
     -e MYSQL_PASSWORD=123456 \
     -d \
     -v ./mysqld.cnf:/etc/mysql/conf.d/mysqld.cnf \
     -v /data/mysql:/var/lib/mysql \
     --restart always \
     --network jumpserver-net \
     registry.cn-beijing.aliyuncs.com/wangxiaochun/mysql:8.0.29-oracle
   ```
   2. 安装redis  
   ```
   docker run -d --name redis --restart always --network \
   jumpserver-net -v /data/redis:/data registry.cn-beijing.aliyuncs.com/wangxiaochun/redis:7.2.5
   ```
   3. 生成随机token  
   ```
   [root@ubuntu2004 ~]# cat >key.sh<<-"EOF"
   #!/bin/bash
   if [ ! "$SECRET_KEY" ]; then
     SECRET_KEY=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50`;
     echo "SECRET_KEY=$SECRET_KEY" >> ~/.bashrc;
     echo SECRET_KEY=$SECRET_KEY;
   else
     echo SECRET_KEY=$SECRET_KEY;
   fi
   if [ ! "$BOOTSTRAP_TOKEN" ]; then
     BOOTSTRAP_TOKEN=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 24`;
     echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bashrc;
     echo BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN;
   else
     echo BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN;
   fi
   EOF

   [root@ubuntu2004 ~]# bash key.sh
   [root@ubuntu2004 ~]# tail -n2 .bashrc
   SECRET_KEY=9RTRBg3AjHjvUUNCUpHUH5LirSFazRozk1UyOQcoKkwMExeUEm
   BOOTSTRAP_TOKEN=1OlaSdCoUpSQPjH6
   ```
   4. 安装Jumpersever  
   ```
   # 创建自定义网络可以使用容器名通信，所以下方使用MySQL/redis的pod名
   [root@ubuntu2404 ~]#docker run --name jms_all -d \
     --network jumpserver-net \
     # 添加自定义网络
     --restart always \
     # 添加开机自动启动
     -p 80:80 \
     -p 2222:2222 \
     -p 30000-30100:30000-30100 \
     -e SECRET_KEY=6T5eFTGkNajOfMDecLkSJSLgEi5NeaRIL7z26j3VSX4jDHlPzZ \
     -e BOOTSTRAP_TOKEN=O2GT7OYxmsU3h1G7oea53cWFrznagN \
     -e LOG_LEVEL=ERROR \
     -e DB_ENGINE=mysql \
     # 新版必需要求，默认postgreSQL
     -e DB_HOST=mysql \
     -e DB_PORT=3306 \
     -e DB_USER=jumpserver \
     -e DB_PASSWORD=123456 \
     -e DB_NAME=jumpserver \
     -e REDIS_HOST=redis \
     -e REDIS_PORT=6379 \
     -e REDIS_PASSWORD='123456' \
     --privileged=true \
     -v /opt/jumpserver/core/data:/opt/jumpserver/data \
     -v /opt/jumpserver/koko/data:/opt/koko/data \
     -v /opt/jumpserver/lion/data:/opt/lion/data \
     -v /opt/jumpserver/kael/data:/opt/kael/data \
     -v /opt/jumpserver/chen/data:/opt/chen/data \
     -v /opt/jumpserver/web/log:/var/log/nginx \
     swr.cn-southwest-2.myhuaweicloud.com/zqli/jumpserver/jms_all:v4.10.16-lts
     # jumpserver/jms_all:v4.10.15
     # registry.cn-beijing.aliyuncs.com/wangxiaochun/jms_all:v4.10.2
   ```
2. 验证  
```
# 查看jumpserver-v3.4.3日志确认成功
docker logs -f jms_all
# 查看端口
ss -ntl
```
```
# 查看 MySQL 中生成相关表
docker exec -it mysql sh
# mysql -ujumpserver -p123456 jumperserver
```
3.  web访问  
```
# 登录位置为docker主机IP
账号：admin
密码：ChangeMe
```

#### docker-compose部署JumperServer  
 官方docker-compose：https://github.com/jumpserver/Dockerfile/blob/v4.1.0/allinone/docker-compose.yml
```
[root@ubuntu2404 ~]#apt update && apt -y install docker-compose python3-pip
[root@ubuntu2404 ~]#cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1panel.live"
    ]
}
EOF
[root@ubuntu2404 ~]# systemctl restart docker
[root@ubuntu2404 ~]# docker-compose version
```
docker compose 
```
1.  xxxx
2.  xxxx
3.  xxxx

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
