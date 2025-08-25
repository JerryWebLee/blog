<template>
  <div class="min-h-screen bg-slate-900 text-white">
    <!-- Hero Section -->
    <section class="relative py-20">
      <div class="container mx-auto px-4">
        <div class="text-center">
          <h1 class="text-5xl md:text-7xl font-light mb-6 text-white">
            关于我们
          </h1>
          <p class="text-xl md:text-2xl text-slate-300 mb-8 max-w-3xl mx-auto">
            分享技术见解、设计灵感与生活感悟的博客平台
          </p>
        </div>
      </div>
    </section>

    <!-- About Content -->
    <section class="py-16">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <!-- Mission -->
          <div class="bg-slate-800 rounded-lg p-8 md:p-12 mb-12">
            <h2 class="text-3xl md:text-4xl font-light text-white mb-6">
              我们的使命
            </h2>
            <p class="text-lg text-slate-300 leading-relaxed mb-6">
              我们致力于为技术爱好者和开发者提供一个分享知识、交流经验的平台。通过高质量的技术文章、
              设计灵感和生活感悟，我们希望帮助更多人成长，推动技术社区的发展。
            </p>
            <p class="text-lg text-slate-300 leading-relaxed">
              无论您是前端开发者、设计师，还是对技术充满热情的学习者，这里都有适合您的内容。
            </p>
          </div>

          <!-- Team -->
          <div class="bg-slate-800 rounded-lg p-8 md:p-12 mb-12">
            <h2
              class="text-3xl md:text-4xl font-light text-white mb-8 text-center"
            >
              我们的团队
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div
                v-for="member in teamMembers"
                :key="member.id"
                class="text-center group"
              >
                <div class="relative mb-6">
                  <img
                    :src="member.avatar"
                    :alt="member.name"
                    class="w-32 h-32 rounded-full mx-auto object-cover border-4 border-slate-700 group-hover:scale-105 transition-transform duration-300"
                  />
                  <div
                    class="absolute inset-0 rounded-full bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
                  ></div>
                </div>
                <h3 class="text-xl font-medium text-white mb-2">
                  {{ member.name }}
                </h3>
                <p class="text-slate-400 font-medium mb-3">{{ member.role }}</p>
                <p class="text-slate-300 text-sm leading-relaxed">
                  {{ member.bio }}
                </p>
              </div>
            </div>
          </div>

          <!-- Values -->
          <div class="bg-slate-800 rounded-lg p-8 md:p-12 mb-12">
            <h2
              class="text-3xl md:text-4xl font-light text-white mb-8 text-center"
            >
              我们的价值观
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div
                v-for="value in values"
                :key="value.id"
                class="flex items-start space-x-4"
              >
                <div
                  class="w-12 h-12 bg-slate-700 rounded-lg flex items-center justify-center flex-shrink-0"
                >
                  <UIcon :name="value.icon" class="w-6 h-6 text-white" />
                </div>
                <div>
                  <h3 class="text-xl font-medium text-white mb-2">
                    {{ value.title }}
                  </h3>
                  <p class="text-slate-300 leading-relaxed">
                    {{ value.description }}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Contact -->
          <div class="bg-slate-800 rounded-lg p-8 md:p-12">
            <h2
              class="text-3xl md:text-4xl font-light text-white mb-8 text-center"
            >
              联系我们
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div>
                <h3 class="text-xl font-medium text-white mb-4">联系方式</h3>
                <div class="space-y-4">
                  <div class="flex items-center space-x-3">
                    <UIcon
                      name="i-heroicons-envelope"
                      class="w-5 h-5 text-slate-400"
                    />
                    <span class="text-slate-300">contact@example.com</span>
                  </div>
                  <div class="flex items-center space-x-3">
                    <UIcon
                      name="i-heroicons-phone"
                      class="w-5 h-5 text-slate-400"
                    />
                    <span class="text-slate-300">+86 123 4567 8900</span>
                  </div>
                  <div class="flex items-center space-x-3">
                    <UIcon
                      name="i-heroicons-map-pin"
                      class="w-5 h-5 text-slate-400"
                    />
                    <span class="text-slate-300">北京市朝阳区</span>
                  </div>
                </div>
              </div>
              <div>
                <h3 class="text-xl font-medium text-white mb-4">关注我们</h3>
                <div class="flex space-x-4">
                  <UButton
                    v-for="social in socialLinks"
                    :key="social.name"
                    color="neutral"
                    variant="ghost"
                    :icon="social.icon"
                    class="w-12 h-12 text-white hover:bg-white/10"
                  />
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
  interface TeamMember {
    id: number
    name: string
    role: string
    bio: string
    avatar: string
  }

  interface Value {
    id: number
    title: string
    description: string
    icon: string
  }

  interface SocialLink {
    name: string
    icon: string
    color: string
  }

  // 团队成员数据
  const teamMembers: TeamMember[] = [
    {
      id: 1,
      name: '张三',
      role: '前端架构师',
      bio: '专注于 Vue.js 和 Nuxt.js 开发，拥有 5 年以上的前端开发经验。',
      avatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
    },
    {
      id: 2,
      name: '李四',
      role: 'UI/UX 设计师',
      bio: '热爱设计，专注于用户体验设计，致力于创造美观且实用的界面。',
      avatar:
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=200&h=200&fit=crop&crop=face',
    },
    {
      id: 3,
      name: '王五',
      role: '全栈开发者',
      bio: '技术全才，从前端到后端都有丰富的经验，喜欢分享技术心得。',
      avatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
    },
  ]

  // 价值观数据
  const values: Value[] = [
    {
      id: 1,
      title: '质量至上',
      description:
        '我们坚持输出高质量的内容，确保每一篇文章都有价值，能够帮助读者解决问题。',
      icon: 'i-heroicons-star',
    },
    {
      id: 2,
      title: '持续学习',
      description:
        '技术发展日新月异，我们始终保持学习的心态，分享最新的技术趋势和最佳实践。',
      icon: 'i-heroicons-academic-cap',
    },
    {
      id: 3,
      title: '开放分享',
      description:
        '我们相信知识的力量，鼓励团队成员和社区成员分享经验，共同成长。',
      icon: 'i-heroicons-heart',
    },
    {
      id: 4,
      title: '用户至上',
      description: '我们始终以用户需求为中心，提供优质的用户体验和实用的内容。',
      icon: 'i-heroicons-users',
    },
  ]

  // 社交媒体链接
  const socialLinks: SocialLink[] = [
    { name: 'github', icon: 'i-simple-icons-github', color: 'gray' },
    { name: 'twitter', icon: 'i-simple-icons-twitter', color: 'blue' },
    { name: 'linkedin', icon: 'i-simple-icons-linkedin', color: 'blue' },
    { name: 'wechat', icon: 'i-simple-icons-wechat', color: 'green' },
  ]

  // 设置页面元信息
  useHead({
    title: '关于我们',
    meta: [{ name: 'description', content: '了解我们的团队、使命和价值观' }],
  })
</script>
