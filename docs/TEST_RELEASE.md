# 测试自动发布流程

本文档介绍如何测试您的自动发布流程，确保一切正常工作后再进行真实发布。

## 🧪 测试方法

### 方法一：本地测试（推荐）

#### 1. 运行完整测试脚本

```bash
# 运行完整的测试流程
npm run test:release
```

这个脚本会：

- ✅ 检查当前版本和提交历史
- ✅ 运行代码检查（ESLint、TypeScript、Prettier）
- ✅ 测试构建过程
- ✅ 模拟发布流程（dry-run）
- ✅ 分析发布内容

#### 2. 手动测试各个步骤

```bash
# 1. 检查代码质量
npm run lint
npm run type-check
npm run format:check

# 2. 测试构建
npm run build

# 3. 模拟发布（不会真正发布）
npm run release -- --dry-run

# 4. 查看发布分析
npx semantic-release --dry-run --debug
```

### 方法二：GitHub Actions 测试

#### 1. 创建测试分支

```bash
# 创建测试分支
git checkout -b test/release-workflow

# 做一些测试修改
echo "# 测试修改" >> README.md

# 提交测试代码
npm run cz
# 选择: feat
# 描述: 测试自动发布流程

# 推送到测试分支
git push origin test/release-workflow
```

#### 2. 合并到 main 分支测试

```bash
# 切换到 main 分支
git checkout main

# 合并测试分支
git merge test/release-workflow

# 推送到远程（这会触发 GitHub Actions）
git push origin main
```

#### 3. 查看 GitHub Actions 结果

1. 进入 GitHub 仓库
2. 点击 "Actions" 标签
3. 查看 "Test Release" 工作流执行结果

## 📋 测试检查清单

### 提交前检查

- [ ] 代码符合 ESLint 规范
- [ ] TypeScript 类型检查通过
- [ ] 代码格式符合 Prettier 规范
- [ ] 提交信息符合 Conventional Commits 规范

### 构建检查

- [ ] 项目能够正常构建
- [ ] 没有构建错误或警告
- [ ] 构建产物正确生成

### 发布检查

- [ ] Semantic Release 能够正确分析提交
- [ ] 版本号计算正确
- [ ] CHANGELOG 生成正确
- [ ] 发布说明生成正确

## 🎯 测试场景

### 场景一：新功能发布

```bash
# 1. 创建新功能
git checkout -b feature/test-feature

# 2. 添加一些代码
echo "// 测试新功能" >> app/test.js

# 3. 提交新功能
npm run cz
# 选择: feat
# 描述: 添加测试功能

# 4. 合并到 main 并推送
git checkout main
git merge feature/test-feature
git push origin main
```

**预期结果**：

- 版本号从 `1.0.0` 升级到 `1.1.0`
- CHANGELOG 中添加新功能记录
- 创建 Git 标签 `v1.1.0`

### 场景二：修复缺陷

```bash
# 1. 创建修复分支
git checkout -b fix/test-bug

# 2. 修复代码
echo "// 修复测试缺陷" >> app/test.js

# 3. 提交修复
npm run cz
# 选择: fix
# 描述: 修复测试缺陷

# 4. 合并到 main 并推送
git checkout main
git merge fix/test-bug
git push origin main
```

**预期结果**：

- 版本号从 `1.1.0` 升级到 `1.1.1`
- CHANGELOG 中添加修复记录
- 创建 Git 标签 `v1.1.1`

### 场景三：文档更新

```bash
# 1. 更新文档
echo "# 更新文档" >> docs/test.md

# 2. 提交文档更新
npm run cz
# 选择: docs
# 描述: 更新测试文档

# 3. 合并到 main 并推送
git checkout main
git merge docs/test-docs
git push origin main
```

**预期结果**：

- 版本号从 `1.1.1` 升级到 `1.1.2`
- CHANGELOG 中添加文档更新记录
- 创建 Git 标签 `v1.1.2`

## 🚨 常见问题

### 问题一：发布失败

**症状**：GitHub Actions 中的发布步骤失败

**解决方案**：

1. 检查提交信息格式是否正确
2. 确保在 main 分支上推送
3. 检查 GitHub Token 权限

### 问题二：版本号不更新

**症状**：推送代码后版本号没有变化

**解决方案**：

1. 检查提交信息是否包含有效的类型（feat、fix 等）
2. 确保提交信息格式正确
3. 检查是否有新的提交

### 问题三：CHANGELOG 不更新

**症状**：CHANGELOG.md 文件没有更新

**解决方案**：

1. 检查 `.releaserc.js` 配置
2. 确保 `@semantic-release/changelog` 插件正确配置
3. 检查文件权限

## 📊 测试结果验证

### 成功指标

- ✅ GitHub Actions 工作流执行成功
- ✅ 版本号正确递增
- ✅ CHANGELOG.md 正确更新
- ✅ Git 标签正确创建
- ✅ GitHub Release 正确创建

### 验证命令

```bash
# 查看当前版本
node -p "require('./package.json').version"

# 查看 Git 标签
git tag -l

# 查看 CHANGELOG
cat CHANGELOG.md

# 查看最近提交
git log --oneline -5
```

## 🔄 回滚测试

如果测试出现问题，可以回滚：

```bash
# 删除本地标签
git tag -d v1.1.0

# 删除远程标签
git push origin :refs/tags/v1.1.0

# 重置到上一个提交
git reset --hard HEAD~1

# 强制推送（谨慎使用）
git push origin main --force
```

## 📝 下一步

测试成功后，您可以：

1. **正式发布**：使用真实的提交进行发布
2. **配置部署**：添加自动部署到生产环境
3. **监控发布**：设置发布通知和监控

记住：测试时使用 `--dry-run` 参数，确保不会意外创建真实的发布！
