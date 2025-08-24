# Husky 配置说明

## 概述

本项目已配置 Husky 来管理 Git hooks，确保代码质量和提交规范。

## 配置内容

### 1. Pre-commit Hook

在每次提交前自动运行以下检查：

- **ESLint 检查**: 对 staged 文件进行代码质量检查
- **自动修复**: 自动修复可修复的 ESLint 错误
- **Prettier 格式化**: 自动格式化代码风格

### 2. Commit-msg Hook

验证提交信息格式，确保符合 Conventional Commits 规范。

## 支持的提交类型

- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动
- `ci`: CI/CD 相关
- `build`: 构建相关
- `revert`: 回滚

## 提交信息格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 示例

```bash
# 正确的提交信息
git commit -m "feat: 添加用户登录功能"
git commit -m "fix(auth): 修复登录验证bug"
git commit -m "docs: 更新API文档"

# 错误的提交信息（会被拒绝）
git commit -m "update code"
git commit -m "fix bug"
```

## 文件结构

```
.husky/
├── pre-commit          # 提交前检查
├── commit-msg          # 提交信息验证
└── _/                  # Husky 内部文件
```

## 配置文件

- `commitlint.config.js`: Commitlint 配置
- `package.json`: lint-staged 配置
- `.prettierrc`: Prettier 格式化配置
- `.prettierignore`: Prettier 忽略文件配置

## 工作流程

1. 修改代码
2. 暂存文件: `git add .`
3. 提交代码: `git commit -m "type: description"`
4. Husky 自动运行检查:
   - Pre-commit: ESLint 检查和 Prettier 格式化
   - Commit-msg: 提交信息格式验证

## 故障排除

### 跳过 Hooks

在特殊情况下，可以跳过 hooks：

```bash
git commit -m "message" --no-verify
```

### 手动运行检查

```bash
# 运行 ESLint
npm run lint

# 运行 Prettier 格式化
npm run format

# 检查 Prettier 格式
npm run format:check

# 运行 lint-staged
npx lint-staged
```

## 注意事项

1. 确保所有团队成员都安装了依赖: `pnpm install`
2. 不要删除 `.husky` 目录
3. 提交信息必须符合规范，否则会被拒绝
4. 代码必须通过 ESLint 检查和 Prettier 格式化才能提交
