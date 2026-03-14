# 1. docker镜像加速  
  注意：修改insecure-registeries是harbor仓库地址，按实际替换
该地址允许 **Docker 通过 HTTP 或不受信任证书访问** harbor.lzq.org 这个私有仓库。
```
cat >/etc/docker/daemon.json<<-"EOF"
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1panel.live",
        "https://docker.1ms.run",
        "https://docker.xuanyuan.me"
    ],
	"insecure-registries": ["harbor.lzq.org"]
}
EOF
```