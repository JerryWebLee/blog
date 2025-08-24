#!/usr/bin/env node

import { execSync } from 'child_process'
import { readFileSync, existsSync } from 'fs'

console.log('🔍 CI/CD 诊断工具\n')

// 1. 检查基本环境
console.log('📋 1. 基本环境检查')
try {
  const nodeVersion = execSync('node --version', { encoding: 'utf8' }).trim()
  console.log(`   Node.js 版本: ${nodeVersion}`)

  const pnpmVersion = execSync('pnpm --version', { encoding: 'utf8' }).trim()
  console.log(`   pnpm 版本: ${pnpmVersion}`)

  const gitVersion = execSync('git --version', { encoding: 'utf8' }).trim()
  console.log(`   Git 版本: ${gitVersion}`)
} catch (error) {
  console.error('❌ 环境检查失败:', error.message)
}

// 2. 检查项目配置
console.log('\n📦 2. 项目配置检查')
try {
  const packageJson = JSON.parse(readFileSync('package.json', 'utf8'))
  console.log(`   项目名称: ${packageJson.name}`)
  console.log(`   当前版本: ${packageJson.version}`)
  console.log(`   包管理器: pnpm`)

  // 检查关键脚本
  const requiredScripts = [
    'build',
    'lint',
    'type-check',
    'format:check',
    'release',
  ]
  console.log('   脚本检查:')
  requiredScripts.forEach(script => {
    if (packageJson.scripts[script]) {
      console.log(`     ✅ ${script}: ${packageJson.scripts[script]}`)
    } else {
      console.log(`     ❌ ${script}: 缺失`)
    }
  })
} catch (error) {
  console.error('❌ 项目配置检查失败:', error.message)
}

// 3. 检查工作流文件
console.log('\n⚙️ 3. 工作流文件检查')
const workflowFiles = [
  '.github/workflows/ci.yml',
  '.github/workflows/test-release.yml',
  '.github/workflows/simple-test.yml',
]

workflowFiles.forEach(file => {
  if (existsSync(file)) {
    console.log(`   ✅ ${file}: 存在`)
  } else {
    console.log(`   ❌ ${file}: 缺失`)
  }
})

// 4. 检查依赖文件
console.log('\n📚 4. 依赖文件检查')
const dependencyFiles = ['package.json', 'pnpm-lock.yaml', 'nuxt.config.ts']

dependencyFiles.forEach(file => {
  if (existsSync(file)) {
    console.log(`   ✅ ${file}: 存在`)
  } else {
    console.log(`   ❌ ${file}: 缺失`)
  }
})

// 5. 测试基本命令
console.log('\n🧪 5. 基本命令测试')
const commands = [
  { name: 'pnpm install', cmd: 'pnpm install --dry-run' },
  { name: 'pnpm run lint', cmd: 'pnpm run lint --help' },
  { name: 'pnpm run type-check', cmd: 'pnpm run type-check --help' },
  { name: 'pnpm run build', cmd: 'pnpm run build --help' },
]

commands.forEach(({ name, cmd }) => {
  try {
    execSync(cmd, { stdio: 'pipe' })
    console.log(`   ✅ ${name}: 可用`)
  } catch {
    console.log(`   ⚠️ ${name}: 需要实际测试`)
  }
})

// 6. 检查 Git 状态
console.log('\n🌐 6. Git 状态检查')
try {
  const currentBranch = execSync('git branch --show-current', {
    encoding: 'utf8',
  }).trim()
  console.log(`   当前分支: ${currentBranch}`)

  const remoteUrl = execSync('git remote get-url origin', {
    encoding: 'utf8',
  }).trim()
  console.log(`   远程仓库: ${remoteUrl}`)

  const lastCommit = execSync('git log -1 --oneline', {
    encoding: 'utf8',
  }).trim()
  console.log(`   最新提交: ${lastCommit}`)
} catch (error) {
  console.error('❌ Git 状态检查失败:', error.message)
}

// 7. 检查环境变量
console.log('\n🔧 7. 环境变量检查')
const envVars = ['NODE_ENV', 'GITHUB_TOKEN', 'CI']
envVars.forEach(envVar => {
  const value = process.env[envVar]
  if (value) {
    console.log(`   ${envVar}: ${envVar === 'GITHUB_TOKEN' ? '***' : value}`)
  } else {
    console.log(`   ${envVar}: 未设置`)
  }
})

console.log('\n📊 诊断完成！')
console.log('\n💡 建议:')
console.log('1. 如果所有检查都通过，问题可能在 GitHub Actions 环境')
console.log('2. 检查 GitHub Actions 日志获取详细错误信息')
console.log('3. 确保工作流文件语法正确')
console.log('4. 验证 GitHub Token 权限设置')
