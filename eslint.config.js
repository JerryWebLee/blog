import js from '@eslint/js'
import globals from 'globals'
import prettier from 'eslint-config-prettier'

export default [
  // 基础 JavaScript 规则
  js.configs.recommended,

  // 全局配置
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2021,
      },
    },
    rules: {
      'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
      'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
      'prefer-const': 'error',
      'no-var': 'error',
      'object-shorthand': 'error',
      'prefer-template': 'error',
    },
  },

  // 禁用与 Prettier 冲突的规则
  prettier,

  // 忽略文件
  {
    ignores: [
      '.nuxt/**',
      'node_modules/**',
      'dist/**',
      '.output/**',
      '*.config.js',
      '*.config.ts',
    ],
  },
]
