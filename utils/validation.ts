import type { ValidationRule } from '~/types'

/**
 * 验证邮箱格式
 */
export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

/**
 * 验证密码强度
 */
export const validatePassword = (
  password: string
): { isValid: boolean; message: string } => {
  if (password.length < 8) {
    return { isValid: false, message: '密码长度至少8位' }
  }

  if (!/(?=.*[a-z])/.test(password)) {
    return { isValid: false, message: '密码必须包含小写字母' }
  }

  if (!/(?=.*[A-Z])/.test(password)) {
    return { isValid: false, message: '密码必须包含大写字母' }
  }

  if (!/(?=.*\d)/.test(password)) {
    return { isValid: false, message: '密码必须包含数字' }
  }

  return { isValid: true, message: '密码格式正确' }
}

/**
 * 验证手机号格式
 */
export const validatePhone = (phone: string): boolean => {
  const phoneRegex = /^1[3-9]\d{9}$/
  return phoneRegex.test(phone)
}

/**
 * 通用验证函数
 */
export const validateField = (
  value: any,
  rules: ValidationRule[]
): { isValid: boolean; message: string } => {
  for (const rule of rules) {
    // 必填验证
    if (rule.required && (!value || value.toString().trim() === '')) {
      return { isValid: false, message: rule.message || '此字段为必填项' }
    }

    // 长度验证
    if (value && typeof value === 'string') {
      if (rule.min && value.length < rule.min) {
        return {
          isValid: false,
          message: rule.message || `最少需要${rule.min}个字符`,
        }
      }

      if (rule.max && value.length > rule.max) {
        return {
          isValid: false,
          message: rule.message || `最多允许${rule.max}个字符`,
        }
      }
    }

    // 正则验证
    if (rule.pattern && !rule.pattern.test(value)) {
      return { isValid: false, message: rule.message || '格式不正确' }
    }
  }

  return { isValid: true, message: '' }
}

/**
 * 验证表单
 */
export const validateForm = (
  formData: Record<string, any>,
  formRules: Record<string, ValidationRule[]>
): Record<string, string> => {
  const errors: Record<string, string> = {}

  for (const [field, rules] of Object.entries(formRules)) {
    const validation = validateField(formData[field], rules)
    if (!validation.isValid) {
      errors[field] = validation.message
    }
  }

  return errors
}
