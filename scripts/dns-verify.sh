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

echo "6. 检查Reverse DNS记录..."
PTR_RECORD=$(dig +short -x $SERVER_IP)
if echo "$PTR_RECORD" | grep -q "$DOMAIN"; then
    echo "✅ Reverse DNS记录正确: $PTR_RECORD"
else
    echo "❌ Reverse DNS记录错误或未找到: $PTR_RECORD"
    echo "   期望: $DOMAIN"
fi
echo ""

echo "7. 检查SOA记录和Serial Number格式..."
SOA_RECORD=$(dig +short $DOMAIN SOA)
if [ -n "$SOA_RECORD" ]; then
    # 提取serial number (SOA记录的第3个字段)
    SERIAL_NUMBER=$(echo "$SOA_RECORD" | awk '{print $3}')
    echo "SOA记录: $SOA_RECORD"
    echo "Serial Number: $SERIAL_NUMBER"
    
    # 检查serial number格式 (应该是10位数字，格式: YYYYMMDDNN)
    if echo "$SERIAL_NUMBER" | grep -qE '^[0-9]{10}$'; then
        # 进一步验证日期部分是否合理
        YEAR=$(echo "$SERIAL_NUMBER" | cut -c1-4)
        MONTH=$(echo "$SERIAL_NUMBER" | cut -c5-6)
        DAY=$(echo "$SERIAL_NUMBER" | cut -c7-8)
        SEQ=$(echo "$SERIAL_NUMBER" | cut -c9-10)
        
        if [ "$YEAR" -ge 2020 ] && [ "$YEAR" -le 2030 ] && [ "$MONTH" -ge 1 ] && [ "$MONTH" -le 12 ] && [ "$DAY" -ge 1 ] && [ "$DAY" -le 31 ] && [ "$SEQ" -ge 0 ] && [ "$SEQ" -le 99 ]; then
            echo "✅ SOA Serial Number格式正确: $SERIAL_NUMBER"
        else
            echo "❌ SOA Serial Number格式可能有问题: $SERIAL_NUMBER"
            echo "   建议格式: YYYYMMDDNN (例如: 2025010101)"
        fi
    else
        echo "❌ SOA Serial Number格式无效: $SERIAL_NUMBER"
        echo "   期望格式: 10位数字 YYYYMMDDNN (例如: 2025010101)"
    fi
else
    echo "❌ SOA记录未找到"
fi
echo ""

echo "8. 检查Reverse DNS与SMTP Banner匹配..."
# 获取Reverse DNS记录
PTR_RECORD=$(dig +short -x $SERVER_IP | head -1)
if [ -n "$PTR_RECORD" ]; then
    # 移除末尾的点
    PTR_RECORD_CLEAN=$(echo "$PTR_RECORD" | sed 's/\.$//')
    echo "Reverse DNS记录: $PTR_RECORD_CLEAN"
    
    # 尝试连接SMTP服务器并获取banner
    echo "正在连接SMTP服务器获取banner..."
    SMTP_BANNER=$(timeout 10 telnet $SERVER_IP 25 2>/dev/null | head -1 | grep -o '[a-zA-Z0-9.-]*' | head -1)
    
    if [ -n "$SMTP_BANNER" ]; then
        echo "SMTP Banner: $SMTP_BANNER"
        
        # 检查是否匹配
        if [ "$PTR_RECORD_CLEAN" = "$SMTP_BANNER" ]; then
            echo "✅ Reverse DNS与SMTP Banner匹配"
        else
            echo "❌ Reverse DNS与SMTP Banner不匹配"
            echo "   Reverse DNS: $PTR_RECORD_CLEAN"
            echo "   SMTP Banner: $SMTP_BANNER"
            echo "   建议: 确保SMTP服务器配置的hostname与Reverse DNS记录一致"
        fi
    else
        echo "⚠️  无法获取SMTP Banner (可能SMTP服务未运行或端口25被阻止)"
        echo "   Reverse DNS记录: $PTR_RECORD_CLEAN"
        echo "   请手动检查SMTP服务器配置"
    fi
else
    echo "❌ 无法获取Reverse DNS记录，无法进行匹配检查"
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
