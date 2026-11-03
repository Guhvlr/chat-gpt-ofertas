@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Instalar.ps1"
if errorlevel 1 echo A instalacao encontrou um erro. Leia a mensagem acima.
pause
