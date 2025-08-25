<template>
  <div class="min-h-screen p-8">
    <div class="max-w-4xl mx-auto">
      <h1 class="text-4xl font-bold mb-8">主题切换测试页面</h1>

      <!-- 当前主题信息 -->
      <div class="mb-8 p-4 bg-gray-100 dark:bg-gray-800 rounded-lg">
        <h2 class="text-xl font-semibold mb-4">当前主题信息</h2>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <p><strong>主题状态:</strong> {{ theme }}</p>
            <p><strong>是否深色:</strong> {{ isDark ? '是' : '否' }}</p>
            <p><strong>颜色模式:</strong> {{ colorMode.value }}</p>
          </div>
          <div>
            <p><strong>主题标签:</strong> {{ currentThemeLabel }}</p>
            <p><strong>主题图标:</strong> {{ currentThemeIcon }}</p>
          </div>
        </div>
      </div>

      <!-- 主题切换按钮 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">主题切换</h2>
        <div class="flex gap-4">
          <UButton @click="toggleTheme" color="primary">
            切换主题 (当前: {{ currentThemeLabel }})
          </UButton>
          <UButton @click="setTheme('light')" color="primary" variant="outline">
            设置为浅色
          </UButton>
          <UButton @click="setTheme('dark')" color="primary" variant="outline">
            设置为深色
          </UButton>
          <UButton
            @click="setTheme('system')"
            color="primary"
            variant="outline"
          >
            设置为系统
          </UButton>
        </div>
      </div>

      <!-- 颜色测试区域 -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <!-- 浅色主题测试 -->
        <div
          class="p-6 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg"
        >
          <h3 class="text-lg font-semibold mb-4">浅色主题测试</h3>
          <div class="space-y-2">
            <p class="text-gray-900 dark:text-white">主要文字颜色</p>
            <p class="text-gray-600 dark:text-gray-300">次要文字颜色</p>
            <p class="text-gray-500 dark:text-gray-400">辅助文字颜色</p>
            <UButton color="primary" size="sm">主要按钮</UButton>
            <UButton color="neutral" variant="outline" size="sm"
              >次要按钮</UButton
            >
          </div>
        </div>

        <!-- 深色主题测试 -->
        <div
          class="p-6 bg-gray-100 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg"
        >
          <h3 class="text-lg font-semibold mb-4">深色主题测试</h3>
          <div class="space-y-2">
            <p class="text-gray-900 dark:text-white">主要文字颜色</p>
            <p class="text-gray-600 dark:text-gray-300">次要文字颜色</p>
            <p class="text-gray-500 dark:text-gray-400">辅助文字颜色</p>
            <UButton color="primary" size="sm">主要按钮</UButton>
            <UButton color="neutral" variant="outline" size="sm"
              >次要按钮</UButton
            >
          </div>
        </div>
      </div>

      <!-- Nuxt UI 组件测试 -->
      <div class="mt-8 p-6 bg-gray-50 dark:bg-gray-800 rounded-lg">
        <h2 class="text-xl font-semibold mb-4">Nuxt UI 组件测试</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <UCard>
            <template #header>
              <h3 class="text-lg font-semibold">卡片标题</h3>
            </template>
            <p>这是一个 Nuxt UI 卡片组件，应该自动适配主题。</p>
            <template #footer>
              <UButton color="primary" size="sm">操作按钮</UButton>
            </template>
          </UCard>

          <UCard>
            <template #header>
              <h3 class="text-lg font-semibold">输入框测试</h3>
            </template>
            <UInput v-model="testInput" placeholder="输入测试文本" />
            <template #footer>
              <UBadge color="primary">标签</UBadge>
            </template>
          </UCard>

          <UCard>
            <template #header>
              <h3 class="text-lg font-semibold">按钮测试</h3>
            </template>
            <div class="space-y-2">
              <UButton color="primary" size="sm" block>主要按钮</UButton>
              <UButton color="neutral" variant="outline" size="sm" block
                >次要按钮</UButton
              >
              <UButton color="error" variant="ghost" size="sm" block
                >危险按钮</UButton
              >
            </div>
          </UCard>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  const {
    theme,
    isDark,
    toggleTheme,
    setTheme,
    currentThemeLabel,
    currentThemeIcon,
    colorMode,
  } = useTheme()

  const testInput = ref('')

  // 设置页面元信息
  useHead({
    title: '主题切换测试',
    meta: [{ name: 'description', content: '测试 Nuxt UI 主题切换功能' }],
  })
</script>
