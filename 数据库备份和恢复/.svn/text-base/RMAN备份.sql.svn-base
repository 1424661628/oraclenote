LIST BACKUP OF DATABASE;

LIST BACKUP OF TABLESPACE USERS;


完整数据库备份集
     冷备份（一致性备份）:shutdown immediate ;
				startup mount;
				backup database format='E:\oracleBackup\rmanbackup\%d_%s.dbf'; //去掉format会按照通道里设置的格式和路径
				sql 'alter system archive log current';//手动归档日志 强制日志转换 也就是归档到归档日志中
	热备份（非一致性备份）：backup database format='E:\oracleBackup\rmanbackup\%d_%s.dbf';//去掉format会按照通道里设置的格式和路径
				sql 'alter system archive log current';//手动归档日志
	免除表空间：configure exclude  for tablespace user1;
				backup database format='E:\oracleBackup\rmanbackup\%d_%s.dbf';//去掉format会按照通道里设置的格式和路径
				sql 'alter system archive log current';//手动归档日志

表空间备份集：backup tablespace use03 format='E:\oracleBackup\rmanbackup\%N_%s.dbf'; //去掉format会按照通道里设置的格式和路径


数据文件备份集：
 SELECT FILE_ID,FILE_NAME FROM DBA_DATA_FILES;
 BACKUP DATAFILE 'F:\ORACLE\ORADATA\JSSBOOK\USERS01.DBF' format='E:\oracleBackup\rmanbackup\%d_%f_%s.dbf';//去掉format会按照通道里设置的格式和路径
  backup datafile 5 format='E:\oracleBackup\rmanbackup\%d_%f_%s.dbf';//去掉format会按照通道里设置的格式和路径
  LIST BACKUP OF DATAFILE n;


控制文件备份集：
backup current controlfile  format='E:\oracleBackup\rmanbackup\%d_%s.ctl';//去掉format会按照通道里设置的格式和路径
CONFIGURE CONTROLFILE AUTOBACKUP ON;
　　当 AUTOBACKUP 被置为 ON 时， RMAN 做任何备份操作，都会自动对控制文件做备份。
　　如果要查看备份的控制文件，可以通过以下命令进行：
 LIST BACKUP OF CONTROLFILE;



SPFILE备份集：
backup spfile  format='E:\oracleBackup\rmanbackup\%d_%s.ctl';//去掉format会按照通道里设置的格式和路径

归档日志备份：
BACKUP ARCHIVELOG ALL;

多重备份：
1.backup  copies 3 tablespace users formate='d:\bak1\%d_%s.bak','d:\bak2\%d_%s.bak','d:\bak3\%d_%s.bak'
2.RMAN> RUN{

2>SET BACKUP COPIES 2;

3>BACKUP DEVICE TYPE DISK FORMAT  ' D:\ backup1 \%U ' ,  ' D:\ backup2 \%U '  

4>TABLESPACE USERS,SALES;

5>}

增量备份：
backup incremental level 0 database; 
一级差异增量例子 
backup incremental level 1 database; 