# 快速开始指南

## 🚀 自动化版本发布流程

### 第一步：设置 GitHub Secrets

在 GitHub 仓库设置中添加以下 Secrets：

1. 进入仓库 Settings → Secrets and variables → Actions
2. 添加以下 Secrets：

```bash
# 如果使用 Vercel 部署
VERCEL_TOKEN=your_vercel_token
VERCEL_ORG_ID=your_vercel_org_id
VERCEL_PROJECT_ID=your_vercel_project_id

# 如果需要其他部署平台，添加相应的配置
```

### 第二步：日常开发流程

```bash
# 1. 开发新功能
git checkout -b feature/new-feature

# 2. 编写代码...

# 3. 提交代码（推荐使用交互式提交）
npm run cz

# 4. 推送分支
git push origin feature/new-feature

# 5. 创建 Pull Request 到 main 分支
```

### 第三步：发布新版本

```bash
# 1. 合并到 main 分支
git checkout main
git merge feature/new-feature

# 2. 推送到远程仓库（自动触发发布）
git push origin main
```

### 第四步：查看发布结果

1. **GitHub Actions**: 查看工作流执行状态
2. **GitHub Releases**: 查看新发布的版本
3. **CHANGELOG.md**: 查看更新记录

## 📝 提交信息示例

### 新功能

```bash
npm run cz
# 选择: feat
# 描述: 添加用户登录功能
```

### 修复缺陷

```bash
npm run cz
# 选择: fix
# 描述: 修复登录页面样式问题
```

### 文档更新

```bash
npm run cz
# 选择: docs
# 描述: 更新 API 文档
```

## 🔧 常用命令

```bash
# 交互式提交
npm run cz

# 本地测试发布
npm run release

# 代码检查
npm run lint

# 类型检查
npm run type-check

# 格式化代码
npm run format
```

## 🎯 版本号规则

- **1.0.0** → **1.1.0**: 添加新功能 (`feat`)
- **1.1.0** → **1.1.1**: 修复缺陷 (`fix`)
- **1.1.1** → **2.0.0**: 破坏性更新 (`feat!`)

## 🚨 注意事项

1. **提交信息格式**: 必须符合 Conventional Commits 规范
2. **发布分支**: 只在 `main` 分支上自动发布
3. **权限设置**: 确保 GitHub Token 有足够权限
4. **测试通过**: 发布前确保所有测试通过

## 📚 更多信息

- 详细文档: [RELEASE_WORKFLOW.md](./RELEASE_WORKFLOW.md)
- 项目配置: [nuxt4-development-guidelines.md](./nuxt4-development-guidelines.md)
