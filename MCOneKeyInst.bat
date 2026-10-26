@echo off
setlocal enabledelayedexpansion
cd /d %~dp0
title MCJE Java环境与启动器下载 当前路径:%cd%

:ProgramFileSet
set ariac=%cd%\aria2c.exe
set zipa=%cd%\7z.exe
set FldKwordRen=%cd%\FolderKeywordRename.exe
set downitems=%cd%\downloaditems.txt

:EnvCheck
echo %PROCESSOR_ARCHITECTURE%|findstr "arm" >nul&&(goto InvalidArchitecture)
echo %PROCESSOR_ARCHITECTURE%|findstr "32" >nul&&(goto No32Systems)
echo %PROCESSOR_ARCHITECTURE%|findstr "86" >nul&&(goto No32Systems)
echo %cd%|findstr "%systemdrive%" >nul&&(goto DontInstSystemDrive)

:regCheck
reg query "HKEY_CURRENT_USER\Environment" /v "MCJE_env_launcher_downloading" >nul 2 >nul && goto exist || goto Disclaimer

:Disclaimer
title MCJE Java环境与启动器下载 当前进行内容: 免责声明 运行路径: %cd%
echo 您需要保证一盘至少两区 (只算分配驱动器号)
echo 若只有一盘一区, 您提交了 issue , 我们不会受理, 但会引导您如何一盘两区
echo 如果是多盘, 各盘各分一区, 则不会涉及该问题
pause & echo.

:tips
title MCJE Java环境与启动器下载 当前进行内容: 提示 运行路径: %cd%
echo 由于进行下载 Azul Java、Hello! Minecraft Launcher
echo 涉及不在中国大陆境内的网站, 部分地区可能会无法访问
echo 可能会出现 连接重置(Connection Reset) 无法解析主机名 (Unknown host) IP封禁 (一般是 403 Forbidden, 代理出现的比较多) 等
echo 如果拥有代理, 请一定要填写, 代理协议使用 http
echo 若没有代理, 则使用 Watt Toolkit 进行 GitHub 加速, 但速度不能与代理相比, 其他域名可能仍然直连
pause & echo.

:choosedir
title MCJE Java环境与启动器下载 当前进行内容: 切换下载文件夹 下载路径: %cd%
echo 在此输入要切换的目录, 若不输入直接回车则会保持当前文件夹
echo 若要快速输入, 在资源管理器中将文件夹拖入本窗口即可
set /p "target=设置路径: "
if "%target%"=="" (echo 保持当前目录：%cd%) else (if exist "%target%\" (pushd "%target%" 2>nul & if errorlevel 1 (echo 错误：无法访问目录 "%target%" & goto choosedir ) & echo 已切换到：%cd% ) else (echo 错误：目录 "%target%" 不存在 & goto choosedir ))

:update-20261026
echo 由于 Plain Craft Launcher 2 作者 龙腾猫跃
echo 宣布在表面上终止下载功能, 但源代码中仍有相关代码以支持下载
echo 请有能力的用户下载源代码, 经过一定的修改后, 编译使用 (建议)
echo 编写能力有限, 不能提供自动下载, 本项目提供如下渠道:
echo 源代码 https://github.com/Meloong-Git/PCL (无法访问请使用代理)
echo ---------------------------------------------------------------
echo PCL 正式版 2.14.0.0 https://www.lanzoux.com/iTc7B4cl2i2f (LTCat上传)
echo PCL 正式版 2.13.1.1 https://www.lanzoux.com/iuzYq41288ed (LTCat上传)
echo 使用官方版文件预配置版 https://zeroabj445.ysepan.com/ (游客密码 v1981a , 网友上传)
echo 请将以上的下载文件 .zip 格式放在 %cd% 中
echo 若使用从官方分支的版本, 可能需自行评估风险
pause

:Setproxy
title MCJE Java环境与启动器下载 当前进行内容: 代理设置 下载路径: %cd%
echo. & echo 如果你拥有代理,在下方写下代理服务器的地址,用于为 GitHub 下载增速
echo 由于未测试过socks代理协议,当前版本暂时只能填入 http 代理
echo 带不带协议均可,例如 10.15.1.12:7890,IP地址要和端口一起写
echo 若没有则回车键跳过,不影响下载
set /p "proxy=在此输入代理地址: "

:ProxyUsrPasswd
echo. & echo 如果对应代理要求用户名和密码, 在此输入
echo 通常情况下, 在本机运行的代理工具未设置用户名和密码
echo 若没有则回车跳过即可, 不影响下载器运行
set /p "proxyusr=在此输入代理用户名: " & set /p "proxypasswd=在此输入代理对应用户名的密码: "

:dependence
title MCJE Java环境与启动器下载 当前进行内容: 前置准备 下载路径: %cd% & echo.
%ariac% --file-allocation=none --check-certificate=false --all-proxy=%proxy% --all-proxy-user=%proxyusr% --all-proxy-passwd=%proxypasswd% --no-conf --log-level=info --max-connection-per-server=4 --split=1 --max-concurrent-downloads=4 --continue=false -R --dir="%~dp0" --input-file="%~dp0\depend.txt"

:StartDownload
title MCJE Java环境与启动器下载 当前进行内容: 下载 下载路径: %cd% & echo.
echo 准备进行下载
echo 如果弹出 Windows 安全警报 窗口请勾选 公用网络 和 专用网络
echo 保证正常下载
echo.
echo 若出现 Redirecting to 消息是正常现象,继续等候下载
echo 每一段时间出现 Download Progress Summary 时是下载状态报告
echo 请勿退出窗口,否则会终止
echo. & pause

:aria2
echo. & echo 当前进行内容:
echo 下载 Azul JDK 8 fx、JDK 11 fx 、JDK 14 fx 、JDK 17 fx、JDK 21 fx、JDK 25 fx
echo Hello! Minecraft Launcher
%ariac% --file-allocation=none --check-certificate=false --all-proxy=%proxy% --all-proxy-user=%proxyusr% --all-proxy-passwd=%proxypasswd% --no-conf --log-level=info --max-connection-per-server=4 --split=1 --max-concurrent-downloads=1 --continue=false -R --dir="%cd%" --input-file=%downitems%
echo.

:unzip7z
title MCJE Java环境与启动器下载 当前进行内容: 解压缩 运行路径: %cd%
echo. & echo. & timeout /t 1 /nobreak >nul
start /wait %zipa% x .\Azul-JDKFX8_X64-Win.zip
start /wait %zipa% x .\Azul-JDKFX11_X64-Win.zip
start /wait %zipa% x .\Azul-JDKFX14_X64-Win.zip
start /wait %zipa% x .\Azul-JDKFX17_X64-Win.zip
start /wait %zipa% x .\Azul-JDKFX21_X64-Win.zip
start /wait %zipa% x .\Azul-JDKFX25_X64-Win.zip
start /wait %zipa% x .\"PCL 正式版 2.13.1.1.zip"
start /wait %zipa% x .\"PCL 正式版 2.14.0.0.zip"
timeout /t 2 /nobreak >nul

:cleantemp
title MCJE Java环境与启动器下载 当前进行内容: 清理 运行路径: %cd%
del /f /s /q .\Azul*
timeout /t 2 /nobreak >nul

:rename
title MCJE Java环境与启动器下载 当前进行内容: 更正名称 运行路径: %cd%
echo ==================
start /wait %FldKwordRen% -k zulu8 -n JDK8
start /wait %FldKwordRen% -k zulu11 -n JDK11
start /wait %FldKwordRen% -k zulu14 -n JDK14
start /wait %FldKwordRen% -k zulu17 -n JDK17
start /wait %FldKwordRen% -k zulu21 -n JDK21
start /wait %FldKwordRen% -k zulu25 -n JDK25
mklink /D jre-x64 JDK25
rename "Plain Craft Launcher 2.exe" PlainCraftLauncher2.exe

:regin
timeout /t 2 /nobreak >nul & echo 加入注册表项目...
reg add "HKEY_CURRENT_USER\Environment" /v "MCOneKeyInst" /t REG_EXPAND_SZ /d %cd% >nul
echo.

:lnk
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Hello Minecraft Launcher.lnk""):b.TargetPath=""%cd%\HMCL-3.16.4.exe"":b.WorkingDirectory=""%cd%"":b.Save:close")
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Plain Craft Launcher 2.lnk""):b.TargetPath=""%cd%\PlainCraftLauncher2.exe"":b.WorkingDirectory=""%cd%"":b.Save:close")
goto Success

:InvalidArchitecture
cls
echo 处理器类型 %PROCESSOR_ARCHITECTURE% 尚不支持, 按任意键退出
pause >nul & pause >nul
exit

:No32Systems
cls
echo 要求64位操作系统
echo 按任意键退出
pause >nul & pause >nul
exit

:DontInstSystemDrive
cls
echo 我们坚决阻止在系统分区运行安装, 此为固定要求
echo 按任意键退出
pause >nul & pause >nul
exit

:Success
echo 创建文件夹, 若已有则会跳过
mkdir .minecraft;PCL
echo 操作完成, 按任意键退出
pause >nul
exit

:exist
echo 你已经拥有了 MCJE Java环境与启动器下载
echo 按任意键查看该文件夹并退出批处理
pause >nul & pause >nul
start %MCOneKeyInst%
exit