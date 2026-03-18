# 什么是 Docker Compose
Docker Compose 是一个用于**定义和管理多个 Docker 容器应用**的工具。  
通过一个 `docker-compose.yml` 文件，可以一键启动、停止和管理整套服务。

---

# Docker Compose 的常用命令及用法

```bash
# 启动服务（前台运行）
docker compose up

# 启动服务（后台运行）
docker compose up -d

# 停止并删除容器、网络
docker compose down

# 查看运行中的服务
docker compose ps

# 查看日志（持续输出）
docker compose logs -f

# 重新构建并启动（代码或配置有变化时）
docker compose up --build

# 停止某个服务
docker compose stop 服务名

# 启动某个服务
docker compose start 服务名

# 进入正在运行的容器（执行命令）
docker compose exec 服务名 bash

# 查看容器资源使用情况
docker compose top
