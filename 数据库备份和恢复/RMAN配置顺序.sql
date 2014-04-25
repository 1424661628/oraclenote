1.创建表空间
CREATE SMALLFILE TABLESPACE "RMAN" DATAFILE 'D:\APP\ADMINISTRATOR\ORADATA\ORCL\RMAN' 
SIZE 100M REUSE AUTOEXTEND ON NEXT 100M MAXSIZE 32767M LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
2.创建用户

CREATE USER "RMAN" PROFILE "DEFAULT" IDENTIFIED BY "*******" DEFAULT TABLESPACE "RMAN" TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK
GRANT UNLIMITED TABLESPACE TO "RMAN"
GRANT "CONNECT" TO "RMAN"
GRANT "RECOVERY_CATALOG_OWNER" TO "RMAN"
GRANT "RESOURCE" TO "RMAN"

3.
创建恢复目录
  c:\users\sirc116>rman target sys/sys
  RMAN>conncect catalog RMAN/RMAN
  RMAN> create catalog;
       恢复目录已创建



4.shutdown immediate;
   startup open;

5.      rman target sys/sys
  RMAN>conncect catalog RMAN/RMAN
  RMAN>register database

  注册在恢复目录中的数据库
	正在启动全部恢复目录的 resync
	完成全部 resync

6.查看数据库恢复模式
  SELECT LOG_MODE FROM V$DATABASE;如果是NOARCHIVELOG
	    SHUTDOWN IMMEDIATE;
		STARTUP MOUNT;
		ALTER DATABASE ARCHIVELOG;
		ALTER DATABASE OPEN;

7.在恢复目录里创建创建全局脚本：
RMAN> create global script global_full_backup
2> {
3>  backup database plus archivelog;
4> }

8.在恢复目录里执行脚本：
RMAN> run
2> {
3> execute script  global_full_backup;
4> }




   