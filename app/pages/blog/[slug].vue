<template>
  <div class="min-h-screen bg-slate-900 text-white">
    <!-- Article Header -->
    <section class="relative py-20">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto text-center">
          <!-- Breadcrumb -->
          <nav class="flex justify-center mb-6">
            <ol class="flex items-center space-x-2 text-sm">
              <li>
                <NuxtLink
                  to="/"
                  class="hover:text-slate-300 transition-colors text-slate-400"
                >
                  {{ $t('nav.home') }}
                </NuxtLink>
              </li>
              <li class="text-slate-400">/</li>
              <li>
                <NuxtLink
                  to="/blog"
                  class="hover:text-slate-300 transition-colors text-slate-400"
                >
                  {{ $t('nav.blog') }}
                </NuxtLink>
              </li>
              <li class="text-slate-400">/</li>
              <li class="text-slate-300">{{ article?.title }}</li>
            </ol>
          </nav>

          <!-- Article Meta -->
          <div class="mb-6">
            <span
              class="px-4 py-2 bg-white/10 backdrop-blur-sm rounded-full text-sm text-white"
            >
              {{ getCategoryName(article?.category) }}
            </span>
          </div>

          <!-- Article Title -->
          <h1
            class="text-4xl md:text-6xl font-light mb-6 leading-tight text-white"
          >
            {{ article?.title }}
          </h1>

          <!-- Article Excerpt -->
          <p
            class="text-xl md:text-2xl text-slate-300 mb-8 max-w-3xl mx-auto leading-relaxed"
          >
            {{ article?.excerpt }}
          </p>

          <!-- Article Meta Info -->
          <div
            class="flex flex-wrap items-center justify-center gap-6 text-slate-300"
          >
            <div class="flex items-center">
              <img
                :src="article?.author.avatar"
                :alt="article?.author.name"
                class="w-10 h-10 rounded-full mr-3 border-2 border-slate-600"
              />
              <div class="text-left">
                <div class="font-medium text-white">
                  {{ article?.author.name }}
                </div>
                <div class="text-sm text-slate-400">
                  {{ formatDate(article?.publishDate) }}
                </div>
              </div>
            </div>

            <div class="flex items-center space-x-4">
              <div class="flex items-center">
                <UIcon name="i-heroicons-clock" class="w-5 h-5 mr-2" />
                <span>{{ article?.readTime }} 分钟阅读</span>
              </div>
              <div class="flex items-center">
                <UIcon name="i-heroicons-eye" class="w-5 h-5 mr-2" />
                <span>{{ article?.views || 0 }} 次阅读</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Article Content -->
    <section class="py-16">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <div class="bg-slate-800 rounded-lg overflow-hidden">
            <!-- Article Cover Image -->
            <div class="relative h-64 md:h-96">
              <img
                :src="article?.coverImage"
                :alt="article?.title"
                class="w-full h-full object-cover"
              />
              <div class="absolute inset-0 bg-black/30"></div>
            </div>

            <!-- Article Body -->
            <div class="p-8 md:p-12">
              <!-- Tags -->
              <div class="flex flex-wrap gap-2 mb-8">
                <span
                  v-for="tag in article?.tags"
                  :key="tag"
                  class="px-3 py-1 bg-slate-700 text-slate-300 text-sm rounded"
                >
                  #{{ tag }}
                </span>
              </div>

              <!-- Article Content -->
              <div class="prose prose-lg max-w-none prose-invert">
                <div v-html="article?.content"></div>
              </div>

              <!-- Article Footer -->
              <div class="mt-12 pt-8 border-t border-slate-700">
                <div class="flex flex-wrap items-center justify-between gap-4">
                  <!-- Author Info -->
                  <div class="flex items-center">
                    <img
                      :src="article?.author.avatar"
                      :alt="article?.author.name"
                      class="w-12 h-12 rounded-full mr-4"
                    />
                    <div>
                      <div class="font-medium text-white">
                        {{ article?.author.name }}
                      </div>
                      <div class="text-sm text-slate-400">
                        技术博主 & 前端开发者
                      </div>
                    </div>
                  </div>

                  <!-- Social Share -->
                  <div class="flex items-center space-x-4">
                    <span class="text-sm text-slate-400">分享到：</span>
                    <UButton
                      v-for="social in socialPlatforms"
                      :key="social.name"
                      color="neutral"
                      variant="ghost"
                      size="sm"
                      :icon="social.icon"
                      @click="shareArticle(social.name)"
                      class="text-white hover:bg-white/10"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
  interface Author {
    name: string
    avatar: string
  }

  interface Article {
    id: number
    title: string
    slug: string
    excerpt: string
    content: string
    coverImage: string
    publishDate: string
    readTime: number
    category: string
    tags: string[]
    author: Author
    views?: number
  }

  interface SocialPlatform {
    name: string
    icon: string
    color: string
  }

  // 路由参数
  const route = useRoute()
  const slug = route.params.slug as string

  // 模拟数据
  const article: Article = {
    id: 1,
    title: 'Nuxt 4 新特性深度解析',
    slug: 'nuxt4-features-deep-dive',
    excerpt:
      '探索 Nuxt 4 带来的革命性变化，包括新的架构设计、性能优化和开发体验提升。',
    content: `
    <h2>引言</h2>
    <p>Nuxt 4 作为 Vue.js 生态系统中最重要的全栈框架之一，带来了许多令人兴奋的新特性和改进。本文将深入探讨这些变化，帮助开发者更好地理解和使用 Nuxt 4。</p>
    
    <h2>核心架构改进</h2>
    <p>Nuxt 4 采用了全新的架构设计，主要改进包括：</p>
    <ul>
      <li><strong>Nitro 引擎升级</strong>：更快的构建速度和更好的性能</li>
      <li><strong>Vue 3 完全支持</strong>：充分利用 Vue 3 的 Composition API</li>
      <li><strong>TypeScript 原生支持</strong>：更好的类型安全和开发体验</li>
    </ul>
    
    <h2>性能优化</h2>
    <p>Nuxt 4 在性能方面有了显著提升：</p>
    <ul>
      <li>更快的热重载</li>
      <li>更小的包体积</li>
      <li>更好的缓存策略</li>
    </ul>
    
    <h2>开发体验提升</h2>
    <p>开发者体验是 Nuxt 4 的重点改进领域：</p>
    <ul>
      <li>更智能的自动导入</li>
      <li>更好的错误提示</li>
      <li>更丰富的开发工具</li>
    </ul>
    
    <h2>总结</h2>
    <p>Nuxt 4 的发布标志着 Vue.js 生态系统的一个重要里程碑。通过本文的介绍，希望读者能够更好地理解 Nuxt 4 的价值，并在实际项目中充分利用这些新特性。</p>
  `,
    coverImage:
      'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=400&fit=crop',
    publishDate: '2024-01-15',
    readTime: 8,
    category: 'tech',
    tags: ['Nuxt', 'Vue', '前端'],
    author: {
      name: '张三',
      avatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
    },
    views: 1234,
  }

  const socialPlatforms: SocialPlatform[] = [
    { name: 'twitter', icon: 'i-simple-icons-twitter', color: 'blue' },
    { name: 'facebook', icon: 'i-simple-icons-facebook', color: 'blue' },
    { name: 'linkedin', icon: 'i-simple-icons-linkedin', color: 'blue' },
    { name: 'wechat', icon: 'i-simple-icons-wechat', color: 'green' },
  ]

  // 方法
  const getCategoryName = (categoryId?: string) => {
    const categoryNames: Record<string, string> = {
      tech: '技术',
      design: '设计',
      life: '生活',
      travel: '旅行',
    }
    return categoryNames[categoryId || ''] || '其他'
  }

  const formatDate = (dateString?: string) => {
    if (!dateString) return ''
    return new Date(dateString).toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    })
  }

  const shareArticle = (platform: string) => {
    const url = window.location.href
    const title = article.title
    const text = article.excerpt

    const shareUrls = {
      twitter: `https://twitter.com/intent/tweet?url=${encodeURIComponent(url)}&text=${encodeURIComponent(title)}`,
      facebook: `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`,
      linkedin: `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`,
      wechat: '#',
    }

    if (shareUrls[platform as keyof typeof shareUrls]) {
      window.open(shareUrls[platform as keyof typeof shareUrls], '_blank')
    }
  }

  // 设置页面元信息
  useHead({
    title: article.title,
    meta: [
      { name: 'description', content: article.excerpt },
      { property: 'og:title', content: article.title },
      { property: 'og:description', content: article.excerpt },
      { property: 'og:image', content: article.coverImage },
      { name: 'twitter:card', content: 'summary_large_image' },
    ],
  })
</script>

<style scoped>
  :deep(.prose) {
    color: #e2e8f0;
  }

  :deep(.prose h2) {
    color: #f8fafc;
    font-size: 1.5rem;
    font-weight: 600;
    margin-top: 2rem;
    margin-bottom: 1rem;
  }

  :deep(.prose p) {
    margin-bottom: 1rem;
    line-height: 1.75;
    color: #cbd5e1;
  }

  :deep(.prose ul) {
    margin-bottom: 1rem;
    padding-left: 1.5rem;
  }

  :deep(.prose li) {
    margin-bottom: 0.5rem;
    color: #cbd5e1;
  }

  :deep(.prose strong) {
    font-weight: 600;
    color: #f8fafc;
  }
</style>
