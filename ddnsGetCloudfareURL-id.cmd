@echo off

set MAIL=【你的邮箱@gmail.com】
set ZONE=【You域名/区域 ZONE ID】
set PSWD=【You全球 Global APIKey】

curl --header "X-Auth-Email: %MAIL%" --header "X-Auth-Key: %PSWD%" ^
"https://api.cloudflare.com/client/v4/zones/%ZONE%/dns_records"
