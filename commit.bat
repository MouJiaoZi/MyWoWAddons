@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
    set year=%%b
    set month=%%c
    set day=%%d
)

for /f "tokens=1-3 delims=: " %%a in ('time /t') do (
    set hour=%%a
    set minute=%%b
)

set datetime=%year%-%month%-%day% %hour%:%minute%

git add . && git commit -m "%datetime%" && git push

echo 完成: %datetime%
pause