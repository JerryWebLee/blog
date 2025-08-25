<template>
  <div class="min-h-screen p-8">
    <div class="max-w-2xl mx-auto">
      <h1 class="text-3xl font-bold mb-8">简单主题测试</h1>

      <!-- 当前状态 -->
      <div class="mb-8 p-4 bg-gray-100 dark:bg-gray-800 rounded-lg">
        <h2 class="text-xl font-semibold mb-4">当前状态</h2>
        <p><strong>颜色模式值:</strong> {{ colorMode.value }}</p>
        <p><strong>颜色模式偏好:</strong> {{ colorMode.preference }}</p>
        <p><strong>是否深色:</strong> {{ isDark ? '是' : '否' }}</p>
      </div>

      <!-- 主题切换按钮 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">主题切换</h2>
        <div class="flex gap-4">
          <UButton @click="colorMode.preference = 'light'" color="primary">
            浅色主题
          </UButton>
          <UButton @click="colorMode.preference = 'dark'" color="primary">
            深色主题
          </UButton>
          <UButton @click="colorMode.preference = 'system'" color="primary">
            系统主题
          </UButton>
        </div>
      </div>

      <!-- 样式测试 -->
      <div class="space-y-4">
        <div
          class="p-4 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg"
        >
          <h3 class="text-lg font-semibold mb-2">白色背景卡片</h3>
          <p class="text-gray-900 dark:text-white">
            这是白色背景的卡片，深色模式下应该是深色背景。
          </p>
        </div>

        <div
          class="p-4 bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg"
        >
          <h3 class="text-lg font-semibold mb-2">灰色背景卡片</h3>
          <p class="text-gray-900 dark:text-white">
            这是灰色背景的卡片，深色模式下应该是深灰色背景。
          </p>
        </div>

        <div
          class="p-4 bg-blue-100 dark:bg-blue-900 border border-blue-200 dark:border-blue-700 rounded-lg"
        >
          <h3 class="text-lg font-semibold mb-2">蓝色背景卡片</h3>
          <p class="text-blue-900 dark:text-blue-100">
            这是蓝色背景的卡片，深色模式下应该是深蓝色背景。
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  const colorMode = useColorMode()
  const isDark = computed(() => colorMode.value === 'dark')

  // 设置页面元信息
  useHead({
    title: '简单主题测试',
    meta: [{ name: 'description', content: '简单的主题切换测试' }],
  })
</script>
