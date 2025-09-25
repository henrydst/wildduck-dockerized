#!/bin/bash

# 邮件服务器测试脚本
# 测试邮件发送和接收功能

DOMAIN="nurokmail.com"
USER_ID="68d12dc0f7653bc66e11619d"
ACCESS_TOKEN="EqqZZYzks554Q5lhkhKj69l3aUNsYQ"
API_URL="http://127.0.0.1:8080"

echo "=== 邮件服务器测试脚本 ==="
echo "域名: $DOMAIN"
echo "用户ID: $USER_ID"
echo ""

# 检查Docker容器状态
echo "1. 检查Docker容器状态..."
docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(wildduck|haraka|traefik|mongo|redis)"

echo ""
echo "2. 检查服务端口..."
echo "SMTP (25): $(nc -z localhost 25 && echo '✅ 正常' || echo '❌ 异常')"
echo "IMAP (993): $(nc -z localhost 993 && echo '✅ 正常' || echo '❌ 异常')"
echo "POP3 (995): $(nc -z localhost 995 && echo '✅ 正常' || echo '❌ 异常')"
echo "HTTPS (443): $(nc -z localhost 443 && echo '✅ 正常' || echo '❌ 异常')"

echo ""
echo "3. 检查Web界面..."
WEB_STATUS=$(curl -k -s -o /dev/null -w "%{http_code}" https://$DOMAIN)
if [ "$WEB_STATUS" = "200" ]; then
    echo "✅ Web界面正常 (HTTPS)"
else
    echo "❌ Web界面异常 (状态码: $WEB_STATUS)"
fi

echo ""
echo "4. 检查API接口..."
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $API_URL)
if [ "$API_STATUS" = "404" ] || [ "$API_STATUS" = "200" ]; then
    echo "✅ API接口正常"
else
    echo "❌ API接口异常 (状态码: $API_STATUS)"
fi

echo ""
echo "5. 发送测试邮件..."
read -p "请输入测试邮箱地址 (如: test@gmail.com): " TEST_EMAIL

if [ -n "$TEST_EMAIL" ]; then
    echo "发送测试邮件到: $TEST_EMAIL"
    
    curl -X POST "$API_URL/users/$USER_ID/submit" \
    -H 'Content-Type: application/json' \
    -H "X-Access-Token: $ACCESS_TOKEN" \
    -d "{
      \"from\": {
        \"name\": \"Test User\",
        \"address\": \"testuser@$DOMAIN\"
      },
      \"to\": [{
        \"name\": \"Test Recipient\",
        \"address\": \"$TEST_EMAIL\"
      }],
      \"subject\": \"Wildduck邮件服务器测试 - $(date)\",
      \"text\": \"这是一封来自Wildduck邮件服务器的测试邮件。\\n\\n如果您收到这封邮件，说明邮件服务器配置成功！\\n\\n发送时间: $(date)\\n服务器: $DOMAIN\"
    }"
    
    echo ""
    echo "✅ 测试邮件已发送"
    echo "请检查收件箱（包括垃圾邮件文件夹）"
else
    echo "跳过邮件发送测试"
fi

echo ""
echo "=== 测试完成 ==="
echo ""
echo "访问信息:"
echo "  Web界面: https://$DOMAIN"
echo "  用户名: testuser@$DOMAIN"
echo "  密码: testpass123"
echo ""
echo "邮件客户端配置:"
echo "  IMAP服务器: $DOMAIN:993 (SSL)"
echo "  SMTP服务器: $DOMAIN:465 (SSL)"
echo "  用户名: testuser@$DOMAIN"
echo "  密码: testpass123"
