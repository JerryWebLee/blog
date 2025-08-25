<template>
  <div class="min-h-screen">
    <!-- Hero Section -->
    <section class="relative py-32">
      <div class="container mx-auto px-4">
        <div class="text-center">
          <h1 class="text-6xl md:text-8xl font-light mb-8">
            {{ appName }}
          </h1>
          <p
            class="text-xl md:text-2xl mb-12 max-w-3xl mx-auto leading-relaxed text-gray-600 dark:text-gray-300"
          >
            分享技术见解、设计灵感与生活感悟
          </p>

          <div
            class="flex flex-col sm:flex-row gap-6 justify-center items-center"
          >
            <UButton to="/blog" color="primary" variant="solid" size="xl">
              开始阅读
            </UButton>
            <UButton to="/about" color="primary" variant="outline" size="xl">
              了解更多
            </UButton>
          </div>
        </div>
      </div>
    </section>

    <!-- Latest Articles -->
    <section class="py-20">
      <div class="container mx-auto px-4">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-light mb-6">最新文章</h2>
          <p class="text-xl max-w-2xl mx-auto text-gray-600 dark:text-gray-300">
            探索我们最新的技术分享和设计灵感
          </p>
        </div>

        <div
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto"
        >
          <UCard
            v-for="article in latestArticles"
            :key="article.id"
            class="group hover:scale-105 transition-all duration-300"
          >
            <template #header>
              <div class="relative h-48 overflow-hidden">
                <img
                  :src="article.coverImage"
                  :alt="article.title"
                  class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <div class="absolute inset-0 bg-black/40"></div>
                <div class="absolute top-4 left-4">
                  <UBadge color="primary" variant="solid" size="sm">
                    {{ getCategoryName(article.category) }}
                  </UBadge>
                </div>
              </div>
            </template>

            <div class="p-6">
              <h3
                class="text-xl font-medium mb-3 group-hover:text-primary-600 transition-colors"
              >
                {{ article.title }}
              </h3>
              <p class="mb-4 line-clamp-2 text-gray-600 dark:text-gray-300">
                {{ article.excerpt }}
              </p>
              <div class="flex items-center justify-between">
                <div class="text-sm text-gray-500 dark:text-gray-400">
                  <span>{{ formatDate(article.publishDate) }}</span>
                </div>
                <UButton
                  :to="`/blog/${article.slug}`"
                  color="primary"
                  variant="ghost"
                  size="sm"
                >
                  阅读
                </UButton>
              </div>
            </div>
          </UCard>
        </div>

        <div class="text-center mt-12">
          <UButton to="/blog" color="primary" variant="outline" size="lg">
            查看所有文章
            <UIcon name="i-heroicons-arrow-right" class="w-5 h-5 ml-2" />
          </UButton>
        </div>
      </div>
    </section>

    <!-- Newsletter Section -->
    <section class="py-20 bg-gray-50 dark:bg-gray-900">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-4xl md:text-5xl font-light mb-6">订阅更新</h2>
        <p
          class="text-xl mb-8 max-w-2xl mx-auto text-gray-600 dark:text-gray-300"
        >
          获取最新的文章更新和独家内容
        </p>
        <div class="max-w-md mx-auto flex gap-4">
          <UInput
            v-model="email"
            placeholder="输入您的邮箱地址"
            type="email"
            size="lg"
            class="flex-1"
          />
          <UButton color="primary" variant="solid" size="lg"> 订阅 </UButton>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
  interface Article {
    id: number
    title: string
    slug: string
    excerpt: string
    coverImage: string
    publishDate: string
    category: string
  }

  // 获取应用配置
  const { app } = useEnvironmentConfig()
  const appName = computed(() => app.name)

  // 响应式数据
  const email = ref('')

  // 最新文章数据
  const latestArticles: Article[] = [
    {
      id: 1,
      title: 'Nuxt 4 新特性深度解析',
      slug: 'nuxt4-features-deep-dive',
      excerpt:
        '探索 Nuxt 4 带来的革命性变化，包括新的架构设计、性能优化和开发体验提升。',
      coverImage:
        'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=400&fit=crop',
      publishDate: '2024-01-15',
      category: 'tech',
    },
    {
      id: 2,
      title: '现代UI设计趋势2024',
      slug: 'modern-ui-design-trends-2024',
      excerpt:
        '了解2024年最新的UI设计趋势，从色彩搭配到交互设计，打造用户喜爱的界面。',
      coverImage:
        'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800&h=400&fit=crop',
      publishDate: '2024-01-12',
      category: 'design',
    },
    {
      id: 3,
      title: '程序员的工作生活平衡',
      slug: 'work-life-balance-for-developers',
      excerpt: '如何在繁忙的编程工作中保持身心健康，实现工作与生活的完美平衡。',
      coverImage:
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&h=400&fit=crop',
      publishDate: '2024-01-10',
      category: 'life',
    },
  ]

  // 方法
  const getCategoryName = (categoryId: string) => {
    const categoryNames: Record<string, string> = {
      tech: '技术',
      design: '设计',
      life: '生活',
      travel: '旅行',
    }
    return categoryNames[categoryId] || '其他'
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    })
  }

  // 设置页面元信息
  useHead({
    title: '首页',
    meta: [{ name: 'description', content: '基于 Nuxt 4 的现代化博客应用' }],
  })
</script>

<style scoped>
  .line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
</style>
