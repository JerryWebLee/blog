#!/bin/bash

# 远程部署脚本 - 通过SSH在云服务器上部署应用
# 使用方法: ./scripts/remote-deploy.sh [服务器环境] [镜像标签]
# 例如: ./scripts/remote-deploy.sh production latest

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

# 读取服务器配置
load_server_config() {
    local environment=$1
    
    # 读取服务器配置
    SERVER_HOST=$(jq -r ".servers.$environment.host" deploy.config.json)
    SERVER_USER=$(jq -r ".servers.$environment.user" deploy.config.json)
    SERVER_PORT=$(jq -r ".servers.$environment.port" deploy.config.json)
    DEPLOY_PATH=$(jq -r ".servers.$environment.deployPath" deploy.config.json)
    DOCKER_COMPOSE_FILE=$(jq -r ".servers.$environment.dockerComposeFile" deploy.config.json)
    APP_PORT=$(jq -r ".app.port" deploy.config.json)

    
    # 读取Docker配置
    DOCKER_REGISTRY=$(jq -r '.docker.registry' deploy.config.json)
    IMAGE_NAME=$(jq -r '.docker.imageName' deploy.config.json)
    
    # 检查配置是否有效
    if [ "$SERVER_HOST" = "null" ] || [ "$SERVER_USER" = "null" ]; then
        log_error "服务器配置无效，请检查 deploy.config.json 中的 servers.$environment 配置"
        exit 1
    fi
    
    # 设置镜像标签
    IMAGE_TAG=${2:-$(jq -r '.docker.tag' deploy.config.json)}
    FULL_IMAGE_NAME="$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
    
    log_info "服务器配置: $SERVER_USER@$SERVER_HOST:$SERVER_PORT"
    log_info "部署路径: $DEPLOY_PATH"
    log_info "镜像名称: $FULL_IMAGE_NAME"
}

# 测试SSH连接
test_ssh_connection() {
    log_info "测试SSH连接..."
    
    if ssh -o ConnectTimeout=10 -o BatchMode=yes -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "echo 'SSH连接成功'" 2>/dev/null; then
        log_success "SSH连接正常"
    else
        log_error "SSH连接失败，请检查："
        log_error "1. 服务器IP地址是否正确"
        log_error "2. 用户名是否正确"
        log_error "3. SSH免密登录是否配置"
        log_error "4. 防火墙是否开放SSH端口"
        exit 1
    fi
}

# 检查服务器Docker环境
check_server_docker() {
    log_info "检查服务器Docker环境..."
    
    # 检查Docker是否安装
    if ! ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "command -v docker &> /dev/null"; then
        log_error "服务器未安装Docker"
        exit 1
    fi
    
    # 检查Docker Compose是否安装
    if ! ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "command -v docker compose &> /dev/null"; then
        log_error "服务器未安装Docker Compose"
        exit 1
    fi
    
    # 检查Docker服务是否运行
    if ! ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "docker info &> /dev/null"; then
        log_error "Docker服务未运行"
        exit 1
    fi
    
    # 检查用户权限
    if ! ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "docker ps &> /dev/null"; then
        log_warning "用户可能没有Docker权限，尝试添加到docker组"
        ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "sudo usermod -aG docker $SERVER_USER" || true
        log_info "请重新登录服务器或重启Docker服务"
    fi
    
    log_success "服务器Docker环境检查通过"
}

# 创建部署目录
create_deploy_directory() {
    log_info "创建部署目录..."
    
    # 创建目录并设置正确的权限
    ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "sudo mkdir -p $DEPLOY_PATH && sudo chmod 755 $DEPLOY_PATH"
    
    if [ $? -eq 0 ]; then
        log_success "部署目录创建成功"
    else
        log_error "部署目录创建失败"
        exit 1
    fi
}

# 上传docker-compose文件
upload_docker_compose() {
    log_info "上传docker-compose配置文件..."
    
    # 创建临时文件
    cat > /tmp/docker-compose.tmp << EOF
version: '3.8'

services:
  nuxt-blog:
    image: $FULL_IMAGE_NAME
    container_name: nuxt-blog-app
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      NUXT_HOST: 0.0.0.0
      NUXT_PORT: 3000
      APP_NAME: "Nuxt Blog"
      APP_VERSION: "$IMAGE_TAG"
      DEBUG: "false"
      LOG_LEVEL: "info"
      API_BASE_URL: \${API_BASE_URL:-}
      API_TIMEOUT: \${API_TIMEOUT:-10000}
      DATABASE_URL: \${DATABASE_URL:-}
      JWT_SECRET: \${JWT_SECRET:-}
      NITRO_PORT: 3000
      NITRO_HOST: 0.0.0.0
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:3000/api/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
        reservations:
          memory: 256M
          cpus: '0.25'
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - nuxt-network

networks:
  nuxt-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
EOF
    
    # 上传文件到临时位置，然后移动到目标位置
    scp -P "$SERVER_PORT" /tmp/docker-compose.tmp "$SERVER_USER@$SERVER_HOST:/tmp/docker-compose.tmp"
    
    if [ $? -eq 0 ]; then
        # 移动到目标位置并设置权限
        ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "sudo mv /tmp/docker-compose.tmp $DEPLOY_PATH/docker-compose.yml && sudo chmod 644 $DEPLOY_PATH/docker-compose.yml"
        
        if [ $? -eq 0 ]; then
            log_success "docker-compose文件上传成功"
        else
            log_error "docker-compose文件移动失败"
            exit 1
        fi
    else
        log_error "docker-compose文件上传失败"
        exit 1
    fi
    
    # 清理本地临时文件
    rm /tmp/docker-compose.tmp
}

# 停止旧容器
stop_old_container() {
    log_info "停止旧容器..."
    
    ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "cd $DEPLOY_PATH && docker compose down --remove-orphans" || true
    
    log_success "旧容器已停止"
}

# 拉取新镜像
pull_new_image() {
    log_info "拉取新镜像..."
    
    ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "docker pull $FULL_IMAGE_NAME"
    
    if [ $? -eq 0 ]; then
        log_success "新镜像拉取成功"
    else
        log_error "新镜像拉取失败"
        exit 1
    fi
}

# 启动新容器
start_new_container() {
    log_info "启动新容器..."
    
    ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "cd $DEPLOY_PATH && docker compose up -d"
    
    if [ $? -eq 0 ]; then
        log_success "新容器启动成功"
    else
        log_error "新容器启动失败"
        exit 1
    fi
}

# 健康检查
health_check() {
    log_info "执行健康检查..."
    
    # 等待服务启动
    sleep 10
    
    # 检查容器状态
    if ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "docker ps --filter 'name=nuxt-blog-app' --filter 'status=running' | grep -q nuxt-blog-app"; then
        log_success "容器运行正常"
    else
        log_error "容器未正常运行"
        ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "docker logs nuxt-blog-app"
        exit 1
    fi
    
    # 检查应用响应
    if ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "curl -f http://localhost:3000 > /dev/null 2>&1"; then
        log_success "应用响应正常"
    else
        log_warning "应用响应检查失败，请手动验证"
    fi
}

# 清理旧镜像
cleanup_old_images() {
    log_info "清理旧镜像..."
    
    ssh -p "$SERVER_PORT" "$SERVER_USER@$SERVER_HOST" "docker image prune -f"
    
    log_success "旧镜像清理完成"
}

# 显示部署信息
show_deployment_info() {
    log_success "远程部署完成！"
    echo ""
    echo "=== 部署信息 ==="
    echo "服务器: $SERVER_USER@$SERVER_HOST:$SERVER_PORT"
    echo "部署路径: $DEPLOY_PATH"
    echo "应用地址: http://$SERVER_HOST:3000"
    echo "镜像名称: $FULL_IMAGE_NAME"
    echo ""
    echo "=== 常用命令 ==="
    echo "查看日志: ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST 'docker logs nuxt-blog-app'"
    echo "停止服务: ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST 'cd $DEPLOY_PATH && docker compose down'"
    echo "重启服务: ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST 'cd $DEPLOY_PATH && docker compose restart'"
    echo "查看状态: ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST 'cd $DEPLOY_PATH && docker compose ps'"
    echo ""
}

# 主函数
main() {
    local environment=${1:-production}
    local image_tag=$2
    
    log_info "开始远程部署"
    log_info "环境: $environment"
    log_info "镜像标签: $image_tag"
    
    # 检查配置
    check_config
    
    # 读取服务器配置
    load_server_config "$environment" "$image_tag"
    
    # 测试SSH连接
    test_ssh_connection
    
    # 检查服务器Docker环境
    check_server_docker
    
    # 创建部署目录
    create_deploy_directory
    
    # 上传docker-compose文件
    upload_docker_compose
    
    # 停止旧容器
    stop_old_container
    
    # 拉取新镜像
    pull_new_image
    
    # 启动新容器
    start_new_container
    
    # 健康检查
    health_check
    
    # 清理旧镜像
    cleanup_old_images
    
    # 显示部署信息
    show_deployment_info
}

# 脚本入口
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "远程部署脚本"
    echo ""
    echo "使用方法:"
    echo "  ./scripts/remote-deploy.sh [服务器环境] [镜像标签]"
    echo ""
    echo "参数:"
    echo "  服务器环境    部署环境 (production/staging)"
    echo "  镜像标签      镜像版本标签 (默认: 配置文件中的tag)"
    echo ""
    echo "示例:"
    echo "  ./scripts/remote-deploy.sh production"
    echo "  ./scripts/remote-deploy.sh production v1.2.0"
    echo "  ./scripts/remote-deploy.sh staging v1.2.0-beta"
    echo ""
    exit 0
fi

# 执行主函数
main "$@" 