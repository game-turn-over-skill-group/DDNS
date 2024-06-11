

### 使用curl+batch更新cf-DDNS域名IP：

* curl-windows-download：https://curl.se/windows/
* python项目的证书验证有问题。。找GPT帮忙改写了win10能用的更新脚本
* 关于计划任务定时重启 使用该项目（快速启动桌面右下角系统托盘图标程序）：
* https://github.com/rexdf/CommandTrayHost


```json
{
    "configs": [
        { 
            "name": "ddns ๑乛◡乛๑ ",
            "path": "C:\\Windows\\System32",
            "cmd": "cmd.exe /c ddns", //把脚本改名叫ddns 放到系统path任意目录都行
            "working_directory": "",
            "addition_env_path": "",
            "start_show": false, // 是否以显示(而不是隐藏)的方式启动子程序 显示启动=true 隐藏启动=false
            "use_builtin_console": false,
            "is_gui": false,
            "enabled": true, // true / false
            "alpha": 165,
            "icon": "E:\\快速启动CommandTrayHost\\透明图标.ico", // 命令行窗口的图标
            "hotkey": { // 下面并不需要都出现，可以只设置部分
            		//"restart": "Ctrl+D", // 重启程序
            			},
            // 可选 计划任务
            "crontab_config": { // crontab配置
                "crontab": "0 0/5 * * * *", // 5分钟检测一次
                "method": "restart", // 支持的有 start restart stop start_count_stop restart_count_stop，最后两个表示count次数的最后一个会执行stop
                "count": 0, // 0 表示infinite无限，大于0的整数，表示运行多少次就不运行了
                // 可选
                "enabled": true, // 是否启动计划任务： true / false
                "log": "commandtrayhost.log", // 日志文件名,注释掉本行就禁掉log了
                "log_level": 3, // log级别，缺省默认为0。0为仅仅记录crontab触发记录，1附加启动时的信息，2附加下次触发的信息，3重启记录状态
								},
        },
    ],
    //。。。此处省略 其他快捷键+右击托盘显示组合的 其他参数设置
}

```



##### 项目发起人：rer
##### 项目作者：ChatGPT

