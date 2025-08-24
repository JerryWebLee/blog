import { defineStore } from 'pinia'
import type { User } from '~/types'

export const useUserStore = defineStore('user', () => {
  // 状态
  const user = ref<User | null>(null)
  const isAuthenticated = computed(() => !!user.value)
  const isLoading = ref(false)

  // 获取用户信息
  const fetchUser = async () => {
    try {
      isLoading.value = true
      // 这里应该调用实际的 API
      const response = await $fetch('/api/user/profile')
      user.value = response.data
    } catch (error) {
      console.error('获取用户信息失败:', error)
      user.value = null
    } finally {
      isLoading.value = false
    }
  }

  // 登录
  const login = async (credentials: { email: string; password: string }) => {
    try {
      isLoading.value = true
      const response = await $fetch('/api/auth/login', {
        method: 'POST',
        body: credentials,
      })

      if (response.success) {
        user.value = response.data.user
        return { success: true }
      } else {
        return { success: false, message: response.message }
      }
    } catch (error) {
      console.error('登录失败:', error)
      return { success: false, message: '登录失败，请重试' }
    } finally {
      isLoading.value = false
    }
  }

  // 登出
  const logout = async () => {
    try {
      await $fetch('/api/auth/logout', { method: 'POST' })
    } catch (error) {
      console.error('登出失败:', error)
    } finally {
      user.value = null
    }
  }

  // 更新用户信息
  const updateProfile = async (profile: Partial<User>) => {
    try {
      isLoading.value = true
      const response = await $fetch('/api/user/profile', {
        method: 'PUT',
        body: profile,
      })

      if (response.success) {
        user.value = { ...user.value, ...response.data }
        return { success: true }
      } else {
        return { success: false, message: response.message }
      }
    } catch (error) {
      console.error('更新用户信息失败:', error)
      return { success: false, message: '更新失败，请重试' }
    } finally {
      isLoading.value = false
    }
  }

  return {
    // 状态
    user: readonly(user),
    isAuthenticated,
    isLoading: readonly(isLoading),

    // 方法
    fetchUser,
    login,
    logout,
    updateProfile,
  }
})
