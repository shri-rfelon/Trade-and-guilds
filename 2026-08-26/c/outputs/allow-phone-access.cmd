@echo off
netsh advfirewall firewall add rule name="Trade and Guilds mobile access" dir=in action=allow protocol=TCP localport=8080 remoteip=localsubnet profile=public
echo.
echo Mobile access is enabled for phones on your local Wi-Fi network.
echo Scan the QR code again while this computer remains on.
pause
