# Docker

Docker 相关配置与脚本合集，涵盖 Docker 环境安装、Harbor 私有镜像仓库搭建、Dockerfile 镜像构建以及 docker-compose 多服务编排，适用于在服务器上快速搭建容器化运行环境。

## 目录说明

| 目录 | 说明 |
|------|------|
| `scripts/` | Docker 环境一键安装脚本、Harbor 私有镜像仓库安装脚本 |
| `Dockerfile/` | 常用服务的 Dockerfile 示例，包含镜像构建最佳实践 |
| `docker-compose/` | docker-compose 编排文件，包含 WordPress + MySQL 完整部署示例及学习测试用例 |

## 主要内容

- **Docker 安装脚本**：适配国内环境，自动配置镜像加速源
- **Harbor 安装脚本**：搭建企业级私有镜像仓库，支持镜像版本管理与访问控制
- **WordPress + MySQL**：基于 docker-compose 的完整 Web 应用部署示例，包含数据持久化配置
- **Dockerfile 示例**：多阶段构建、环境变量注入等常用构建模式

## 快速开始
```bash
# 克隆仓库
git clone https://github.com/zqli6/Docker/
# 或 Gitee
git clone https://gitee.com/zqli6/Docker/

# 获取单个文件（以 Docker 安装脚本为例）
wget https://raw.githubusercontent.com/zqli6/Docker/main/path/to/file
```
