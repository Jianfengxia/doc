::last update by 
::����һ��ͨ�õı��ݽ������,������MySQL5.5�汾

::******�Զ������ڲ���,��������******
set RIQI=%date:~0,4%-%date:~5,2%-%date:~8,2%
set SHIJIAN=%time:~0,2%%time:~3,2%

::******�������������ݿ����******
set BACKUP_PATH=D:\mysqlbak
set MYSQL_BIN_PATH=C:\Program Files (x86)\MySQL\MySQL Server 5.5\bin
set DB=szhjxpt
set PORT=3306
set USER=root
set PASSWD=jishu8cc

::��������Ŀ¼
md %BACKUP_PATH%
cd /d %BACKUP_PATH%
mkdir %RIQI%

::����mysql��װĿ¼
cd /d "%MYSQL_BIN_PATH%"

mysqldump  -u%USER% -p%PASSWD% -P%PORT% -ER %DB% > "%BACKUP_PATH%\%RIQI%\%DB%%PORT%-%SHIJIAN%.sql"
