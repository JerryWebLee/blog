#!/usr/bin/env node

import { execSync } from 'child_process'
import { readFileSync } from 'fs'

console.log('🚀 开始测试自动发布流程...\n')

// 1. 检查当前状态
console.log('📋 1. 检查当前状态')
try {
  const packageJson = JSON.parse(readFileSync('package.json', 'utf8'))
  console.log(`   当前版本: ${packageJson.version}`)

  const recentCommits = execSync('git log --oneline -5', { encoding: 'utf8' })
  console.log('   最近提交:')
  console.log(
    recentCommits
      .split('\n')
      .slice(0, -1)
      .map(line => `   ${line}`)
      .join('\n')
  )
} catch (error) {
  console.error('❌ 检查状态失败:', error.message)
  process.exit(1)
}

// 2. 运行代码检查
console.log('\n🔍 2. 运行代码检查')
try {
  console.log('   运行 ESLint...')
  execSync('npm run lint', { stdio: 'inherit' })

  console.log('   运行 TypeScript 检查...')
  execSync('npm run type-check', { stdio: 'inherit' })

  console.log('   检查代码格式...')
  execSync('npm run format:check', { stdio: 'inherit' })

  console.log('✅ 代码检查通过')
} catch (error) {
  console.error('❌ 代码检查失败:', error.message)
  process.exit(1)
}

// 3. 测试构建
console.log('\n🏗️ 3. 测试构建')
try {
  console.log('   运行构建...')
  execSync('npm run build', { stdio: 'inherit' })
  console.log('✅ 构建成功')
} catch (error) {
  console.error('❌ 构建失败:', error.message)
  process.exit(1)
}

// 4. 模拟发布流程
console.log('\n📦 4. 模拟发布流程')
try {
  console.log('   运行 dry-run 发布...')
  execSync('npm run release -- --dry-run', { stdio: 'inherit' })
  console.log('✅ 发布流程测试通过')
} catch (error) {
  console.error('❌ 发布流程测试失败:', error.message)
  process.exit(1)
}

// 5. 分析发布内容
console.log('\n📊 5. 分析发布内容')
try {
  const analysis = execSync('npx semantic-release --dry-run --debug', {
    encoding: 'utf8',
  })
  console.log('   发布分析结果:')
  console.log(analysis)
} catch {
  console.log('⚠️ 无法获取详细分析，但发布流程正常')
}

console.log('\n🎉 测试完成！')
console.log('\n📝 下一步:')
console.log('1. 如果所有测试都通过，可以推送到 main 分支进行真实发布')
console.log('2. 使用 "npm run cz" 进行规范的提交')
console.log('3. 推送到远程仓库: git push origin main')
console.log('\n⚠️ 注意: 真实发布会创建 Git 标签和 GitHub Release')
