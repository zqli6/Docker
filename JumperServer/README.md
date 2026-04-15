# 1. Jumperserver
本说明中的镜像均已做SWR镜像仓库加速
## 1. 安装教程
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
# 2。 登录位置为docker主机IP
账号：admin
密码：ChangeMe
```

#### docker-compose部署JumperServer  
 官方docker-compose：https://github.com/jumpserver/Dockerfile/blob/v4.1.0/allinone/docker-compose.yml
```
apt update && apt -y install docker-compose python3-pip
```
```
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1panel.live"
    ]
}
EOF
```
```
systemctl restart docker;docker-compose version
```
```
mkdir /usr/local/src/JumperServer;cd /usr/local/src/JumperServer
```
```
wget https://gitee.com/zqli6/Docker/raw/main/JumperServer/docker-compose.yaml
```
```
docker-compose up -d
docker-compose ps
docker-compose logs jms_all # -f
```
```
地址: http://<JumpServer服务器IP地址>:<服务运行端口>
用户名: admin
密码: ChangeMe
```
# 3. 脚本一键安装  
官方：https://docs.jumpserver.org/zh/v3/installation/setup_linux_standalone/online_install/
```
[root@ubuntu2404 ~]#VERSION=4.10.15
[root@ubuntu2404 ~]#VERSION=4.10.7
[root@ubuntu2404 ~]#VERSION=4.10.2
[root@ubuntu2404 ~]#curl -sSL https://resource.fit2cloud.com/jumpserver/jumpserver/releases/download/v${VERSION}/quick_start.sh|bash
```

# 4. 使用nginx配置https  
## 1. nginx安装及证书生成  
```
apt install nginx -y
```
```
[root@jenkins ssl ]# mkdir /etc/nginx/ssl/
[root@jenkins ssl ]# cd /etc/nginx/ssl

[root@jenkins ssl ]# openssl genrsa -out ca.key 4096

[root@jenkins ssl ]# openssl req -x509 -new -nodes -sha512 -days 3650 \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=jms.lzq.com" \
    -key ca.key \
    -out ca.crt

[root@jenkins ssl ]# ls
ca.crt  ca.key

[root@jenkins ssl ]# openssl genrsa -out jms.lzq.com.key 4096
[root@jenkins ssl ]# ls
ca.crt  ca.key  jms.lzq.com.key

[root@jenkins ssl ]# openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=jms.lzq.com" \
    -key jms.lzq.com.key \
    -out jms.lzq.com.csr

[root@jenkins ssl ]# cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=jms.lzq.com # 此处必须和和harbor的网站名称一致
EOF    

[root@jenkins ssl ]#  openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in jms.lzq.com.csr -out jms.lzq.com.crt
```
查看证书
```
openssl x509 -in jms.lzq.com.crt -noout -text
```
## 2. nginx配置文件  
```
cat /etc/nginx/conf.d/jms.conf<<'EOF'
# 1. Server 块：定义监听的端口和域名
server {
    listen 80;
    server_name jms.lzq.com; # 替换为你的实际域名或 IP

    # 强制将 HTTP 转发到 HTTPS (生产环境建议)
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl; 
    server_name jms.lzq.com;

    # SSL 证书配置
    ssl_certificate /etc/nginx/ssl/jms.lzq.com.crt;
    ssl_certificate_key /etc/nginx/ssl/jms.lzq.com.key;

    # 2. Location 块：定义具体的转发规则（也就是你刚才看的那部分）
    location / {
        proxy_pass http://127.0.0.1:880;   # 此处端口应与docker-compose.yaml中jumperserver的端口一致
        proxy_http_version 1.1;
        
        # 刚才讨论的参数放这里
        client_max_body_size 4096m; 

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 600s;
        proxy_send_timeout 600s;
        proxy_read_timeout 600s;
    }
}
EOF
```
## 3. 修改docker-compose.yaml中端口  
```
services.jumpserver.ports

ports:
      - ${HTTP_PORT:-880}:80/tcp
      - ${SSH_PORT:-2222}:2222/tcp
```





