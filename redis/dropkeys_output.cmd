
for /f "delims=" %%i in ('redis-cli.exe -h %1 -p %2 keys %3') do redis-cli.exe -h %1 -p %2 del "%%i"