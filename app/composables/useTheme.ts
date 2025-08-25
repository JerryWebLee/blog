export const useTheme = () => {
  // 使用 Nuxt UI 的颜色模式
  const colorMode = useColorMode()

  // 主题配置
  const themes = [
    { value: 'light', label: '浅色', icon: 'i-heroicons-sun' },
    { value: 'dark', label: '深色', icon: 'i-heroicons-moon' },
    { value: 'system', label: '系统', icon: 'i-heroicons-computer-desktop' },
  ]

  // 当前主题状态
  const theme = computed(() => colorMode.preference)

  // 是否深色模式
  const isDark = computed(() => colorMode.value === 'dark')

  // 切换主题
  const toggleTheme = () => {
    const currentIndex = themes.findIndex(t => t.value === colorMode.preference)
    const nextIndex = currentIndex >= 0 ? (currentIndex + 1) % themes.length : 0
    const nextTheme = themes[nextIndex]
    if (nextTheme) {
      colorMode.preference = nextTheme.value
    }
  }

  // 设置主题
  const setTheme = (newTheme: 'dark' | 'light' | 'system') => {
    colorMode.preference = newTheme
  }

  // 获取当前主题的显示名称
  const currentThemeLabel = computed(() => {
    const found = themes.find(t => t.value === colorMode.preference)
    return found?.label || '深色'
  })

  // 获取当前主题的图标
  const currentThemeIcon = computed(() => {
    const found = themes.find(t => t.value === colorMode.preference)
    return found?.icon || 'i-heroicons-moon'
  })

  return {
    theme: readonly(theme),
    isDark: readonly(isDark),
    themes,
    toggleTheme,
    setTheme,
    currentThemeLabel,
    currentThemeIcon,
    colorMode: readonly(colorMode),
  }
}
