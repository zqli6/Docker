# Docker

Docker 相关配置与脚本合集，涵盖 Docker 环境安装、Harbor 私有镜像仓库搭建、Dockerfile 镜像构建以及 docker-compose 多服务编排，适用于在服务器上快速搭建容器化运行环境。

## 包含内容

1. **scripts**：Docker 离线安装脚本（适用于无外网环境）、Harbor 私有镜像仓库安装脚本、Docker 代理配置脚本、daemon.json 配置模板
2. **Dockerfile**：Ubuntu、Alpine 基础镜像，Nginx（普通构建和多阶段构建两个版本，多阶段构建版本编译环境与运行环境分离，镜像体积更小）、Apache、Tomcat 镜像构建示例
3. **docker-compose**：WordPress + MySQL LAMP 部署（含数据持久化配置）、若依前后端分离版完整部署、Spug 开源运维平台部署

## 实用工具
### composerize — docker run 命令转 docker-compose

将一条 `docker run` 命令快速转换为对应的 `docker-compose.yml` 格式，在线使用无需安装。

> 在线工具：https://www.composerize.com/


### runlike — 反推容器的 docker run 命令

对一个已运行的容器，自动输出当初启动它所用的完整 `docker run` 命令，适合在没有原始脚本的情况下快速还原容器配置。

> 项目地址：https://github.com/lavie/runlike
```bash
# 安装
pip install runlike

# 查看容器的启动命令（-p 参数格式化输出）
runlike -p <容器名或ID>

# 不想安装，直接用 Docker 运行
alias runlike="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock assaflavie/runlike"
runlike -p <容器名或ID>
```

### Whaler — 从镜像反推 Dockerfile

对一个已有的镜像，反推出构建它所用的 Dockerfile，同时会扫描镜像中可能存在的敏感文件和环境变量。

> 项目地址：https://github.com/P3GLEG/Whaler
```bash
# 直接用 Docker 运行（推荐）
docker run -t --rm -v /var/run/docker.sock:/var/run/docker.sock:ro pegleg/whaler -sV=1.36 <镜像名:tag>

# 设置别名方便使用
alias whaler="docker run -t --rm -v /var/run/docker.sock:/var/run/docker.sock:ro pegleg/whaler"
whaler -sV=1.36 nginx:latest
```

## 快速获取单个文件
```bash
# GitHub（国内可用 ghproxy 加速）
wget https://raw.githubusercontent.com/zqli6/Docker/main/path/to/file
wget https://ghproxy.net/https://raw.githubusercontent.com/zqli6/Docker/main/path/to/file

# Gitee（国内推荐）
wget https://gitee.com/zqli6/Docker/raw/main/path/to/file
```

## 克隆仓库
```bash
git clone https://github.com/zqli6/Docker/
git clone https://gitee.com/zqli6/Docker/
```

> 环境：Ubuntu 20.04+ / Rocky 8+，Docker 20.10+，docker-compose v2.x
