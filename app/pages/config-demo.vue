<template>
  <div class="min-h-screen bg-slate-900 text-white">
    <div class="p-6 max-w-4xl mx-auto">
      <h1 class="text-3xl font-light mb-8 text-white">环境配置演示</h1>

      <!-- 环境信息 -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- 环境状态 -->
        <div class="bg-slate-800 p-6 rounded-lg border border-slate-700">
          <h2 class="text-xl font-medium mb-4 text-white">环境信息</h2>
          <div class="space-y-2">
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">当前环境:</span>
              <span :class="getEnvBadgeClass(config.env.current)">
                {{ config.env.current }}
              </span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">开发环境:</span>
              <span
                :class="
                  config.env.isDevelopment ? 'text-green-400' : 'text-slate-500'
                "
              >
                {{ config.env.isDevelopment ? '是' : '否' }}
              </span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">生产环境:</span>
              <span
                :class="
                  config.env.isProduction ? 'text-red-400' : 'text-slate-500'
                "
              >
                {{ config.env.isProduction ? '是' : '否' }}
              </span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">测试环境:</span>
              <span
                :class="config.env.isTest ? 'text-blue-400' : 'text-slate-500'"
              >
                {{ config.env.isTest ? '是' : '否' }}
              </span>
            </div>
          </div>
        </div>

        <!-- API 配置 -->
        <div class="bg-slate-800 p-6 rounded-lg border border-slate-700">
          <h2 class="text-xl font-medium mb-4 text-white">API 配置</h2>
          <div class="space-y-2">
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">基础 URL:</span>
              <span class="text-blue-400 font-mono text-sm">{{
                config.api.baseUrl
              }}</span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">超时时间:</span>
              <span class="text-slate-400">{{ config.api.timeout }}ms</span>
            </div>
          </div>
        </div>

        <!-- 应用信息 -->
        <div class="bg-slate-800 p-6 rounded-lg border border-slate-700">
          <h2 class="text-xl font-medium mb-4 text-white">应用信息</h2>
          <div class="space-y-2">
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">应用名称:</span>
              <span class="text-slate-400">{{ config.app.name }}</span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">版本号:</span>
              <span class="text-slate-400">{{ config.app.version }}</span>
            </div>
          </div>
        </div>

        <!-- 调试配置 -->
        <div class="bg-slate-800 p-6 rounded-lg border border-slate-700">
          <h2 class="text-xl font-medium mb-4 text-white">调试配置</h2>
          <div class="space-y-2">
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">调试模式:</span>
              <span
                :class="
                  config.debug.enabled ? 'text-green-400' : 'text-red-400'
                "
              >
                {{ config.debug.enabled ? '启用' : '禁用' }}
              </span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium text-slate-300">日志级别:</span>
              <span class="text-slate-400">{{ config.debug.logLevel }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- API 测试 -->
      <div class="mt-8 bg-slate-800 p-6 rounded-lg border border-slate-700">
        <h2 class="text-xl font-medium mb-4 text-white">API 测试</h2>
        <div class="space-y-4">
          <div class="flex gap-4">
            <UButton
              color="neutral"
              variant="solid"
              @click="testApi"
              :loading="loading"
              class="bg-white text-slate-900 hover:bg-slate-100"
            >
              测试 API 连接
            </UButton>
            <UButton
              color="neutral"
              variant="outline"
              @click="clearResults"
              class="border-white text-white hover:bg-white hover:text-slate-900"
            >
              清除结果
            </UButton>
          </div>

          <!-- 测试结果 -->
          <div v-if="testResults.length > 0" class="space-y-2">
            <h3 class="text-lg font-medium text-white">测试结果:</h3>
            <div
              v-for="(result, index) in testResults"
              :key="index"
              class="p-3 rounded border"
              :class="
                result.success
                  ? 'bg-green-900/20 border-green-700 text-green-300'
                  : 'bg-red-900/20 border-red-700 text-red-300'
              "
            >
              <div class="font-medium">{{ result.name }}</div>
              <div class="text-sm mt-1">{{ result.message }}</div>
              <div v-if="result.duration" class="text-xs mt-1">
                耗时: {{ result.duration }}ms
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 环境变量 -->
      <div class="mt-8 bg-slate-800 p-6 rounded-lg border border-slate-700">
        <h2 class="text-xl font-medium mb-4 text-white">环境变量</h2>
        <div class="space-y-2">
          <div
            v-for="(value, key) in envVars"
            :key="key"
            class="flex justify-between items-center p-2 bg-slate-700 rounded"
          >
            <span class="font-mono text-sm text-slate-300">{{ key }}:</span>
            <span class="font-mono text-sm text-slate-400">{{ value }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  interface TestResult {
    name: string
    success: boolean
    message: string
    duration?: number
  }

  // 获取环境配置
  const config = useEnvironmentConfig()

  // 响应式数据
  const loading = ref(false)
  const testResults = ref<TestResult[]>([])

  // 环境变量
  const envVars = computed(() => ({
    NODE_ENV: config.env.current,
    API_BASE_URL: config.api.baseUrl,
    API_TIMEOUT: config.api.timeout,
    APP_NAME: config.app.name,
    APP_VERSION: config.app.version,
    DEBUG: config.debug.enabled,
    LOG_LEVEL: config.debug.logLevel,
    NITRO_PORT: config.server.port,
    NITRO_HOST: config.server.host,
  }))

  // 获取环境徽章样式
  const getEnvBadgeClass = (env: string) => {
    const classes = {
      development: 'px-2 py-1 bg-green-900/20 text-green-400 rounded text-sm',
      production: 'px-2 py-1 bg-red-900/20 text-red-400 rounded text-sm',
      test: 'px-2 py-1 bg-blue-900/20 text-blue-400 rounded text-sm',
    }
    return (
      classes[env as keyof typeof classes] ||
      'px-2 py-1 bg-slate-700 text-slate-300 rounded text-sm'
    )
  }

  // 测试 API 连接
  const testApi = async () => {
    loading.value = true
    testResults.value = []

    try {
      // 测试基础连接
      const startTime = Date.now()
      const response = await $fetch('/api/health', {
        baseURL: config.api.baseUrl,
      })
      const duration = Date.now() - startTime

      testResults.value.push({
        name: 'API 健康检查',
        success: true,
        message: 'API 连接正常',
        duration,
      })
    } catch (error) {
      testResults.value.push({
        name: 'API 健康检查',
        success: false,
        message: `连接失败: ${error instanceof Error ? error.message : '未知错误'}`,
      })
    }

    // 测试配置端点
    try {
      const startTime = Date.now()
      const response = await $fetch('/api/config')
      const duration = Date.now() - startTime

      testResults.value.push({
        name: '配置端点',
        success: true,
        message: '配置端点访问正常',
        duration,
      })
    } catch (error) {
      testResults.value.push({
        name: '配置端点',
        success: false,
        message: `访问失败: ${error instanceof Error ? error.message : '未知错误'}`,
      })
    }

    loading.value = false
  }

  // 清除测试结果
  const clearResults = () => {
    testResults.value = []
  }

  // 设置页面元信息
  useHead({
    title: '环境配置演示',
    meta: [{ name: 'description', content: '查看和测试应用的环境配置' }],
  })
</script>
