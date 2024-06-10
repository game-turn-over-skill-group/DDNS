@echo off
setlocal enabledelayedexpansion

REM 设置必要的环境变量 （包括黑括号一起删除 来填写对应内容）
set MAIL=【你的邮箱@gmail.com】
set ZONE=【You域名/区域 ZONE ID】
set PSWD=【You全球 Global APIKey】

REM 定义要更新的IPv4域名、记录ID和代理状态
set HOST_ipv4[0]=【你的IPV4域名 需要新增域名 则复制3行需要填写的参数 把0改成1、2、3以此类推】
set RECORD_ID_ipv4[0]=【使用[ddnsGetCloudfareURL-id.cmd]获取的域名专属记录ID】
set PROXIED_ipv4[0]=true【是否开启代理小云朵：true/false】

REM 定义要更新的IPv6域名、记录ID和代理状态 (这是一个ipv6实例 上面参考这里设置)
set HOST_ipv6[0]=bt1.rer.lol
set HOST_ipv6[1]=test.rer.lol
set RECORD_ID_ipv6[0]=6bd81r45451df4848d4a1356aa90e73
set RECORD_ID_ipv6[1]=6818d4aee8f848848d4aa848d4a946a
set PROXIED_ipv6[0]=false
set PROXIED_ipv6[1]=false

REM DNS服务器（这是一个无效参数 curl使用的是系统DNS）
set DNS_SERVER=1.0.0.1

REM 获取当前本地 IPv4 和 IPv6 地址
for /F %%a in ('curl -s "https://ipv4.ddnspod.com"') do set IPV4=%%a
for /F %%a in ('curl -s "https://ipv6.ddnspod.com"') do set IPV6=%%a
REM 获取网卡临时 IPv6 地址（看需求替换备注[::]掉上面ipv6地址获取,这是从系统网卡中获取临时IPV6地址）
::for /F %%a in ('ipconfig ^| grep "Temporary IPv6 Address" ^| awk -F ": " "{print $2}" ^| head -n 1') do set IPV6=%%a

REM 检查缓存文件是否存在，如果不存在则创建
set CACHE_FILE=%TEMP%\ddns_cache.txt
if not exist "%CACHE_FILE%" (
    echo.>"%CACHE_FILE%"
)

REM 初始化缓存文件内容
set LAST_IPv4=
set LAST_IPv6=

REM 读取缓存文件内容
for /F "tokens=1" %%i in (%CACHE_FILE%) do (
    if "!LAST_IPv4!" equ "" (
        set LAST_IPv4=%%i
    ) else (
        set LAST_IPv6=%%i
    )
)

REM 比较当前IPv4地址和缓存中的IPv4地址
if "%IPV4%" equ "%LAST_IPv4%" (
    echo IPv4 地址未变化，跳过更新
) else (
    REM 更新 IPv4 地址
    for /L %%i in (0, 1, 0) do (
        if defined HOST_ipv4[%%i] call :updateDNS "!HOST_ipv4[%%i]!" "!RECORD_ID_ipv4[%%i]!" "%IPV4%" "A" "!PROXIED_ipv4[%%i]!"
    )
)

REM 比较当前IPv6地址和缓存中的IPv6地址
if "%IPV6%" equ "%LAST_IPv6%" (
    echo IPv6 地址未变化，跳过更新
) else (
    REM 更新 IPv6 地址
    for /L %%i in (0, 1, 1) do (
        if defined HOST_ipv6[%%i] call :updateDNS "!HOST_ipv6[%%i]!" "!RECORD_ID_ipv6[%%i]!" "%IPV6%" "AAAA" "!PROXIED_ipv6[%%i]!"
    )
)

REM 更新缓存文件
echo %IPV4% > "%CACHE_FILE%"
echo %IPV6% >> "%CACHE_FILE%"

goto end

:updateDNS
setlocal enabledelayedexpansion
set HOST=%1
set RECORD_ID=%2
set IP=%3
set TYPE=%4
set PROXIED=%5

REM 查询 DNS 记录中的 IP 地址
for /F "tokens=2 delims=[]" %%b in ('nslookup %HOST% %DNS_SERVER% ^| findstr "Address"') do (
    set DNS_IP=%%b
    goto found
)
:found

REM 比较本地 IP 地址和 DNS 记录中的 IP 地址
if "%IP%" == "%DNS_IP%" (
    echo %HOST% IP 地址未变化，跳过更新
) else (
    echo %HOST% IP 地址已变化，准备更新

    REM 设置要更新的数据
    set DATA={\"type\":\"%TYPE%\",\"name\":\"%HOST%\",\"content\":\"%IP%\",\"ttl\":1,\"proxied\":%PROXIED%}

    REM 更新 DNS 记录
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/%ZONE%/dns_records/%RECORD_ID%" ^
        --header "X-Auth-Email: %MAIL%" ^
        --header "X-Auth-Key: %PSWD%" ^
        --header "Content-Type: application/json" ^
        --data "!DATA!"
    echo.
)

endlocal
goto :EOF

:end
endlocal

PAUSE
