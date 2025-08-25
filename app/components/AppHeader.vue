<template>
  <header class="bg-slate-900 border-b border-slate-700">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <div class="flex items-center">
          <NuxtLink to="/" class="flex items-center">
            <h1 class="text-xl font-light text-white">{{ appName }}</h1>
          </NuxtLink>
        </div>

        <!-- Navigation -->
        <nav class="hidden md:flex space-x-8">
          <NuxtLink
            to="/"
            class="text-slate-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            active-class="text-white font-medium"
          >
            {{ $t('nav.home') }}
          </NuxtLink>
          <NuxtLink
            to="/blog"
            class="text-slate-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            active-class="text-white font-medium"
          >
            {{ $t('nav.blog') }}
          </NuxtLink>
          <NuxtLink
            to="/config-demo"
            class="text-slate-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            active-class="text-white font-medium"
          >
            {{ $t('nav.config') }}
          </NuxtLink>
          <NuxtLink
            to="/about"
            class="text-slate-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            active-class="text-white font-medium"
          >
            {{ $t('nav.about') }}
          </NuxtLink>
        </nav>

        <!-- Language Switcher -->
        <div class="flex items-center space-x-4">
          <UButton
            v-for="locale in availableLocales"
            :key="locale.code"
            :variant="locale.code === currentLocale ? 'solid' : 'ghost'"
            color="neutral"
            size="sm"
            @click="switchLanguage(locale.code)"
            :class="
              locale.code === currentLocale
                ? 'bg-white text-slate-900'
                : 'text-white hover:bg-white/10'
            "
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
