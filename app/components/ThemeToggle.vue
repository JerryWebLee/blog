<template>
  <div class="relative">
    <!-- 主题切换按钮 -->
    <UButton
      color="neutral"
      variant="ghost"
      size="sm"
      @click="toggleTheme"
      :title="`当前主题: ${currentThemeLabel}`"
      class="theme-toggle"
    >
      <UIcon :name="currentThemeIcon" class="w-5 h-5" />
      <span class="sr-only">切换主题</span>
    </UButton>
  </div>
</template>

<script setup lang="ts">
  const {
    theme,
    themes,
    toggleTheme,
    setTheme,
    currentThemeLabel,
    currentThemeIcon,
  } = useTheme()
</script>

<style scoped>
  .theme-toggle {
    position: relative;
  }
</style>
