export default defineNuxtPlugin(() => {
  const colorMode = useColorMode()

  // 手动管理 dark 类
  const updateDarkClass = (isDark: boolean) => {
    if (process.client) {
      const html = document.documentElement
      if (isDark) {
        html.classList.add('dark')
      } else {
        html.classList.remove('dark')
      }
      console.log('Updated dark class:', isDark ? 'added' : 'removed')
    }
  }

  // 确保颜色模式正确初始化
  if (process.client) {
    // 强制设置初始颜色模式
    onMounted(() => {
      console.log('Initial color mode:', colorMode.value)
      console.log('Initial preference:', colorMode.preference)

      // 如果没有设置偏好，默认设置为系统
      if (!colorMode.preference) {
        colorMode.preference = 'system'
      }

      // 根据当前颜色模式设置 dark 类
      updateDarkClass(colorMode.value === 'dark')
    })

    // 监听颜色模式变化
    watch(colorMode, newMode => {
      console.log('Color mode changed to:', newMode.value)
      console.log('Color mode preference:', newMode.preference)

      // 更新 dark 类
      updateDarkClass(newMode.value === 'dark')
    })
  }
})
