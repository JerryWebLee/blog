# Prettier 配置说明

## 概述

本项目已配置 Prettier 来自动格式化代码，确保代码风格的一致性。

## 配置文件

### `.prettierrc`

主要的 Prettier 配置文件，包含以下设置：

```json
{
  "semi": false, // 不使用分号
  "singleQuote": true, // 使用单引号
  "tabWidth": 2, // 缩进宽度为 2 个空格
  "trailingComma": "es5", // 在 ES5 兼容的地方使用尾随逗号
  "printWidth": 80, // 行宽限制为 80 字符
  "bracketSpacing": true, // 对象字面量中的括号前后有空格
  "arrowParens": "avoid", // 箭头函数单参数时不使用括号
  "endOfLine": "lf", // 使用 LF 换行符
  "vueIndentScriptAndStyle": true, // Vue 文件中的 script 和 style 标签内容缩进
  "htmlWhitespaceSensitivity": "css", // HTML 空白符敏感度
  "embeddedLanguageFormatting": "auto" // 自动格式化嵌入的语言
}
```

### `.prettierignore`

指定不需要 Prettier 格式化的文件和目录：

- 依赖目录 (`node_modules/`, `.pnpm-store/`)
- 构建输出 (`dist/`, `.nuxt/`, `.output/`)
- 锁文件 (`pnpm-lock.yaml`, `package-lock.json`)
- 环境文件 (`.env*`)
- IDE 文件 (`.vscode/`, `.idea/`)
- 系统文件 (`.DS_Store`, `Thumbs.db`)
- 日志文件 (`*.log`)
- 缓存目录

## 集成配置

### lint-staged 配置

在 `package.json` 中的 lint-staged 配置：

```json
{
  "lint-staged": {
    "app/**/*.{js,jsx,ts,tsx,vue}": ["eslint --fix", "prettier --write"],
    "server/**/*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],
    "utils/**/*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],
    "scripts/**/*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],
    "**/*.{md,json,yml,yaml,css,scss,less}": ["prettier --write"]
  }
}
```

### 脚本命令

在 `package.json` 中添加的脚本：

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

## 使用方法

### 手动格式化

```bash
# 格式化所有文件
npm run format

# 检查格式化状态（不修改文件）
npm run format:check

# 格式化特定文件
npx prettier --write path/to/file.js

# 检查特定文件格式
npx prettier --check path/to/file.js
```

### 自动格式化

通过 Git hooks 自动格式化：

1. 修改代码
2. 暂存文件: `git add .`
3. 提交代码: `git commit -m "message"`
4. Pre-commit hook 自动运行 Prettier 格式化

### IDE 集成

#### VS Code

1. 安装 Prettier 扩展
2. 在设置中启用 "Format On Save"
3. 设置 Prettier 为默认格式化工具

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

#### WebStorm

1. 在设置中启用 Prettier
2. 配置 "Format on Save"

## 支持的文件类型

- JavaScript/TypeScript (`.js`, `.jsx`, `.ts`, `.tsx`)
- Vue (`.vue`)
- JSON (`.json`)
- Markdown (`.md`)
- YAML (`.yml`, `.yaml`)
- CSS/SCSS/Less (`.css`, `.scss`, `.less`)
- HTML (`.html`)

## 与 ESLint 的协作

Prettier 和 ESLint 可以很好地协作：

1. **Prettier**: 负责代码格式化（空格、换行、引号等）
2. **ESLint**: 负责代码质量检查（未使用的变量、潜在错误等）

在 lint-staged 中，ESLint 先运行修复代码质量问题，然后 Prettier 运行格式化代码风格。

### 冲突解决

项目已安装 `eslint-config-prettier` 来自动禁用与 Prettier 冲突的 ESLint 规则：

```javascript
// eslint.config.js
import prettier from 'eslint-config-prettier'

export default [
  // ... 其他配置
  prettier, // 禁用与 Prettier 冲突的规则
  // ... 其他配置
]
```

## 故障排除

### 格式化冲突

如果 Prettier 和 ESLint 规则冲突：

1. ✅ 已安装 `eslint-config-prettier` 并配置在 ESLint 中
2. 确保 Prettier 配置与项目风格一致
3. 检查 ESLint 配置中是否还有其他格式化规则

### 忽略特定代码

在代码中使用注释忽略 Prettier 格式化：

```javascript
// prettier-ignore
const uglyCode = {
  a: 1,
  b: 2
};
```

### 自定义配置

如需修改格式化规则，编辑 `.prettierrc` 文件：

```json
{
  "semi": true, // 使用分号
  "singleQuote": false, // 使用双引号
  "printWidth": 100 // 增加行宽
}
```

## 最佳实践

1. **团队统一**: 确保所有团队成员使用相同的 Prettier 配置
2. **版本控制**: 将 `.prettierrc` 和 `.prettierignore` 提交到版本控制
3. **CI/CD**: 在持续集成中运行 `prettier --check`
4. **IDE 集成**: 配置编辑器自动格式化
5. **定期检查**: 定期运行 `npm run format:check` 确保代码风格一致
