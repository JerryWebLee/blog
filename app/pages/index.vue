<template>
  <div class="container mx-auto px-4 py-8">
    <div class="text-center">
      <h1 class="text-4xl font-bold text-gray-900 mb-4">
        {{ $t("welcome") }} {{ appName }}
      </h1>
      <p class="text-lg text-gray-600 mb-8">这是一个基于 Nuxt 4 的现代化应用</p>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
        <!-- 功能卡片 -->
        <UCard class="text-center">
          <template #header>
            <h3 class="text-lg font-semibold">🚀 快速开发</h3>
          </template>
          <p class="text-gray-600">
            使用 Nuxt 4 的最新特性，快速构建现代化应用
          </p>
        </UCard>

        <UCard class="text-center">
          <template #header>
            <h3 class="text-lg font-semibold">🌍 国际化</h3>
          </template>
          <p class="text-gray-600">内置多语言支持，轻松实现国际化</p>
        </UCard>

        <UCard class="text-center">
          <template #header>
            <h3 class="text-lg font-semibold">🎨 UI 组件</h3>
          </template>
          <p class="text-gray-600">使用 Nuxt UI 组件库，构建美观的界面</p>
        </UCard>
      </div>

      <div class="mt-8">
        <UButton to="/config-demo" color="primary" variant="solid" size="lg">
          查看配置演示
        </UButton>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// 获取应用配置
const { app } = useEnvironmentConfig();
const appName = computed(() => app.name);

// 设置页面元信息
useHead({
  title: "首页",
  meta: [{ name: "description", content: "Nuxt 4 应用首页" }],
});
</script>

<style scoped></style>
