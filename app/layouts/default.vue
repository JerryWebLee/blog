<template>
  <div class="min-h-screen flex flex-col">
    <AppHeader />
    <main class="flex-1">
      <slot />
    </main>
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
  // 布局组件
</script>

<style scoped>
  /* 布局样式 */
</style>
