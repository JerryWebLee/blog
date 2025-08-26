# 🚀 Nuxt 4博客项目部署指南

## 📋 项目概述

本项目为Nuxt 4博客应用提供了完整的Docker部署解决方案，支持本地构建镜像、推送到Docker Hub，并通过SSH远程部署到云服务器。

## 📁 核心文件结构

```
blog/
├── Dockerfile                    # 多阶段构建配置
├── .dockerignore                 # 构建优化配置
├── nuxt.config.docker.ts         # Docker专用Nuxt配置
├── deploy.config.example         # 配置模板
├── docker-compose.prod.yml       # 生产环境配置
├── scripts/
│   ├── build-and-push.sh         # 构建推送脚本
│   ├── remote-deploy.sh          # 远程部署脚本
│   └── deploy-all.sh             # 一键部署脚本
├── QUICK_START.md                # 快速开始指南
└── DEPLOYMENT.md                 # 详细部署文档
```

## 🚀 快速开始

### 1. 配置部署环境

```bash
# 复制配置文件
cp deploy.config.example deploy.config.json

# 编辑配置文件
vim deploy.config.json
```

配置示例：

```json
{
  "docker": {
    "registry": "your-dockerhub-username",
    "imageName": "nuxt-blog",
    "tag": "latest"
  },
  "servers": {
    "production": {
      "host": "your-server-ip",
      "user": "your-username",
      "port": 22,
      "deployPath": "/home/your-username/nuxt-blog",
      "dockerComposeFile": "docker-compose.prod.yml"
    }
  },
  "app": {
    "port": 3000,
    "containerName": "nuxt-blog-app"
  }
}
```

### 2. 配置SSH免密登录

```bash
# 生成SSH密钥（如果还没有）
ssh-keygen -t rsa -b 4096

# 复制公钥到服务器
ssh-copy-id your-username@your-server-ip
```

### 3. 登录Docker Hub

```bash
docker login
```

### 4. 一键部署

```bash
# 部署到生产环境
./scripts/deploy-all.sh production

# 或者部署指定版本
./scripts/deploy-all.sh production v1.2.0
```

## 🔧 核心脚本说明

| 脚本                        | 功能                           | 使用示例                                        |
| --------------------------- | ------------------------------ | ----------------------------------------------- |
| `scripts/deploy-all.sh`     | 一键部署（构建+推送+远程部署） | `./scripts/deploy-all.sh production v1.2.0`     |
| `scripts/build-and-push.sh` | 本地构建并推送镜像             | `./scripts/build-and-push.sh production v1.2.0` |
| `scripts/remote-deploy.sh`  | 远程部署到服务器               | `./scripts/remote-deploy.sh production v1.2.0`  |

## 🛠️ 环境要求

### 本地环境

- Docker Desktop
- jq (JSON处理工具)
- SSH客户端
- Git

### 服务器环境

- Docker
- Docker Compose
- 开放3000端口（或自定义端口）

## 🐛 常见问题解决

### 1. 权限问题

```bash
# 手动修复权限
ssh your-username@your-server-ip "sudo mkdir -p /path/to/deploy && sudo chown your-username:your-username /path/to/deploy"
ssh your-username@your-server-ip "sudo usermod -aG docker your-username"
```

### 2. 架构不匹配问题

```bash
# 手动重新构建（指定平台）
docker build --platform linux/amd64 -t your-registry/nuxt-blog:latest .
```

### 3. SSH连接失败

```bash
# 测试SSH连接
ssh -o ConnectTimeout=10 your-username@your-server-ip

# 检查免密登录
ssh -o BatchMode=yes your-username@your-server-ip "echo 'SSH连接成功'"
```

### 4. Docker Hub推送失败

```bash
# 检查登录状态
docker info | grep Username

# 重新登录
docker login
```

## 📊 监控和维护

### 查看应用状态

```bash
# 容器状态
ssh your-username@your-server-ip "docker ps"

# 应用日志
ssh your-username@your-server-ip "docker logs nuxt-blog-app"

# 资源使用
ssh your-username@your-server-ip "docker stats nuxt-blog-app"
```

### 管理容器

```bash
# 重启服务
ssh your-username@your-server-ip "cd /path/to/deploy && docker compose restart"

# 停止服务
ssh your-username@your-server-ip "cd /path/to/deploy && docker compose down"

# 查看状态
ssh your-username@your-server-ip "cd /path/to/deploy && docker compose ps"
```

### 更新部署

```bash
# 更新到新版本
./scripts/deploy-all.sh production v1.3.0
```

### 回滚部署

```bash
# 回滚到指定版本
./scripts/remote-deploy.sh production v1.1.0
```

## 🔒 安全建议

1. **定期更新系统**: 保持服务器系统最新
2. **防火墙配置**: 只开放必要端口
3. **SSH安全**: 使用密钥认证，禁用密码登录
4. **Docker安全**: 定期更新Docker版本
5. **备份数据**: 定期备份重要数据

## 📞 获取帮助

```bash
# 查看脚本帮助
./scripts/deploy-all.sh --help
./scripts/build-and-push.sh --help
./scripts/remote-deploy.sh --help

# 查看详细文档
cat DEPLOYMENT.md
```

## 🎯 下一步

- 阅读 [DEPLOYMENT.md](./DEPLOYMENT.md) 了解详细部署流程
- 配置CI/CD流水线实现自动化部署
- 设置监控和告警系统
- 配置负载均衡和高可用

## 🔒 安全特性

1. **非root用户运行** - 容器使用非root用户提高安全性
2. **SSH密钥认证** - 支持免密登录验证
3. **健康检查** - 自动故障检测和恢复
4. **资源限制** - 内存和CPU使用限制
5. **日志轮转** - 防止日志文件过大

## 📈 性能优化

1. **多阶段构建** - 减少最终镜像大小
2. **Alpine基础镜像** - 轻量级运行环境
3. **依赖缓存** - 优化构建速度
4. **.dockerignore** - 减少构建上下文

## 🎯 最佳实践

1. **版本管理** - 使用语义化版本控制
2. **环境隔离** - 生产、测试环境分离
3. **配置管理** - 敏感信息通过环境变量管理
4. **监控告警** - 建立应用监控机制
5. **备份策略** - 定期备份重要数据

## 📞 获取帮助

```bash
# 查看脚本帮助
./scripts/deploy-all.sh --help
./scripts/build-and-push.sh --help
./scripts/remote-deploy.sh --help

# 查看详细文档
cat QUICK_START.md
cat DEPLOYMENT.md
```

## 🎉 总结

这个部署系统提供了：

✅ **完整的部署解决方案**
✅ **企业级的安全特性**
✅ **灵活的配置管理**
✅ **自动化运维能力**
✅ **详细的文档支持**

通过这个系统，您可以轻松地将Nuxt 4应用部署到任何支持Docker的云服务器上，实现快速、安全、可靠的部署流程。
