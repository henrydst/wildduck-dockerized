#!/bin/bash

# DNS验证脚本
# 验证nurokmail.com的DNS记录配置

DOMAIN="nurokmail.com"
DKIM_SELECTOR="wd2025"
SERVER_IP="98.89.220.169"

echo "=== DNS记录验证脚本 ==="
echo "域名: $DOMAIN"
echo "服务器IP: $SERVER_IP"
echo ""

# 检查dig命令是否可用
if ! command -v dig &> /dev/null; then
    echo "错误: dig命令未找到，请安装dnsutils包"
    echo "Ubuntu/Debian: sudo apt-get install dnsutils"
    echo "CentOS/RHEL: sudo yum install bind-utils"
    exit 1
fi

echo "1. 检查A记录..."
A_RECORD=$(dig +short $DOMAIN A)
if [ "$A_RECORD" = "$SERVER_IP" ]; then
    echo "✅ A记录正确: $A_RECORD"
else
    echo "❌ A记录错误: 期望 $SERVER_IP，实际 $A_RECORD"
fi
echo ""

echo "2. 检查MX记录..."
MX_RECORD=$(dig +short $DOMAIN MX)
if echo "$MX_RECORD" | grep -q "$DOMAIN"; then
    echo "✅ MX记录存在: $MX_RECORD"
else
    echo "❌ MX记录未找到或配置错误"
fi
echo ""

echo "3. 检查SPF记录..."
SPF_RECORD=$(dig +short $DOMAIN TXT | grep "v=spf1")
if echo "$SPF_RECORD" | grep -q "ip4:$SERVER_IP"; then
    echo "✅ SPF记录正确: $SPF_RECORD"
else
    echo "❌ SPF记录错误或未找到: $SPF_RECORD"
fi
echo ""

echo "4. 检查DKIM记录..."
DKIM_RECORD=$(dig +short $DKIM_SELECTOR._domainkey.$DOMAIN TXT)
if echo "$DKIM_RECORD" | grep -q "v=DKIM1"; then
    echo "✅ DKIM记录存在: $DKIM_RECORD"
else
    echo "❌ DKIM记录未找到或配置错误"
fi
echo ""

echo "5. 检查DMARC记录..."
DMARC_RECORD=$(dig +short _dmarc.$DOMAIN TXT)
if echo "$DMARC_RECORD" | grep -q "v=DMARC1"; then
    echo "✅ DMARC记录存在: $DMARC_RECORD"
else
    echo "❌ DMARC记录未找到或配置错误"
fi
echo ""

echo "=== 验证完成 ==="
echo ""
echo "如果所有记录都显示✅，说明DNS配置正确"
echo "如果有❌，请检查DNS配置并等待传播"
echo ""
echo "DNS传播时间: 5分钟到24小时"
echo "可以使用以下命令重新验证:"
echo "  ./scripts/dns-verify.sh"
