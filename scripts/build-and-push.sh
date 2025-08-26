#!/bin/bash

# 本地构建和推送Docker镜像脚本
# 使用方法: ./scripts/build-and-push.sh [环境名称] [版本标签]
# 例如: ./scripts/build-and-push.sh production v1.2.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查配置文件
check_config() {
    if [ ! -f "deploy.config.json" ]; then
        log_error "配置文件 deploy.config.json 不存在"
        log_info "请复制 deploy.config.example 为 deploy.config.json 并修改配置"
        exit 1
    fi
    
    # 检查jq是否安装
    if ! command -v jq &> /dev/null; then
        log_error "jq 未安装，请先安装 jq"
        log_info "macOS: brew install jq"
        log_info "Ubuntu: sudo apt-get install jq"
        exit 1
    fi
    
    log_success "配置文件检查通过"
}

# 读取配置
load_config() {
    local environment=$1
    
    # 读取Docker配置
    DOCKER_REGISTRY=$(jq -r '.docker.registry' deploy.config.json)
    IMAGE_NAME=$(jq -r '.docker.imageName' deploy.config.json)
    DEFAULT_TAG=$(jq -r '.docker.tag' deploy.config.json)
    
    # 检查配置是否有效
    if [ "$DOCKER_REGISTRY" = "null" ] || [ "$IMAGE_NAME" = "null" ]; then
        log_error "Docker配置无效，请检查 deploy.config.json"
        exit 1
    fi
    
    # 设置镜像标签
    IMAGE_TAG=${2:-$DEFAULT_TAG}
    FULL_IMAGE_NAME="$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
    
    log_info "Docker配置: $FULL_IMAGE_NAME"
}

# 检查Docker登录状态
check_docker_login() {
    log_info "检查Docker Hub登录状态..."
    
    if ! docker info | grep -q "Username"; then
        log_warning "未检测到Docker Hub登录"
        log_info "请先执行: docker login"
        read -p "是否现在登录Docker Hub? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker login
        else
            log_error "需要登录Docker Hub才能推送镜像"
            exit 1
        fi
    fi
    
    log_success "Docker Hub登录状态正常"
}

# 构建镜像
build_image() {
    local environment=$1
    
    log_info "开始构建Docker镜像..."
    log_info "镜像名称: $FULL_IMAGE_NAME"
    log_info "构建环境: $environment"
    
    # 设置构建参数
    BUILD_ARGS=""
    if [ "$environment" = "production" ]; then
        BUILD_ARGS="--build-arg NODE_ENV=production"
    fi
    
    # 构建镜像（指定平台为linux/amd64以确保兼容性）
    docker build --platform linux/amd64 -t "$FULL_IMAGE_NAME" $BUILD_ARGS .
    
    if [ $? -eq 0 ]; then
        log_success "Docker镜像构建成功"
    else
        log_error "Docker镜像构建失败"
        exit 1
    fi
}

# 推送镜像
push_image() {
    log_info "推送镜像到Docker Hub..."
    
    docker push "$FULL_IMAGE_NAME"
    
    if [ $? -eq 0 ]; then
        log_success "镜像推送成功"
        log_info "镜像地址: https://hub.docker.com/r/$DOCKER_REGISTRY/$IMAGE_NAME"
    else
        log_error "镜像推送失败"
        exit 1
    fi
}

# 清理本地镜像（可选）
cleanup_local_image() {
    read -p "是否删除本地镜像以节省空间? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "删除本地镜像..."
        docker rmi "$FULL_IMAGE_NAME"
        log_success "本地镜像已删除"
    fi
}

# 显示镜像信息
show_image_info() {
    log_success "构建和推送完成！"
    echo ""
    echo "=== 镜像信息 ==="
    echo "镜像名称: $FULL_IMAGE_NAME"
    echo "Docker Hub: https://hub.docker.com/r/$DOCKER_REGISTRY/$IMAGE_NAME"
    echo ""
    echo "=== 拉取命令 ==="
    echo "docker pull $FULL_IMAGE_NAME"
    echo ""
    echo "=== 运行命令 ==="
    echo "docker run -d -p 3000:3000 --name nuxt-blog-app $FULL_IMAGE_NAME"
    echo ""
}

# 主函数
main() {
    local environment=${1:-production}
    local version_tag=$2
    
    log_info "开始构建和推送Docker镜像"
    log_info "环境: $environment"
    log_info "版本: $version_tag"
    
    # 检查配置
    check_config
    
    # 读取配置
    load_config "$environment" "$version_tag"
    
    # 检查Docker登录
    check_docker_login
    
    # 构建镜像
    build_image "$environment"
    
    # 推送镜像
    push_image
    
    # 显示信息
    show_image_info
    
    # 清理本地镜像
    cleanup_local_image
}

# 脚本入口
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Docker镜像构建和推送脚本"
    echo ""
    echo "使用方法:"
    echo "  ./scripts/build-and-push.sh [环境名称] [版本标签]"
    echo ""
    echo "参数:"
    echo "  环境名称    构建环境 (默认: production)"
    echo "  版本标签    镜像版本标签 (默认: 配置文件中的tag)"
    echo ""
    echo "示例:"
    echo "  ./scripts/build-and-push.sh production"
    echo "  ./scripts/build-and-push.sh production v1.2.0"
    echo "  ./scripts/build-and-push.sh staging v1.2.0-beta"
    echo ""
    exit 0
fi

# 执行主函数
main "$@" 