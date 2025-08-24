// 全局类型定义

// API 响应类型
export interface ApiResponse<T = any> {
  data: T;
  message: string;
  success: boolean;
  code: number;
}

// 分页类型
export interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

// 用户类型
export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  role: "admin" | "user";
  createdAt: string;
  updatedAt: string;
}

// 环境配置类型
export interface EnvironmentConfig {
  env: {
    isDevelopment: boolean;
    isProduction: boolean;
    isTest: boolean;
    current: string;
  };
  api: {
    baseUrl: string;
    timeout: number;
  };
  app: {
    name: string;
    version: string;
  };
  debug: {
    enabled: boolean;
    logLevel: string;
  };
  server: {
    port: number;
    host: string;
  };
}

// 语言类型
export interface Locale {
  code: string;
  language: string;
  file: string;
}

// 组件 Props 类型
export interface BaseComponentProps {
  class?: string;
  id?: string;
}

// 表单验证类型
export interface ValidationRule {
  required?: boolean;
  min?: number;
  max?: number;
  pattern?: RegExp;
  message?: string;
}

// 错误类型
export interface AppError {
  code: string;
  message: string;
  details?: any;
  timestamp: string;
}
