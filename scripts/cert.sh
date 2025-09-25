#!/bin/bash

# 检查服务器使用的证书
openssl s_client -connect nurokmail.com:443 -showcerts

# 拼成完整证书链 /config-generated/certs/
cat nurokmail.com.pem rootCA.pem > fullchain.pem

# 提取DKIM公钥
openssl rsa -in /root/henry/wildduck-dockerized/config-generated/config-generated/nurokmail.com-dkim.pem -pubout -outform DER | openssl base64 -A