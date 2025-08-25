<template>
  <header class="border-b transition-colors duration-300">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <div class="flex items-center">
          <NuxtLink to="/" class="flex items-center">
            <h1 class="text-xl font-light transition-colors duration-300">
              {{ appName }}
            </h1>
          </NuxtLink>
        </div>

        <!-- Navigation -->
        <nav class="hidden md:flex space-x-8">
          <NuxtLink
            to="/"
            class="px-3 py-2 rounded-md text-sm font-medium transition-colors duration-300"
            active-class="text-primary-600 dark:text-primary-400 font-medium"
          >
            {{ $t('nav.home') }}
          </NuxtLink>
          <NuxtLink
            to="/blog"
            class="px-3 py-2 rounded-md text-sm font-medium transition-colors duration-300"
            active-class="text-primary-600 dark:text-primary-400 font-medium"
          >
            {{ $t('nav.blog') }}
          </NuxtLink>
          <NuxtLink
            to="/config-demo"
            class="px-3 py-2 rounded-md text-sm font-medium transition-colors duration-300"
            active-class="text-primary-600 dark:text-primary-400 font-medium"
          >
            {{ $t('nav.config') }}
          </NuxtLink>
          <NuxtLink
            to="/about"
            class="px-3 py-2 rounded-md text-sm font-medium transition-colors duration-300"
            active-class="text-primary-600 dark:text-primary-400 font-medium"
          >
            {{ $t('nav.about') }}
          </NuxtLink>
        </nav>

        <!-- Right side controls -->
        <div class="flex items-center space-x-4">
          <!-- Theme Toggle -->
          <ThemeToggle />

          <!-- Language Switcher -->
          <UButton
            v-for="locale in availableLocales"
            :key="locale.code"
            :variant="locale.code === currentLocale ? 'solid' : 'ghost'"
            color="primary"
            size="sm"
            @click="switchLanguage(locale.code)"
          >
            {{ locale.language }}
          </UButton>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
  interface Locale {
    code: string
    language: string
  }

  // 获取应用配置
  const { app } = useEnvironmentConfig()
  const appName = computed(() => app.name)

  // 国际化配置
  const { locale, locales } = useI18n()
  const currentLocale = computed(() => locale.value)
  const availableLocales = computed(() => locales.value as Locale[])

  // 切换语言
  const switchLanguage = (code: string) => {
    if (code === 'en' || code === 'zh') {
      locale.value = code
    }
  }
</script>
