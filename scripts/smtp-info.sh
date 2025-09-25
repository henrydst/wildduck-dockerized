#!/bin/bash

# SMTP服务器信息查看脚本
DOMAIN="nurokmail.com"
SERVER_IP="98.89.220.169"

echo "=== SMTP服务器配置信息 ==="
echo "域名: $DOMAIN"
echo "服务器IP: $SERVER_IP"
echo ""

# 1. 检查SMTP服务状态
echo "1. SMTP服务状态:"
echo "Haraka SMTP: $(docker ps --format '{{.Status}}' --filter name=haraka)"
echo "Traefik代理: $(docker ps --format '{{.Status}}' --filter name=traefik)"

echo ""

# 2. 检查SMTP端口
echo "2. SMTP端口状态:"
echo "SMTP (25): $(nc -z localhost 25 && echo '✅ 正常' || echo '❌ 异常')"
echo "SMTP SSL (465): $(nc -z localhost 465 && echo '✅ 正常' || echo '❌ 异常')"
echo "IMAP SSL (993): $(nc -z localhost 993 && echo '✅ 正常' || echo '❌ 异常')"
echo "POP3 SSL (995): $(nc -z localhost 995 && echo '✅ 正常' || echo '❌ 异常')"

echo ""

# 3. 测试SMTP连接
echo "3. SMTP连接测试:"
echo "测试SMTP连接 (端口25):"
timeout 5 telnet localhost 25 << EOF
QUIT
EOF

echo ""
echo "测试SMTP SSL连接 (端口465):"
timeout 5 openssl s_client -connect localhost:465 -quiet << EOF
QUIT
EOF

echo ""

# 4. 显示SMTP配置信息
echo "4. SMTP服务器配置:"
echo "服务器地址: $DOMAIN"
echo "SMTP端口: 25 (明文), 465 (SSL)"
echo "IMAP端口: 993 (SSL)"
echo "POP3端口: 995 (SSL)"
echo ""

# 5. 邮件客户端配置示例
echo "5. 邮件客户端配置示例:"
echo ""
echo "📧 发送邮件 (SMTP):"
echo "  服务器: $DOMAIN"
echo "  端口: 25 或 465"
echo "  加密: STARTTLS 或 SSL/TLS"
echo "  认证: 是"
echo ""
echo "📥 接收邮件 (IMAP):"
echo "  服务器: $DOMAIN"
echo "  端口: 993"
echo "  加密: SSL/TLS"
echo "  认证: 是"
echo ""
echo "📥 接收邮件 (POP3):"
echo "  服务器: $DOMAIN"
echo "  端口: 995"
echo "  加密: SSL/TLS"
echo "  认证: 是"

echo ""

# 6. 检查SMTP日志
echo "6. SMTP服务日志 (最近5行):"
echo "Haraka日志:"
docker logs config-generated-haraka-1 --tail 5

echo ""
echo "=== SMTP配置完成 ==="
echo ""
echo "💡 使用说明:"
echo "  - 端口25: 标准SMTP (推荐使用STARTTLS)"
echo "  - 端口465: SSL/TLS SMTP (推荐用于安全连接)"
echo "  - 端口993: IMAP SSL (接收邮件)"
echo "  - 端口995: POP3 SSL (接收邮件)"
