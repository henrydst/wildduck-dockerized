#!/bin/bash

# 读取INBOX邮件的脚本
USER_ID="68d12dc0f7653bc66e11619d"
ACCESS_TOKEN="EqqZZYzks554Q5lhkhKj69l3aUNsYQ"
API_URL="http://127.0.0.1:8080"
MAILBOX_ID="68d12dc0f7653bc66e11619e"  # INBOX ID

echo "=== 读取INBOX邮件 ==="
echo "用户ID: $USER_ID"
echo "邮箱ID: $MAILBOX_ID"
echo ""

# 获取邮件列表
echo "1. 获取邮件列表..."
MESSAGES=$(curl -s -X GET "$API_URL/users/$USER_ID/mailboxes/$MAILBOX_ID/messages" \
-H 'Content-type: application/json' \
-H "X-Access-Token: $ACCESS_TOKEN")

echo "邮件列表:"
echo "$MESSAGES" | jq '.results[] | {id: .id, subject: .subject, from: .from, date: .date}' 2>/dev/null || echo "$MESSAGES"

echo ""
echo "2. 获取最新邮件的详细信息..."

# 获取最新邮件的ID
LATEST_MSG_ID=$(echo "$MESSAGES" | jq -r '.results[0].id' 2>/dev/null)

if [ "$LATEST_MSG_ID" != "null" ] && [ -n "$LATEST_MSG_ID" ]; then
    echo "最新邮件ID: $LATEST_MSG_ID"
    
    # 获取邮件详情
    echo ""
    echo "邮件详情:"
    curl -s -X GET "$API_URL/users/$USER_ID/mailboxes/$MAILBOX_ID/messages/$LATEST_MSG_ID" \
    -H 'Content-type: application/json' \
    -H "X-Access-Token: $ACCESS_TOKEN" | jq '.'
else
    echo "没有找到邮件"
fi

echo ""
echo "=== 完成 ==="
