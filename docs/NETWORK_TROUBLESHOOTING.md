# GitHub 连接问题排查指南

## 问题描述

在推送代码到 GitHub 时遇到连接问题：

```bash
fatal: unable to access 'https://github.com/JerryWebLee/blog.git/': Failed to connect to github.com port 443 after 8080 ms: Couldn't connect to server
```

## 解决方案

### 1. 切换到 SSH 连接（推荐）

```bash
# 查看当前远程仓库配置
git remote -v

# 切换到 SSH 连接
git remote set-url origin git@github.com:JerryWebLee/blog.git

# 验证配置
git remote -v

# 推送代码
git push origin main
```

### 2. 配置 Git 网络参数

```bash
# 增加缓冲区大小
git config --global http.postBuffer 524288000

# 设置低速限制
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999

# 禁用 SSL 验证（如果网络环境需要）
git config --global http.sslverify false
```

### 3. 使用代理（如果需要）

```bash
# 设置 HTTP 代理
git config --global http.proxy http://proxy-server:port

# 设置 HTTPS 代理
git config --global https.proxy https://proxy-server:port

# 取消代理设置
git config --global --unset http.proxy
git config --global --unset https.proxy
```

### 4. 检查网络连接

```bash
# 测试网络连接
ping github.com

# 测试 SSH 连接
ssh -T git@github.com

# 测试 HTTPS 连接
curl -I https://github.com
```

## 预防措施

1. **使用 SSH 密钥认证**：比 HTTPS 更稳定
2. **配置 Git 全局设置**：优化网络参数
3. **定期更新 Git**：使用最新版本
4. **网络环境优化**：确保网络稳定性

## 常见问题

### Q: SSH 连接失败怎么办？

A: 检查 SSH 密钥是否正确配置：

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-add ~/.ssh/id_ed25519
```

### Q: 代理设置后仍然失败？

A: 尝试使用不同的代理服务器或直接连接

### Q: 公司网络限制怎么办？

A: 联系网络管理员或使用 VPN

---

_此文档记录了解决 GitHub 连接问题的经验和方法。_
