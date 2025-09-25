1.  run ubuntu-setup.sh
2.  run setup.sh nurokmail.com
3.  run test
 
    telnet 127.0.0.1 25
    curl -I http://127.0.0.1:8080

    # find the accessToken in the config-generated
    find /root -name "*.toml" -path "*/config-generated/*" -exec grep -l "accessToken" {} \;
    cat /root/henry/wildduck-dockerized/config-generated/config-generated/wildduck/api.toml
    curl -X POST http://127.0.0.1:8080/users -H 'Content-type: application/json' -H 'X-Access-Token: EqqZZYzks554Q5lhkhKj69l3aUNsYQ' -d '{"username": "testuser2", "password": "testpass123", "address": "testuser2@nurokmail.com"}'
    
    testuser:   68d12dc0f7653bc66e11619d
    testuser2 : 68d4c1c4f7653bc66e1161b3
    
    curl -X GET http://127.0.0.1:8080/addresses -H 'Content-type: application/json' -H 'X-Access-Token: EqqZZYzks554Q5lhkhKj69l3aUNsYQ'
    curl -X GET "http://127.0.0.1:8080/users/68d12dc0f7653bc66e11619d/mailboxes" -H 'Content-type: application/json' -H 'X-Access-Token: EqqZZYzks554Q5lhkhKj69l3aUNsYQ'
    curl -X GET "http://127.0.0.1:8080/users/68d4c1c4f7653bc66e1161b3/mailboxes" -H 'Content-type: application/json' -H 'X-Access-Token: EqqZZYzks554Q5lhkhKj69l3aUNsYQ'

    #读取邮件
    curl -X GET "http://127.0.0.1:8080/users/68d12dc0f7653bc66e11619d/mailboxes/68d12dc0f7653bc66e11619e/messages" -H 'Content-type: application/json' -H 'X-Access-Token: EqqZZYzks554Q5lhkhKj69l3aUNsYQ'

