#!/bin/bash

# 邮件服务端口协议检查脚本
DOMAIN="nurokmail.com"
SERVER_IP="98.89.220.169"

echo "=== 邮件服务端口协议检查 ==="
echo "域名: $DOMAIN"
echo "服务器IP: $SERVER_IP"
echo ""

# 1. 检查TCP端口
echo "1. TCP端口检查:"
echo "SMTP (25/TCP): $(nc -z $SERVER_IP 25 && echo '✅ 开放' || echo '❌ 关闭')"
echo "SMTP SSL (465/TCP): $(nc -z $SERVER_IP 465 && echo '✅ 开放' || echo '❌ 关闭')"
echo "IMAP SSL (993/TCP): $(nc -z $SERVER_IP 993 && echo '✅ 开放' || echo '❌ 关闭')"
echo "POP3 SSL (995/TCP): $(nc -z $SERVER_IP 995 && echo '✅ 开放' || echo '❌ 关闭')"

echo ""

# 2. 检查UDP端口 (应该关闭)
echo "2. UDP端口检查 (应该关闭):"
echo "SMTP (25/UDP): $(nc -u -z $SERVER_IP 25 && echo '⚠️  开放 (建议关闭)' || echo '✅ 关闭 (安全)')"
echo "SMTP SSL (465/UDP): $(nc -u -z $SERVER_IP 465 && echo '⚠️  开放 (建议关闭)' || echo '✅ 关闭 (安全)')"
echo "IMAP SSL (993/UDP): $(nc -u -z $SERVER_IP 993 && echo '⚠️  开放 (建议关闭)' || echo '✅ 关闭 (安全)')"
echo "POP3 SSL (995/UDP): $(nc -u -z $SERVER_IP 995 && echo '⚠️  开放 (建议关闭)' || echo '✅ 关闭 (安全)')"

echo ""

# 3. 协议说明
echo "3. 协议说明:"
echo ""
echo "📧 邮件服务协议:"
echo "   - SMTP (25): TCP - 发送邮件"
echo "   - SMTP SSL (465): TCP - 安全发送邮件"
echo "   - IMAP SSL (993): TCP - 安全接收邮件"
echo "   - POP3 SSL (995): TCP - 安全接收邮件"
echo ""
echo "🔒 为什么使用TCP:"
echo "   - 可靠传输: 确保邮件数据完整"
echo "   - 有序传输: 保证邮件内容顺序"
echo "   - 错误检测: 自动重传丢失数据"
echo "   - 连接导向: 建立稳定连接"
echo ""
echo "❌ 为什么不用UDP:"
echo "   - 不可靠: 可能丢失邮件数据"
echo "   - 无序: 邮件内容可能乱序"
echo "   - 无连接: 无法保证送达"

echo ""

# 4. 防火墙配置建议
echo "4. 防火墙配置建议:"
echo ""
echo "✅ 允许TCP端口:"
echo "   sudo ufw allow 25/tcp"
echo "   sudo ufw allow 465/tcp"
echo "   sudo ufw allow 993/tcp"
echo "   sudo ufw allow 995/tcp"
echo ""
echo "❌ 拒绝UDP端口:"
echo "   sudo ufw deny 25/udp"
echo "   sudo ufw deny 465/udp"
echo "   sudo ufw deny 993/udp"
echo "   sudo ufw deny 995/udp"

echo ""

# 5. 检查当前协议状态
echo "5. 当前协议状态:"
echo "TCP连接测试:"
timeout 3 telnet $SERVER_IP 25 << EOF
QUIT
EOF

echo ""
echo "=== 协议检查完成 ==="
echo ""
echo "💡 总结:"
echo "   - 所有邮件端口都使用TCP协议"
echo "   - TCP确保邮件传输的可靠性"
echo "   - UDP不适合邮件服务"
echo "   - 防火墙只需开放TCP端口"
