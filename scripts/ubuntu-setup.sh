#!/bin/bash

# Ubuntu 环境安装脚本
# 安装 Docker 和 Node.js，然后设置邮件服务器

set -e  # 遇到错误立即退出

echo "=== Ubuntu 环境邮件服务器安装脚本 ==="
echo "域名: nurokmail.com"
echo "服务器: nurokmail.com"
echo ""

# 更新系统包
echo "1. 更新系统包..."
sudo apt update && sudo apt upgrade -y

# 安装必要的依赖
echo "2. 安装必要的依赖..."
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    jq \
    openssl

# 安装 Docker
echo "3. 安装 Docker..."
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，开始安装..."
    
    # 添加 Docker 官方 GPG 密钥
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # 添加 Docker 仓库
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 更新包索引
    sudo apt update
    
    # 安装 Docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # 将当前用户添加到 docker 组
    sudo usermod -aG docker $USER
    
    echo "Docker 安装完成！"
else
    echo "Docker 已安装，跳过..."
fi

# 安装 Node.js
echo "4. 安装 Node.js..."
if ! command -v node &> /dev/null; then
    echo "Node.js 未安装，开始安装..."
    
    # 使用 NodeSource 仓库安装最新的 LTS 版本
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    
    echo "Node.js 安装完成！"
else
    echo "Node.js 已安装，跳过..."
fi

# 验证安装
echo "5. 验证安装..."
echo "Docker 版本:"
docker --version
echo "Docker Compose 版本:"
docker compose version
echo "Node.js 版本:"
node --version
echo "npm 版本:"
npm --version

# 检查 Docker 服务状态
echo "6. 检查 Docker 服务状态..."
if ! sudo systemctl is-active --quiet docker; then
    echo "启动 Docker 服务..."
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# 提示用户重新登录或重新加载组权限
echo ""
echo "=== 安装完成 ==="
echo ""
echo "重要提示："
echo "1. 请重新登录或运行以下命令以应用 Docker 组权限："
echo "   newgrp docker"
echo ""
echo "2. 或者重新启动终端会话"
echo ""
echo "3. 验证 Docker 权限："
echo "   docker run hello-world"
echo ""

# 询问是否继续设置邮件服务器
read -p "是否现在设置邮件服务器？(y/N): " setup_mail

if [[ $setup_mail =~ ^[Yy]$ ]]; then
    echo ""
    echo "=== 开始设置邮件服务器 ==="
    echo "域名: nurokmail.com"
    echo "服务器: nurokmail.com"
    echo ""
    
    # 检查是否在正确的目录
    if [ ! -f "setup.sh" ]; then
        echo "错误：未找到 setup.sh 文件"
        echo "请确保在 dev-wildduck-dockerized 目录中运行此脚本"
        exit 1
    fi
    
    # 运行邮件服务器设置脚本
    echo "运行邮件服务器设置脚本..."
    ./setup.sh nurokmail.com
    
    echo ""
    echo "=== 邮件服务器设置完成 ==="
    echo ""
    echo "下一步："
    echo "1. 配置 DNS 记录："
    echo "   - A 记录: nurokmail.com → 服务器IP"
    echo "   - MX 记录: nurokmail.com → nurokmail.com (优先级 10)"
    echo ""
    echo "2. 启动服务："
    echo "   cd config-generated"
    echo "   docker compose up -d"
    echo ""
    echo "3. 查看服务状态："
    echo "   docker compose ps"
    echo ""
else
    echo "邮件服务器设置已跳过"
    echo "稍后可以运行: ./setup.sh nurokmail.com"
fi

echo ""
echo "=== 脚本执行完成 ==="
