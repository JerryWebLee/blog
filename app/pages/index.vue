<template>
  <div class="min-h-screen bg-slate-900 text-white">
    <!-- Hero Section -->
    <section class="relative py-32">
      <div class="container mx-auto px-4">
        <div class="text-center">
          <h1 class="text-6xl md:text-8xl font-light mb-8 text-white">
            {{ appName }}
          </h1>
          <p
            class="text-xl md:text-2xl text-slate-300 mb-12 max-w-3xl mx-auto leading-relaxed"
          >
            分享技术见解、设计灵感与生活感悟
          </p>

          <div
            class="flex flex-col sm:flex-row gap-6 justify-center items-center"
          >
            <UButton
              to="/blog"
              color="neutral"
              variant="solid"
              size="xl"
              class="text-lg px-8 py-4 bg-white text-slate-900 hover:bg-slate-100"
            >
              开始阅读
            </UButton>
            <UButton
              to="/about"
              color="neutral"
              variant="outline"
              size="xl"
              class="text-lg px-8 py-4 border-white text-white hover:bg-white hover:text-slate-900"
            >
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
          <h2 class="text-4xl md:text-5xl font-light text-white mb-6">
            最新文章
          </h2>
          <p class="text-xl text-slate-300 max-w-2xl mx-auto">
            探索我们最新的技术分享和设计灵感
          </p>
        </div>

        <div
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto"
        >
          <article
            v-for="article in latestArticles"
            :key="article.id"
            class="group bg-slate-800 rounded-lg overflow-hidden hover:bg-slate-700 transition-colors duration-300"
          >
            <div class="relative h-48 overflow-hidden">
              <img
                :src="article.coverImage"
                :alt="article.title"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
              />
              <div class="absolute inset-0 bg-black/40"></div>
              <div class="absolute top-4 left-4">
                <span
                  class="px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-sm text-white"
                >
                  {{ getCategoryName(article.category) }}
                </span>
              </div>
            </div>
            <div class="p-6">
              <h3
                class="text-xl font-medium text-white mb-3 group-hover:text-slate-200 transition-colors"
              >
                {{ article.title }}
              </h3>
              <p class="text-slate-400 mb-4 line-clamp-2">
                {{ article.excerpt }}
              </p>
              <div class="flex items-center justify-between">
                <div class="flex items-center text-sm text-slate-500">
                  <span>{{ formatDate(article.publishDate) }}</span>
                </div>
                <UButton
                  :to="`/blog/${article.slug}`"
                  color="neutral"
                  variant="ghost"
                  size="sm"
                  class="text-white hover:bg-white/10"
                >
                  阅读
                </UButton>
              </div>
            </div>
          </article>
        </div>

        <div class="text-center mt-12">
          <UButton
            to="/blog"
            color="white"
            variant="outline"
            size="lg"
            class="border-white text-white hover:bg-white hover:text-slate-900"
          >
            查看所有文章
            <UIcon name="i-heroicons-arrow-right" class="w-5 h-5 ml-2" />
          </UButton>
        </div>
      </div>
    </section>

    <!-- Newsletter Section -->
    <section class="py-20 bg-slate-800">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-4xl md:text-5xl font-light text-white mb-6">
          订阅更新
        </h2>
        <p class="text-xl text-slate-300 mb-8 max-w-2xl mx-auto">
          获取最新的文章更新和独家内容
        </p>
        <div class="max-w-md mx-auto flex gap-4">
          <UInput
            v-model="email"
            placeholder="输入您的邮箱地址"
            type="email"
            size="lg"
            class="flex-1 bg-slate-700 border-slate-600 text-white placeholder-slate-400"
          />
          <UButton
            color="white"
            variant="solid"
            size="lg"
            class="bg-white text-slate-900 hover:bg-slate-100"
          >
            订阅
          </UButton>
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
