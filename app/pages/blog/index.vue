<template>
  <div class="min-h-screen bg-slate-900 text-white">
    <!-- Hero Section -->
    <section class="relative py-20">
      <div class="container mx-auto px-4">
        <div class="text-center">
          <h1 class="text-5xl md:text-7xl font-light mb-6 text-white">博客</h1>
          <p class="text-xl md:text-2xl text-slate-300 mb-8 max-w-3xl mx-auto">
            分享技术见解、设计灵感与生活感悟
          </p>
          <div class="flex flex-wrap justify-center gap-4">
            <UButton
              v-for="category in categories"
              :key="category.id"
              :variant="selectedCategory === category.id ? 'solid' : 'ghost'"
              color="neutral"
              size="lg"
              @click="selectedCategory = category.id"
              :class="
                selectedCategory === category.id
                  ? 'bg-white text-slate-900'
                  : 'text-white hover:bg-white/10'
              "
            >
              {{ category.name }}
            </UButton>
          </div>
        </div>
      </div>
    </section>

    <!-- Main Content -->
    <section class="py-16">
      <div class="container mx-auto px-4">
        <!-- Search and Filter -->
        <div class="mb-12">
          <div class="max-w-2xl mx-auto">
            <UInput
              v-model="searchQuery"
              placeholder="搜索文章、标签或作者..."
              icon="i-heroicons-magnifying-glass"
              size="lg"
              class="w-full bg-slate-800 border-slate-700 text-white placeholder-slate-400"
            />
          </div>
        </div>

        <!-- Articles Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <article
            v-for="article in filteredArticles"
            :key="article.id"
            class="group bg-slate-800 rounded-lg overflow-hidden hover:bg-slate-700 transition-colors duration-300"
          >
            <!-- Article Image -->
            <div class="relative overflow-hidden h-48">
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

            <!-- Article Content -->
            <div class="p-6">
              <div class="flex items-center text-sm text-slate-500 mb-3">
                <UIcon name="i-heroicons-calendar" class="w-4 h-4 mr-2" />
                {{ formatDate(article.publishDate) }}
                <UIcon name="i-heroicons-clock" class="w-4 h-4 ml-4 mr-2" />
                {{ article.readTime }} 分钟阅读
              </div>

              <h3
                class="text-xl font-medium text-white mb-3 group-hover:text-slate-200 transition-colors"
              >
                {{ article.title }}
              </h3>

              <p class="text-slate-400 mb-4 line-clamp-3">
                {{ article.excerpt }}
              </p>

              <!-- Tags -->
              <div class="flex flex-wrap gap-2 mb-4">
                <span
                  v-for="tag in article.tags"
                  :key="tag"
                  class="px-2 py-1 bg-slate-700 text-slate-300 text-xs rounded"
                >
                  #{{ tag }}
                </span>
              </div>

              <!-- Author -->
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <img
                    :src="article.author.avatar"
                    :alt="article.author.name"
                    class="w-8 h-8 rounded-full mr-3"
                  />
                  <span class="text-sm font-medium text-slate-300">{{
                    article.author.name
                  }}</span>
                </div>
                <UButton
                  :to="`/blog/${article.slug}`"
                  color="neutral"
                  variant="ghost"
                  size="sm"
                  class="text-white hover:bg-white/10"
                >
                  阅读更多
                  <UIcon name="i-heroicons-arrow-right" class="w-4 h-4 ml-1" />
                </UButton>
              </div>
            </div>
          </article>
        </div>

        <!-- Load More Button -->
        <div class="text-center mt-12">
          <UButton
            v-if="hasMoreArticles"
            color="neutral"
            variant="outline"
            size="lg"
            @click="loadMore"
            :loading="loading"
            class="border-white text-white hover:bg-white hover:text-slate-900"
          >
            加载更多
          </UButton>
        </div>
      </div>
    </section>

    <!-- Newsletter Section -->
    <section class="py-16 bg-slate-800">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-3xl md:text-4xl font-light text-white mb-4">
          订阅我们的通讯
        </h2>
        <p class="text-xl text-slate-300 mb-8 max-w-2xl mx-auto">
          获取最新的文章更新和独家内容
        </p>
        <div class="max-w-md mx-auto flex gap-4">
          <UInput
            v-model="email"
            placeholder="输入您的邮箱地址"
            type="email"
            class="flex-1 bg-slate-700 border-slate-600 text-white placeholder-slate-400"
          />
          <UButton
            color="neutral"
            variant="solid"
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
  }

  interface Category {
    id: string
    name: string
    color: string
  }

  // 响应式数据
  const searchQuery = ref('')
  const selectedCategory = ref('all')
  const email = ref('')
  const loading = ref(false)
  const currentPage = ref(1)
  const articlesPerPage = 9

  // 模拟数据
  const categories: Category[] = [
    { id: 'all', name: '全部', color: 'gray' },
    { id: 'tech', name: '技术', color: 'blue' },
    { id: 'design', name: '设计', color: 'purple' },
    { id: 'life', name: '生活', color: 'green' },
    { id: 'travel', name: '旅行', color: 'orange' },
  ]

  const articles: Article[] = [
    {
      id: 1,
      title: 'Nuxt 4 新特性深度解析',
      slug: 'nuxt4-features-deep-dive',
      excerpt:
        '探索 Nuxt 4 带来的革命性变化，包括新的架构设计、性能优化和开发体验提升。',
      content: '详细内容...',
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
    },
    {
      id: 2,
      title: '现代UI设计趋势2024',
      slug: 'modern-ui-design-trends-2024',
      excerpt:
        '了解2024年最新的UI设计趋势，从色彩搭配到交互设计，打造用户喜爱的界面。',
      content: '详细内容...',
      coverImage:
        'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800&h=400&fit=crop',
      publishDate: '2024-01-12',
      readTime: 6,
      category: 'design',
      tags: ['UI设计', '用户体验', '设计趋势'],
      author: {
        name: '李四',
        avatar:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face',
      },
    },
    {
      id: 3,
      title: '程序员的工作生活平衡',
      slug: 'work-life-balance-for-developers',
      excerpt: '如何在繁忙的编程工作中保持身心健康，实现工作与生活的完美平衡。',
      content: '详细内容...',
      coverImage:
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&h=400&fit=crop',
      publishDate: '2024-01-10',
      readTime: 5,
      category: 'life',
      tags: ['工作生活', '健康', '效率'],
      author: {
        name: '王五',
        avatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      },
    },
    {
      id: 4,
      title: '日本京都深度游攻略',
      slug: 'kyoto-travel-guide',
      excerpt:
        '探索日本古都京都的美丽风景和深厚文化，带你体验最地道的日本风情。',
      content: '详细内容...',
      coverImage:
        'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=800&h=400&fit=crop',
      publishDate: '2024-01-08',
      readTime: 10,
      category: 'travel',
      tags: ['日本', '京都', '旅行'],
      author: {
        name: '赵六',
        avatar:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
      },
    },
    {
      id: 5,
      title: 'TypeScript 高级技巧',
      slug: 'typescript-advanced-tips',
      excerpt: '掌握 TypeScript 的高级特性，提升代码质量和开发效率。',
      content: '详细内容...',
      coverImage:
        'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=800&h=400&fit=crop',
      publishDate: '2024-01-05',
      readTime: 12,
      category: 'tech',
      tags: ['TypeScript', '编程', '技巧'],
      author: {
        name: '张三',
        avatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      },
    },
    {
      id: 6,
      title: '响应式设计最佳实践',
      slug: 'responsive-design-best-practices',
      excerpt:
        '学习响应式设计的核心原则和实践技巧，打造适配各种设备的完美界面。',
      content: '详细内容...',
      coverImage:
        'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&h=400&fit=crop',
      publishDate: '2024-01-03',
      readTime: 7,
      category: 'design',
      tags: ['响应式', '设计', '移动端'],
      author: {
        name: '李四',
        avatar:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face',
      },
    },
  ]

  // 计算属性
  const filteredArticles = computed(() => {
    let filtered = articles

    // 按分类筛选
    if (selectedCategory.value !== 'all') {
      filtered = filtered.filter(
        article => article.category === selectedCategory.value
      )
    }

    // 按搜索关键词筛选
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase()
      filtered = filtered.filter(
        article =>
          article.title.toLowerCase().includes(query) ||
          article.excerpt.toLowerCase().includes(query) ||
          article.tags.some(tag => tag.toLowerCase().includes(query))
      )
    }

    // 分页
    return filtered.slice(0, currentPage.value * articlesPerPage)
  })

  const hasMoreArticles = computed(() => {
    const total = articles.filter(article => {
      if (
        selectedCategory.value !== 'all' &&
        article.category !== selectedCategory.value
      ) {
        return false
      }
      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase()
        return (
          article.title.toLowerCase().includes(query) ||
          article.excerpt.toLowerCase().includes(query) ||
          article.tags.some(tag => tag.toLowerCase().includes(query))
        )
      }
      return true
    }).length

    return filteredArticles.value.length < total
  })

  // 方法
  const getCategoryName = (categoryId: string) => {
    const category = categories.find(c => c.id === categoryId)
    return category?.name || '其他'
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    })
  }

  const loadMore = async () => {
    loading.value = true
    // 模拟加载延迟
    await new Promise(resolve => setTimeout(resolve, 1000))
    currentPage.value++
    loading.value = false
  }

  // 设置页面元信息
  useHead({
    title: '博客列表',
    meta: [
      {
        name: 'description',
        content: '探索最新的技术文章、设计趋势和生活感悟',
      },
    ],
  })
</script>

<style scoped>
  .line-clamp-3 {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
</style>
