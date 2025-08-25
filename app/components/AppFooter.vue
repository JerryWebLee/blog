<template>
  <footer class="border-t transition-colors duration-300">
    <div class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
      <div class="flex flex-col md:flex-row justify-between items-center">
        <!-- Copyright -->
        <div class="text-center md:text-left">
          <p class="text-sm text-gray-600 dark:text-gray-400">
            © {{ currentYear }} {{ appName }}. {{ $t('footer.rights') }}
          </p>
          <p class="text-xs mt-1 text-gray-500 dark:text-gray-500">
            {{ $t('footer.version') }}: {{ appVersion }}
          </p>
        </div>

        <!-- Links -->
        <div class="mt-4 md:mt-0">
          <nav class="flex space-x-6">
            <NuxtLink
              to="/about"
              class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
            >
              {{ $t('nav.about') }}
            </NuxtLink>
            <NuxtLink
              to="/blog"
              class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
            >
              {{ $t('nav.blog') }}
            </NuxtLink>
          </nav>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
  // 获取应用配置
  const { app } = useEnvironmentConfig()
  const appName = computed(() => app.name)
  const appVersion = computed(() => app.version)

  // 当前年份
  const currentYear = computed(() => new Date().getFullYear())
</script>
