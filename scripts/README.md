# 1. docker镜像加速  
  注意：修改insecure-registeries是harbor仓库安全地址，按实际替换
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