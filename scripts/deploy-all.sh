#!/bin/bash

# 一键部署脚本 - 构建、推送镜像并远程部署
# 使用方法: ./scripts/deploy-all.sh [服务器环境] [版本标签]
# 例如: ./scripts/deploy-all.sh production v1.2.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# 显示开始信息
show_start_info() {
    echo ""
    echo "=========================================="
    echo "    Nuxt 4博客项目一键部署脚本"
    echo "=========================================="
    echo ""
}

# 检查依赖
check_dependencies() {
    log_step "检查依赖..."
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装"
        exit 1
    fi
    
    # 检查jq
    if ! command -v jq &> /dev/null; then
        log_error "jq未安装，请先安装 jq"
        log_info "macOS: brew install jq"
        log_info "Ubuntu: sudo apt-get install jq"
        exit 1
    fi
    
    # 检查配置文件
    if [ ! -f "deploy.config.json" ]; then
        log_error "配置文件 deploy.config.json 不存在"
        log_info "请复制 deploy.config.example 为 deploy.config.json 并修改配置"
        exit 1
    fi
    
    log_success "依赖检查通过"
}

# 确认部署
confirm_deployment() {
    local environment=$1
    local version_tag=$2
    
    echo ""
    log_warning "即将开始部署，请确认以下信息："
    echo ""
    echo "部署环境: $environment"
    echo "版本标签: $version_tag"
    echo ""
    
    # 读取配置信息
    DOCKER_REGISTRY=$(jq -r '.docker.registry' deploy.config.json)
    IMAGE_NAME=$(jq -r '.docker.imageName' deploy.config.json)
    SERVER_HOST=$(jq -r ".servers.$environment.host" deploy.config.json)
    SERVER_USER=$(jq -r ".servers.$environment.user" deploy.config.json)
    
    echo "Docker镜像: $DOCKER_REGISTRY/$IMAGE_NAME:$version_tag"
    echo "目标服务器: $SERVER_USER@$SERVER_HOST"
    echo ""
    
    read -p "确认开始部署? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "部署已取消"
        exit 0
    fi
    
    echo ""
}

# 构建和推送镜像
build_and_push() {
    local environment=$1
    local version_tag=$2
    
    log_step "第一步：构建和推送Docker镜像"
    
    # 调用构建脚本
    if ./scripts/build-and-push.sh "$environment" "$version_tag"; then
        log_success "镜像构建和推送完成"
    else
        log_error "镜像构建和推送失败"
        exit 1
    fi
}

# 远程部署
remote_deploy() {
    local environment=$1
    local version_tag=$2
    
    log_step "第二步：远程部署到服务器"
    
    # 调用远程部署脚本
    if ./scripts/remote-deploy.sh "$environment" "$version_tag"; then
        log_success "远程部署完成"
    else
        log_error "远程部署失败"
        exit 1
    fi
}

# 显示完成信息
show_completion_info() {
    local environment=$1
    local version_tag=$2
    
    echo ""
    echo "=========================================="
    log_success "部署完成！"
    echo "=========================================="
    echo ""
    
    # 读取配置信息
    DOCKER_REGISTRY=$(jq -r '.docker.registry' deploy.config.json)
    IMAGE_NAME=$(jq -r '.docker.imageName' deploy.config.json)
    SERVER_HOST=$(jq -r ".servers.$environment.host" deploy.config.json)
    
    echo "=== 部署摘要 ==="
    echo "环境: $environment"
    echo "版本: $version_tag"
    echo "镜像: $DOCKER_REGISTRY/$IMAGE_NAME:$version_tag"
    echo "服务器: $SERVER_HOST"
    echo "应用地址: http://$SERVER_HOST:3000"
    echo ""
    
    echo "=== 验证部署 ==="
    echo "1. 访问应用: http://$SERVER_HOST:3000"
    echo "2. 检查容器状态: ssh $SERVER_USER@$SERVER_HOST 'docker ps'"
    echo "3. 查看应用日志: ssh $SERVER_USER@$SERVER_HOST 'docker logs nuxt-blog-app'"
    echo ""
    
    echo "=== 回滚命令 ==="
    echo "如需回滚到上一个版本，请执行："
    echo "./scripts/remote-deploy.sh $environment <previous-version>"
    echo ""
}

# 错误处理
handle_error() {
    log_error "部署过程中发生错误"
    log_info "请检查错误信息并修复后重试"
    log_info "如需帮助，请查看脚本帮助信息：./scripts/deploy-all.sh --help"
    exit 1
}

# 主函数
main() {
    local environment=${1:-production}
    local version_tag=$2
    
    # 设置错误处理
    trap handle_error ERR
    
    # 显示开始信息
    show_start_info
    
    # 检查依赖
    check_dependencies
    
    # 确认部署
    confirm_deployment "$environment" "$version_tag"
    
    # 构建和推送镜像
    build_and_push "$environment" "$version_tag"
    
    # 远程部署
    remote_deploy "$environment" "$version_tag"
    
    # 显示完成信息
    show_completion_info "$environment" "$version_tag"
}

# 脚本入口
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "一键部署脚本"
    echo ""
    echo "使用方法:"
    echo "  ./scripts/deploy-all.sh [服务器环境] [版本标签]"
    echo ""
    echo "参数:"
    echo "  服务器环境    部署环境 (production/staging)"
    echo "  版本标签      镜像版本标签 (默认: 配置文件中的tag)"
    echo ""
    echo "示例:"
    echo "  ./scripts/deploy-all.sh production"
    echo "  ./scripts/deploy-all.sh production v1.2.0"
    echo "  ./scripts/deploy-all.sh staging v1.2.0-beta"
    echo ""
    echo "部署流程:"
    echo "1. 检查依赖和配置"
    echo "2. 构建Docker镜像"
    echo "3. 推送镜像到Docker Hub"
    echo "4. 远程部署到服务器"
    echo "5. 健康检查和验证"
    echo ""
    exit 0
fi

# 执行主函数
main "$@" 