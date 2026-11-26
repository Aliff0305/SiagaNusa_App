@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo SiagaNusa - Sync BMKG ^& Sipongi Feeds
echo ========================================
echo.

echo [1/2] Syncing BMKG feeds...
php artisan bmkg:sync
echo.

echo [2/2] Syncing Sipongi feeds...
php artisan sipongi:sync
echo.

echo Selesai!
pause
