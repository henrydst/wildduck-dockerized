#!/bin/bash

# 邮件服务器端口安全检查脚本
DOMAIN="nurokmail.com"
SERVER_IP="98.89.220.169"

echo "=== 邮件服务器端口安全检查 ==="
echo "域名: $DOMAIN"
echo "服务器IP: $SERVER_IP"
echo ""

# 1. 检查必要端口
echo "1. 必要邮件端口检查:"
echo "SMTP (25): $(nc -z $SERVER_IP 25 && echo '✅ 开放' || echo '❌ 关闭')"
echo "SMTP SSL (465): $(nc -z $SERVER_IP 465 && echo '✅ 开放' || echo '❌ 关闭')"
echo "IMAP SSL (993): $(nc -z $SERVER_IP 993 && echo '✅ 开放' || echo '❌ 关闭')"
echo "POP3 SSL (995): $(nc -z $SERVER_IP 995 && echo '✅ 开放' || echo '❌ 关闭')"

echo ""

# 2. 检查Web端口
echo "2. Web服务端口检查:"
echo "HTTP (80): $(nc -z $SERVER_IP 80 && echo '✅ 开放' || echo '❌ 关闭')"
echo "HTTPS (443): $(nc -z $SERVER_IP 443 && echo '✅ 开放' || echo '❌ 关闭')"

echo ""

# 3. 检查API端口
echo "3. API端口检查:"
echo "Wildduck API (8080): $(nc -z $SERVER_IP 8080 && echo '⚠️  开放 (建议关闭)' || echo '✅ 关闭 (安全)')"

echo ""

# 4. 端口安全建议
echo "4. 端口安全建议:"
echo ""
echo "✅ 必须开放的端口:"
echo "   - 端口25: SMTP (发送邮件)"
echo "   - 端口465: SMTP SSL (安全发送邮件)"
echo "   - 端口993: IMAP SSL (安全接收邮件)"
echo "   - 端口995: POP3 SSL (安全接收邮件)"
echo "   - 端口80: HTTP (Web界面)"
echo "   - 端口443: HTTPS (Web界面)"
echo ""
echo "❌ 建议关闭的端口:"
echo "   - 端口8080: Wildduck API (仅本地访问)"
echo ""
echo "🔒 安全配置建议:"
echo "   1. 使用防火墙限制访问"
echo "   2. 定期更新SSL证书"
echo "   3. 监控异常连接"
echo "   4. 使用强密码策略"

echo ""

# 5. 防火墙配置示例
echo "5. 防火墙配置示例 (UFW):"
echo ""
echo "# 允许邮件端口"
echo "sudo ufw allow 25/tcp"
echo "sudo ufw allow 465/tcp"
echo "sudo ufw allow 993/tcp"
echo "sudo ufw allow 995/tcp"
echo ""
echo "# 允许Web端口"
echo "sudo ufw allow 80/tcp"
echo "sudo ufw allow 443/tcp"
echo ""
echo "# 拒绝API端口 (仅本地访问)"
echo "sudo ufw deny 8080/tcp"

echo ""

# 6. 检查当前防火墙状态
echo "6. 当前防火墙状态:"
if command -v ufw &> /dev/null; then
    echo "UFW状态:"
    sudo ufw status 2>/dev/null || echo "UFW未安装或未配置"
else
    echo "UFW未安装"
fi

echo ""
echo "=== 安全检查完成 ==="
echo ""
echo "💡 重要提示:"
echo "   - 邮件端口 (25, 465, 993, 995) 必须对外开放"
echo "   - Web端口 (80, 443) 必须对外开放"
echo "   - API端口 (8080) 建议仅本地访问"
echo "   - 定期检查端口安全状态"
