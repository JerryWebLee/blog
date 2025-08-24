#!/usr/bin/env node

import { execSync } from 'child_process'
import { readFileSync } from 'fs'

console.log('🔍 检查发布状态...\n')

// 1. 检查当前版本
try {
  const packageJson = JSON.parse(readFileSync('package.json', 'utf8'))
  console.log(`📦 当前版本: ${packageJson.version}`)
} catch {
  console.error('❌ 无法读取 package.json')
}

// 2. 检查 Git 标签
try {
  const tags = execSync('git tag -l', { encoding: 'utf8' }).trim()
  console.log(`🏷️  Git 标签: ${tags || '无'}`)
} catch {
  console.error('❌ 无法获取 Git 标签')
}

// 3. 检查最近提交
try {
  const recentCommits = execSync('git log --oneline -3', { encoding: 'utf8' })
  console.log('📝 最近提交:')
  console.log(
    recentCommits
      .split('\n')
      .slice(0, -1)
      .map(line => `   ${line}`)
      .join('\n')
  )
} catch {
  console.error('❌ 无法获取提交历史')
}

// 4. 检查 CHANGELOG
try {
  const changelog = readFileSync('CHANGELOG.md', 'utf8')
  const lines = changelog.split('\n')
  const versionLines = lines.filter(line => line.startsWith('## ['))
  console.log('\n📋 CHANGELOG 版本记录:')
  versionLines.slice(0, 3).forEach(line => console.log(`   ${line}`))
} catch {
  console.error('❌ 无法读取 CHANGELOG.md')
}

// 5. 检查远程仓库状态
try {
  const remoteStatus = execSync('git remote -v', { encoding: 'utf8' })
  console.log('\n🌐 远程仓库配置:')
  console.log(
    remoteStatus
      .split('\n')
      .slice(0, -1)
      .map(line => `   ${line}`)
      .join('\n')
  )
} catch {
  console.error('❌ 无法获取远程仓库信息')
}

console.log('\n📊 发布状态分析:')
console.log('1. 如果版本号没有更新，说明 GitHub Actions 可能还在运行')
console.log('2. 如果版本号已更新，说明发布成功')
console.log(
  '3. 检查 GitHub Actions: https://github.com/JerryWebLee/blog/actions'
)
console.log(
  '4. 检查 GitHub Releases: https://github.com/JerryWebLee/blog/releases'
)
