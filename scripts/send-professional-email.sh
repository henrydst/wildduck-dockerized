#!/bin/bash

# 发送专业邮件的脚本 - 提高送达率
to_mail_address=$1

if [ -z "$to_mail_address" ]; then
    echo "用法: $0 <邮箱地址>"
    echo "示例: $0 your-email@gmail.com"
    exit 1
fi

USER_ID="68d12dc0f7653bc66e11619d"
ACCESS_TOKEN="EqqZZYzks554Q5lhkhKj69l3aUNsYQ"
API_URL="http://127.0.0.1:8080"

echo "发送专业邮件到: $to_mail_address"
echo ""

# 发送专业格式的邮件
CURRENT_TIME=$(date)
curl -X POST "$API_URL/users/$USER_ID/submit" \
-H 'Content-Type: application/json' \
-H "X-Access-Token: $ACCESS_TOKEN" \
-d "{
  \"from\": {
    \"name\": \"Nurok Mail System\",
    \"address\": \"noreply@nurokmail.com\"
  },
  \"to\": [{
    \"name\": \"Valued Customer\",
    \"address\": \"$to_mail_address\"
  }],
  \"subject\": \"Welcome to Nurok Mail Service - Professional Email Test\",
  \"text\": \"Dear Valued Customer,\\n\\nThis is a professional email from Nurok Mail Service to test our email delivery system.\\n\\nOur mail server is properly configured with:\\n- SPF records for authentication\\n- DKIM signatures for security\\n- DMARC policies for protection\\n\\nIf you receive this email, it confirms that our mail system is working correctly.\\n\\nBest regards,\\nNurok Mail Team\\n\\nSent at: $CURRENT_TIME\\nServer: nurokmail.com\",
  \"html\": \"<html><body><h2>Welcome to Nurok Mail Service</h2><p>Dear Valued Customer,</p><p>This is a professional email from Nurok Mail Service to test our email delivery system.</p><p>Our mail server is properly configured with:</p><ul><li>SPF records for authentication</li><li>DKIM signatures for security</li><li>DMARC policies for protection</li></ul><p>If you receive this email, it confirms that our mail system is working correctly.</p><p>Best regards,<br>Nurok Mail Team</p><hr><p><small>Sent at: $CURRENT_TIME<br>Server: nurokmail.com</small></p></body></html>\"
}"

echo ""
echo "✅ 专业邮件已发送"
echo "📧 请检查收件箱（包括垃圾邮件文件夹）"
echo ""
echo "💡 提示："
echo "   - 如果邮件在垃圾邮件文件夹，请将其标记为'非垃圾邮件'"
echo "   - 将 noreply@nurokmail.com 添加到联系人列表"
echo "   - 回复邮件可以建立发件人声誉"
