::last update by 
::这是一个通用的备份解决方案,测试于MySQL5.5版本

::******自动的日期参数,无须设置******
set RIQI=%date:~0,4%-%date:~5,2%-%date:~8,2%
set SHIJIAN=%time:~0,2%%time:~3,2%

::******请人手设置数据库参数******
set BACKUP_PATH=D:\mysqlbak
set MYSQL_BIN_PATH=C:\Program Files (x86)\MySQL\MySQL Server 5.5\bin
set DB=szhjxpt
set PORT=3306
set USER=root
set PASSWD=jishu8cc

::创建备份目录
md %BACKUP_PATH%
cd /d %BACKUP_PATH%
mkdir %RIQI%

::进入mysql安装目录
cd /d "%MYSQL_BIN_PATH%"

mysqldump  -u%USER% -p%PASSWD% -P%PORT% -ER %DB% > "%BACKUP_PATH%\%RIQI%\%DB%%PORT%-%SHIJIAN%.sql"
