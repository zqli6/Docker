# 什么是 Docker Compose
Docker Compose 是一个用于**定义和管理多个 Docker 容器应用**的工具。  
通过一个 `docker-compose.yml` 文件，可以一键启动、停止和管理整套服务。

---

# Docker Compose 的常用命令及用法

| 命令 | 说明 |
|------|------|
| ```bash<br>docker compose up<br>``` | 启动服务（前台运行） |
| ```bash<br>docker compose up -d<br>``` | 启动服务（后台运行） |
| ```bash<br>docker compose down<br>``` | 停止并删除容器、网络 |
| ```bash<br>docker compose ps<br>``` | 查看运行中的服务 |
| ```bash<br>docker compose logs -f<br>``` | 查看日志（持续输出） |
| ```bash<br>docker compose up --build<br>``` | 重新构建并启动 |
| ```bash<br>docker compose stop 服务名<br>``` | 停止某个服务 |
| ```bash<br>docker compose start 服务名<br>``` | 启动某个服务 |
| ```bash<br>docker compose exec 服务名 bash<br>``` | 进入容器执行命令 |
| ```bash<br>docker compose top<br>``` | 查看资源使用情况 |
