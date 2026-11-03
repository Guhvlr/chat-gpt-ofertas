@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0central\Abrir-Central.ps1"
if errorlevel 1 pause
