# 部署  
1. 目录准备  
```
sudo mkdir -p /data/nexus-data
sudo chown -R 200:200 /data/nexus-data
sudo chmod 755 /data/nexus-data
```
2. 启动  
```
docker run -d \
  --name nexus \
  --restart unless-stopped \
  -p 8081:8081 \
  -v /data/nexus-data:/nexus-data \
  sonatype/nexus3:latest
```  
3. 启动后等待 2～3 分钟，获取初始密码：
```
docker exec nexus cat /nexus-data/admin.password  
```
4. web登录  
浏览器访问 `http://<你的IP>:8081`，用户名 `admin`，密码使用上面命令输出的内容。