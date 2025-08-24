# CI/CD 问题排查指南

## 问题描述

GitHub Actions 工作流失败，错误信息："Test 此检查没有步骤"

## 问题原因

工作流配置中使用了错误的包管理器：

- 项目使用 `pnpm` 作为包管理器
- 工作流配置中使用了 `npm` 命令
- 导致依赖安装失败，工作流无法执行

## 解决方案

### 1. 修复包管理器配置

将所有工作流文件中的 `npm` 命令替换为 `pnpm`：

#### 修复前

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'

- name: Install dependencies
  run: npm ci

- name: Lint
  run: npm run lint
```

#### 修复后

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'pnpm'

- name: Setup pnpm
  uses: pnpm/action-setup@v4
  with:
    version: latest

- name: Install dependencies
  run: pnpm install --frozen-lockfile

- name: Lint
  run: pnpm run lint
```

### 2. 修复的工作流文件

- ✅ `.github/workflows/ci.yml`
- ✅ `.github/workflows/test-release.yml`
- ✅ `.github/workflows/deploy.yml`

### 3. 关键修改点

1. **缓存配置**：`cache: 'npm'` → `cache: 'pnpm'`
2. **添加 pnpm 设置步骤**：使用 `pnpm/action-setup@v4`
3. **安装命令**：`npm ci` → `pnpm install --frozen-lockfile`
4. **脚本命令**：`npm run` → `pnpm run`

## 验证修复

### 1. 检查工作流状态

- 访问 GitHub Actions: https://github.com/JerryWebLee/blog/actions
- 查看最新的工作流执行状态

### 2. 本地测试

```bash
# 测试构建
pnpm run build

# 测试代码检查
pnpm run lint
pnpm run type-check
pnpm run format:check

# 测试发布流程
pnpm run release -- --dry-run
```

## 预防措施

### 1. 统一包管理器

- 确保项目配置文件中使用一致的包管理器
- 在 README 中明确说明使用的包管理器

### 2. 工作流模板

- 创建标准的工作流模板
- 在模板中正确配置包管理器

### 3. 本地测试

- 在推送前本地测试工作流步骤
- 使用 `act` 工具本地运行 GitHub Actions

## 常见问题

### Q: 为什么会出现包管理器不匹配？

A: 通常是因为：

- 项目从 npm 迁移到 pnpm 时没有更新工作流
- 复制了其他项目的配置但没有适配
- 手动编辑时遗漏了某些步骤

### Q: 如何确保工作流配置正确？

A:

1. 检查 `package.json` 中的包管理器配置
2. 确认 `pnpm-lock.yaml` 文件存在
3. 验证工作流中的包管理器设置
4. 本地测试所有工作流步骤

### Q: 如果还有其他包管理器问题怎么办？

A:

1. 检查 `package.json` 中的 scripts 配置
2. 确认所有依赖都正确安装
3. 查看工作流执行日志获取详细错误信息
4. 参考官方文档进行配置

## 相关文档

- [pnpm GitHub Action](https://github.com/pnpm/action-setup)
- [GitHub Actions 缓存](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)
- [Nuxt 4 部署指南](https://nuxt.com/docs/getting-started/deployment)

---

_此文档记录了 CI/CD 工作流配置问题的排查和解决方案。_
