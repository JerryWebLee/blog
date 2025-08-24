# CI/CD 失败排查指南

## 🚨 当前问题

**CI/CD / Test 任务在 4 秒内失败**，导致后续任务被跳过。

## 🔍 问题分析

### 可能的原因

1. **依赖安装失败**
   - pnpm 安装依赖时出错
   - pnpm-lock.yaml 文件损坏
   - 网络连接问题

2. **脚本执行失败**
   - lint 脚本执行错误
   - type-check 脚本执行错误
   - format:check 脚本执行错误

3. **环境配置问题**
   - Node.js 版本不兼容
   - pnpm 版本问题
   - 缓存配置错误

4. **权限问题**
   - GitHub Token 权限不足
   - 文件权限问题

## 🛠️ 排查步骤

### 1. 查看详细日志

访问 GitHub Actions 页面：

- 点击失败的 "CI/CD / Test" 任务
- 查看具体的错误日志
- 找到失败的具体步骤

### 2. 使用新的测试工作流

我已经创建了三个新的工作流来帮助排查：

#### A. Minimal Test (最小化测试)

- 文件：`.github/workflows/minimal-test.yml`
- 功能：只测试基本的 lint 功能
- 目的：确认基本环境是否正常

#### B. Step by Step Test (逐步测试)

- 文件：`.github/workflows/step-by-step-test.yml`
- 功能：逐步测试每个步骤
- 目的：定位具体失败的步骤

#### C. Debug (调试)

- 文件：`.github/workflows/debug.yml`
- 功能：提供详细的调试信息
- 目的：获取环境状态信息

### 3. 本地测试

在推送前进行本地测试：

```bash
# 测试基本环境
node scripts/diagnose-cicd.js

# 测试依赖安装
pnpm install --frozen-lockfile

# 测试各个脚本
pnpm run lint
pnpm run type-check
pnpm run format:check
pnpm run build
```

## 📋 检查清单

### 环境检查

- [ ] Node.js 版本 >= 20.8.1
- [ ] pnpm 版本最新
- [ ] Git 配置正确

### 文件检查

- [ ] package.json 语法正确
- [ ] pnpm-lock.yaml 文件存在且完整
- [ ] 工作流文件语法正确

### 脚本检查

- [ ] lint 脚本可执行
- [ ] type-check 脚本可执行
- [ ] format:check 脚本可执行
- [ ] build 脚本可执行

### 权限检查

- [ ] GitHub Token 有足够权限
- [ ] 仓库访问权限正确
- [ ] 分支保护规则设置正确

## 🚀 解决方案

### 临时解决方案

如果自动 CI/CD 持续失败，可以：

1. **手动执行检查**：

   ```bash
   pnpm run lint
   pnpm run type-check
   pnpm run format:check
   pnpm run build
   ```

2. **手动发布**：

   ```bash
   pnpm run release
   ```

3. **使用简化工作流**：
   暂时禁用复杂的工作流，使用 `minimal-test.yml`

### 长期解决方案

1. **修复工作流配置**
2. **更新依赖版本**
3. **优化缓存配置**
4. **添加错误处理**

## 📊 监控和告警

### 设置通知

- 配置 GitHub Actions 失败通知
- 设置邮件或 Slack 告警
- 定期检查工作流状态

### 定期维护

- 更新依赖版本
- 检查工作流配置
- 清理缓存和临时文件

## 🔗 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [pnpm 文档](https://pnpm.io/)
- [Nuxt 4 文档](https://nuxt.com/docs)
- [Semantic Release 文档](https://semantic-release.gitbook.io/)

---

_此指南将帮助您快速定位和解决 CI/CD 失败问题。_
