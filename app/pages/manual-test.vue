<template>
  <div class="min-h-screen p-8">
    <div class="max-w-2xl mx-auto">
      <h1 class="text-3xl font-bold mb-8">手动主题测试</h1>

      <!-- 手动控制按钮 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">手动控制</h2>
        <div class="flex gap-4">
          <button
            @click="setLightMode"
            class="px-4 py-2 bg-blue-500 text-white rounded"
          >
            设置为浅色模式
          </button>
          <button
            @click="setDarkMode"
            class="px-4 py-2 bg-gray-800 text-white rounded"
          >
            设置为深色模式
          </button>
          <button
            @click="toggleMode"
            class="px-4 py-2 bg-green-500 text-white rounded"
          >
            切换模式
          </button>
        </div>
      </div>

      <!-- 当前状态 -->
      <div class="mb-8 p-4 bg-gray-100 dark:bg-gray-800 rounded-lg">
        <h2 class="text-xl font-semibold mb-4">当前状态</h2>
        <p><strong>HTML 类名:</strong> {{ htmlClasses }}</p>
        <p><strong>是否深色模式:</strong> {{ isDarkMode ? '是' : '否' }}</p>
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
  const htmlClasses = ref('')
  const isDarkMode = ref(false)

  // 更新状态
  const updateStatus = () => {
    if (process.client) {
      const html = document.documentElement
      htmlClasses.value = html.className
      isDarkMode.value = html.classList.contains('dark')
    }
  }

  // 设置浅色模式
  const setLightMode = () => {
    if (process.client) {
      const html = document.documentElement
      html.classList.remove('dark')
      updateStatus()
    }
  }

  // 设置深色模式
  const setDarkMode = () => {
    if (process.client) {
      const html = document.documentElement
      html.classList.add('dark')
      updateStatus()
    }
  }

  // 切换模式
  const toggleMode = () => {
    if (process.client) {
      const html = document.documentElement
      html.classList.toggle('dark')
      updateStatus()
    }
  }

  // 初始化
  onMounted(() => {
    updateStatus()
  })

  // 设置页面元信息
  useHead({
    title: '手动主题测试',
    meta: [{ name: 'description', content: '手动主题切换测试' }],
  })
</script>
