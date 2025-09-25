#!/bin/bash

# 检查邮件发送状态的脚本
USER_ID="68d12dc0f7653bc66e11619d"
ACCESS_TOKEN="EqqZZYzks554Q5lhkhKj69l3aUNsYQ"
API_URL="http://nurokmail.com:8080"

echo "=== 邮件服务器状态检查 ==="
echo ""

# 1. 检查Docker容器状态
echo "1. Docker容器状态:"
docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(wildduck|haraka|traefik|mongo|redis)"

echo ""

# 2. 检查服务端口
echo "2. 服务端口检查:"
echo "SMTP (25): $(nc -z nurokmail.com 25 && echo '✅ 正常' || echo '❌ 异常')"
echo "IMAP (993): $(nc -z nurokmail.com 993 && echo '✅ 正常' || echo '❌ 异常')"
echo "POP3 (995): $(nc -z nurokmail.com 995 && echo '✅ 正常' || echo '❌ 异常')"
echo "HTTPS (443): $(nc -z nurokmail.com 443 && echo '✅ 正常' || echo '❌ 异常')"

echo ""

# 3. 检查DNS记录
echo "3. DNS记录检查:"
echo "A记录: $(dig +short nurokmail.com A)"
echo "MX记录: $(dig +short nurokmail.com MX)"
echo "SPF记录: $(dig +short nurokmail.com TXT | grep spf)"
echo "DKIM记录: $(dig +short wd2025._domainkey.nurokmail.com TXT | grep DKIM1)"
echo ""

# 4. 检查INBOX邮件
echo "4. INBOX邮件检查:"
MAILBOX_ID="68d12dc0f7653bc66e11619e"
MESSAGES=$(curl -s -X GET "$API_URL/users/$USER_ID/mailboxes/$MAILBOX_ID/messages" \
-H 'Content-type: application/json' \
-H "X-Access-Token: $ACCESS_TOKEN")

MSG_COUNT=$(echo "$MESSAGES" | jq '.results | length' 2>/dev/null || echo "0")
echo "INBOX邮件数量: $MSG_COUNT"

if [ "$MSG_COUNT" -gt 0 ]; then
    echo "最新邮件:"
    echo "$MESSAGES" | jq '.results[0] | {subject: .subject, from: .from, date: .date}' 2>/dev/null || echo "无法解析邮件信息"
fi

echo ""

# 5. 检查邮件队列
echo "5. 邮件队列检查:"
echo "Zone-MTA队列状态:"
docker logs config-generated-zonemta-1 --tail 5 | grep -E "(QUEUE|SENT|FAILED)" || echo "无队列信息"

echo ""
echo "=== 检查完成 ==="
echo ""
echo "💡 如果Gmail没有收到邮件，请检查："
echo "   1. Gmail的垃圾邮件文件夹"
echo "   2. Gmail的促销邮件文件夹"
echo "   3. 将发件人添加到联系人"
echo "   4. 尝试发送到其他邮箱服务"
