# 自动化版本发布流程

本项目使用 Semantic Release 实现自动化版本发布，结合 GitHub Actions 实现完整的 CI/CD 流程。

## 工作流程概览

```mermaid
graph LR
    A[开发代码] --> B[提交代码]
    B --> C[GitHub Actions CI]
    C --> D[测试通过]
    D --> E[构建成功]
    E --> F[自动发布]
    F --> G[创建 Git Tag]
    G --> H[生成 Release]
    H --> I[更新 CHANGELOG]
    I --> J[自动部署]
```

## 提交规范

### 提交类型

| 类型       | 说明     | 版本影响 |
| ---------- | -------- | -------- |
| `feat`     | 新功能   | minor    |
| `fix`      | 修复缺陷 | patch    |
| `docs`     | 文档更新 | patch    |
| `style`    | 代码格式 | patch    |
| `refactor` | 代码重构 | patch    |
| `perf`     | 性能提升 | patch    |
| `test`     | 测试相关 | patch    |
| `build`    | 构建相关 | patch    |
| `ci`       | CI 配置  | patch    |
| `chore`    | 其他修改 | patch    |
| `revert`   | 回退代码 | patch    |

### 提交格式

```bash
type(scope): subject

body

footer
```

### 示例

```bash
# 新功能
feat(auth): 添加用户登录功能

# 修复缺陷
fix(api): 修复用户列表接口返回错误

# 文档更新
docs(readme): 更新项目说明文档

# 重大变更（破坏性更新）
feat(api)!: 重构用户 API 接口

BREAKING CHANGE: 用户 API 接口已重构，请查看迁移指南
```

## 使用方法

### 1. 日常开发

```bash
# 使用交互式提交（推荐）
npm run cz

# 或直接使用 git commit（需要符合规范）
git commit -m "feat: 添加新功能"
```

### 2. 发布新版本

#### 自动发布（推荐）

```bash
# 推送到 main 分支，GitHub Actions 会自动触发发布
git push origin main
```

#### 手动发布（本地测试）

```bash
# 本地测试发布流程
npm run release

# 完整流程：提交 + 发布
npm run cz:release
```

### 3. 查看发布历史

- **GitHub Releases**: 查看所有发布版本
- **CHANGELOG.md**: 查看详细的更新记录
- **Git Tags**: 查看版本标签

## GitHub Actions 工作流

### CI/CD 流程

1. **测试阶段** (`test`)
   - 代码检查 (ESLint)
   - 类型检查 (TypeScript)
   - 格式检查 (Prettier)

2. **构建阶段** (`build`)
   - 项目构建
   - 生成构建产物

3. **发布阶段** (`release`)
   - 仅在 main 分支推送时触发
   - 自动版本号管理
   - 生成 CHANGELOG
   - 创建 Git 标签
   - 发布到 GitHub Releases

4. **部署阶段** (`deploy`)
   - 在发布新版本时触发
   - 自动部署到生产环境

## 配置说明

### Semantic Release 配置

配置文件：`.releaserc.js`

```javascript
export default {
  branches: ['main'], // 发布分支
  plugins: [
    '@semantic-release/commit-analyzer', // 分析提交信息
    '@semantic-release/changelog', // 生成更新日志
    '@semantic-release/release-notes-generator', // 生成发布说明
    '@semantic-release/npm', // 更新 package.json
    '@semantic-release/git', // 提交到 Git
  ],
}
```

### Commitlint 配置

配置文件：`commitlint.config.js`

- 验证提交信息格式
- 支持自定义提交类型
- 支持中文提示

### Husky 配置

- `pre-commit`: 提交前运行 lint-staged
- `commit-msg`: 验证提交信息格式

## 版本号规则

基于 [Semantic Versioning](https://semver.org/) 规范：

- **MAJOR**: 破坏性更新 (`feat!`, `fix!`)
- **MINOR**: 新功能 (`feat`)
- **PATCH**: 修复和优化 (`fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`)

## 最佳实践

### 1. 提交信息

- 使用清晰、简洁的描述
- 包含必要的上下文信息
- 对于重大变更，使用 `!` 标记

### 2. 分支管理

- 使用 `main` 分支作为发布分支
- 使用 `develop` 分支进行开发
- 使用功能分支进行功能开发

### 3. 发布流程

- 确保所有测试通过
- 确保代码审查完成
- 使用语义化提交信息

### 4. 回滚策略

- 使用 `revert` 类型提交回滚代码
- 创建新的发布版本而不是删除现有版本

## 故障排除

### 常见问题

1. **提交信息格式错误**

   ```bash
   # 使用交互式提交
   npm run cz
   ```

2. **发布失败**
   - 检查 GitHub Token 权限
   - 确保在正确的分支上发布
   - 检查提交信息格式

3. **版本号冲突**
   - 检查是否有重复的 Git 标签
   - 清理本地和远程标签

### 调试命令

```bash
# 本地测试发布流程
npm run release -- --dry-run

# 查看提交历史
git log --oneline

# 查看标签
git tag -l
```

## 相关文档

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Actions](https://docs.github.com/en/actions)
