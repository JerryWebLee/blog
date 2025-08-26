# 多阶段构建Dockerfile - Nuxt 4博客项目部署
# 第一阶段：构建阶段
FROM --platform=linux/amd64 node:20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装必要的系统依赖
RUN apk add --no-cache libc6-compat python3 make g++ sqlite-dev

# 安装pnpm包管理器（项目使用pnpm）
RUN npm install -g pnpm

# 复制package.json和pnpm-lock.yaml文件
COPY package.json pnpm-lock.yaml ./

# 复制scripts目录（preinstall脚本需要）
COPY scripts/ ./scripts/

# 安装依赖（包括开发依赖，因为构建时需要）
RUN pnpm install --frozen-lockfile

# 复制其余源代码
COPY . .

# 设置环境变量为生产环境
ENV NODE_ENV=production
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

# 使用Docker专用配置文件构建应用
RUN cp nuxt.config.docker.ts nuxt.config.ts && pnpm run build:prod

# 第二阶段：生产运行阶段
FROM --platform=linux/amd64 node:20-alpine AS runner

# 设置工作目录
WORKDIR /app

# 安装必要的系统依赖
RUN apk add --no-cache libc6-compat sqlite

# 创建非root用户以提高安全性
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nuxtjs

# 从构建阶段复制构建产物和依赖
COPY --from=builder --chown=nuxtjs:nodejs /app/.output ./.output
COPY --from=builder --chown=nuxtjs:nodejs /app/public ./public
COPY --from=builder --chown=nuxtjs:nodejs /app/package.json ./package.json

# 切换到非root用户
USER nuxtjs

# 暴露端口
EXPOSE 3000

# 设置环境变量
ENV NODE_ENV=production
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000
ENV HOST=0.0.0.0
ENV PORT=3000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })" || exit 1

# 启动应用
CMD ["node", ".output/server/index.mjs"] 