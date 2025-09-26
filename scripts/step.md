1. check cert file
    cert.sh
2. configure dns Records
   dns-records.txt 
3. open server port
    25 - SMTP (send mail)
    465 - SMTP SSL (safe send mail)
    993 - IMAP SSL (safe receive mail)
    995 - POP3 SSL (safe receive mail)

4. 启动
     ./setup.sh  nurokmail.com
5  停止
   docker compose -f docker-compose.yml down
