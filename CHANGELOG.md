# 版本更新记录

> 本文档由系统自动生成

# [1.1.0](https://github.com/JerryWebLee/blog/compare/v1.0.0...v1.1.0) (2025-08-25)

### ⚡ 性能提升

- 添加CI/CD工作流实现自动化测试构建和发布部署流程 ([12b85ebe](https://github.com/JerryWebLee/blog/commit/12b85ebe169a307e6edc0bfb484c1d958de91e8d))

### ✨ 新增功能

- 将 CI/CD 工作流从 npm 迁移到 pnpm 以提升依赖管理效率 ([5a7c63ef](https://github.com/JerryWebLee/blog/commit/5a7c63ef3832fcfb0f1d130fe4a6b9a7743d8812))
- 添加简单测试工作流并修复包管理器配置问题 ([8e1d96eb](https://github.com/JerryWebLee/blog/commit/8e1d96ebd0c2faa23fd2b28b4f4877e5ccbe9933))
- 添加深色主题博客项目文档，包含设计指南、技术栈说明和功能特性 ([4e12db80](https://github.com/JerryWebLee/blog/commit/4e12db80ca341fdebc047522f49ed5bf46697733))
- 添加自动发布流程演示文档以测试Semantic Release功能 ([8b77e6b5](https://github.com/JerryWebLee/blog/commit/8b77e6b5bfc6f803c4f19d2d22ccfc911fec30f0))
- 添加GitHub连接问题排查指南文档 ([07942cf1](https://github.com/JerryWebLee/blog/commit/07942cf1cef9aceaa19b8aa8b432f4a3ef3003e9))

### 🔧 持续集成

- 创建简化发布工作流，跳过测试步骤 ([3a9e3d44](https://github.com/JerryWebLee/blog/commit/3a9e3d4417f398e6efcb98c9edf73ee201a7a80f))
- 添加调试工作流来排查 CI/CD 问题 ([e7771dbd](https://github.com/JerryWebLee/blog/commit/e7771dbd60ede79ff82d7cfea5a5bf960e2f27c6))
- 添加逐步测试工作流来定位 CI/CD 失败原因 ([d7c3952e](https://github.com/JerryWebLee/blog/commit/d7c3952e90a862c7ea9bce636445838dfcdbca00))

### 🧪 测试相关

- 删除所有 GitHub Actions 工作流文件以简化项目结构 ([d647c5c6](https://github.com/JerryWebLee/blog/commit/d647c5c64e224b4fca56a3f1acfaf96b4abc8688))

### 🧹 其他修改

- 删除微信图片\_20250824165652_1.jpg 二进制文件 ([057cd967](https://github.com/JerryWebLee/blog/commit/057cd967943edcfbc729c8305e042e2a8f594f8d))

# 1.0.0 (2025-08-24)

### ⚡ 性能提升

- 标准化配置文件和组件代码格式，统一使用单引号并修复缩进 ([98965f69](https://github.com/JerryWebLee/blog/commit/98965f6982641966d64863f1b5c9a951d975d85c))

### ✨ 新增功能

- 初始化 Husky 配置 ([8fa22df7](https://github.com/JerryWebLee/blog/commit/8fa22df7dbda4e0fec4057ab0624d90a82c17c3d))
- 添加 Prettier 配置到 lint-staged ([69f29022](https://github.com/JerryWebLee/blog/commit/69f29022d4d5cba428570615e87f2606dc4dbe8d))

### 🐛 修复缺陷

- 解决 ESLint 和 Prettier 冲突 ([49d91dc2](https://github.com/JerryWebLee/blog/commit/49d91dc28cd03b86fa7138c88c2dd3925dda8f17))

### 📚 文档更新

- 更新 Husky 文档并添加 Prettier 配置说明 ([52bda130](https://github.com/JerryWebLee/blog/commit/52bda130b88240c92c3c8ee090360e9ac89266bc))
- 更新 Prettier 配置文档，说明 ESLint 冲突解决方案 ([066acd58](https://github.com/JerryWebLee/blog/commit/066acd58ff52289dcf10004e928582e51c6b1f1f))
- 添加 Husky 配置说明文档 ([db5ba797](https://github.com/JerryWebLee/blog/commit/db5ba79712b32c1dd270d5acfe57d1b51b39bcc7))

### 🧹 其他修改

- 重构并扩展 commitlint 配置以支持交互式提交提示和多范围选择 ([caed0f71](https://github.com/JerryWebLee/blog/commit/caed0f7140bd5d99c15fa3132a5e7585b7c494a1))
