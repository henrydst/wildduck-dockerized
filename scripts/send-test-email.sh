#!/bin/bash

# 发送测试邮件的脚本
USER_ID="68d12dc0f7653bc66e11619d"
ACCESS_TOKEN="EqqZZYzks554Q5lhkhKj69l3aUNsYQ"
API_URL="http://127.0.0.1:8080"

echo "发送测试邮件..."

# 发送邮件到外部邮箱（如Gmail）
CURRENT_TIME=$(date)
curl -X POST "$API_URL/users/$USER_ID/submit" \
-H 'Content-Type: application/json' \
-H "X-Access-Token: $ACCESS_TOKEN" \
-d "{
  \"from\": \"testuser@nurokmail.com\",
  \"to\": [\"rminer.z.c@gmail.com\"],
  \"subject\": \"Wildduck邮件服务器测试\",
  \"text\": \"这是一封来自Wildduck邮件服务器的测试邮件。\\n\\n如果您收到这封邮件，说明邮件服务器配置成功！\\n\\n发送时间: $CURRENT_TIME\"
}"

echo ""
echo "邮件发送完成！"
echo "请检查收件箱（包括垃圾邮件文件夹）"
