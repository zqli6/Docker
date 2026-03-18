# 什么是 Docker Compose
Docker Compose 是一个用于**定义和管理多个 Docker 容器应用**的工具。  
通过一个 `docker-compose.yml` 文件，可以一键启动、停止和管理整套服务。

---

# Docker Compose 的常用命令及用法

| 命令 | 说明 |
|------|------|
| <code>docker compose up</code> | 启动服务（前台运行） |
| <code>docker compose up -d</code> | 启动服务（后台运行） |
| <code>docker compose down</code> | 停止并删除容器、网络 |
| <code>docker compose ps</code> | 查看运行中的服务 |
| <code>docker compose logs -f</code> | 查看日志（持续输出） |
| <code>docker compose up --build</code> | 重新构建并启动 |
| <code>docker compose stop 服务名</code> | 停止某个服务 |
| <code>docker compose start 服务名</code> | 启动某个服务 |
| <code>docker compose exec 服务名 bash</code> | 进入容器执行命令 |
| <code>docker compose top</code> | 查看资源使用情况 |
