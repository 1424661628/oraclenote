报告数据库结构
	report schema;
列出数据文件备份集
	list backup of tablespace users;
列出控制文件备份集	
	list backup of controlfile;
归档日志
	list backup of archivelog all;
SPFILE
	list backup of spfile;

RMAN>  SHOW CONTROLFILE AUTOBACKUP;

RMAN configuration parameters are:

CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default
列出备份信息——LIST命令
　　LIST 命令用来查看通过RMAN生成的备份集、备份镜像、归档文件等，这个命令使用也比较简单，用LIST+相应关键字即可，例如：

•列出数据库中所有的备份信息：
RMAN> LIST BACKUP;

•列出所有备份的控制文件信息：
RMAN> LIST BACKUP OF CONTROLFILE;

•列出指定数据文件的备份信息：
RMAN> LIST BACKUP OF DATAFILE  ' F:\ORACLE\ORADATA\JSSBOOK\SCOTT_TBS01.DBF ' ;
　　或
RMAN> LIST BACKUP OF DATAFILE 5;
　　注：DATAFILE序号可以通过动态性能视图 V$DATAFILE 或数据字典 DBA_DATA_FILES 中查询。

•列出所有备份的归档文件信息：
RMAN> LIST BACKUP OF ARCHIVELOG ALL;

•列出指定表空间的备份信息：
RMAN> LIST COPY OF TABLESPACE  ' SYSTEM ' ;

•列出某个设备上的所有信息：
RMAN> LIST DEVICE TYPE DISK BACKUP;

•列出数据库当前所有归档：
RMAN> LIST ARCHIVELOG ALL;

•列出所有无效备份：
RMAN> LIST EXPIRED BACKUP;




用于删除RMAN备份记录及相应的物理文件。当使用RMAN执行备份操作时，会在RMAN资料库（RMAN Repository）中生成RMAN备份记录，默认情况下RMAN备份记录会被存放在目标数据库的控制文件中，如果配置了恢复目录（Recovery  C atalog ），那么该备份记录也会被存放到恢复目录中。

RMAN 中的DELETE命令就是用来删除记录（某些情况下并非删除记录，而是打上删除标记），以及这些记录关联的物理备份片段。

•删除过期备份。当使用RMAN命令执行备份操作时，RMAN会根据备份冗余策略确定备份是否过期。
RMAN> report obsolete
RMAN>  DELETE OBSOLETE;

•删除无效备份。首先执行 CROSSCHECK 命令核对备份集，如果发现备份无效（比如备份对应的数据文件损坏或丢失），RMAN会将该备份集标记为EXPIRED状态。要删除相应的备份记录，可以执行 DELETE EXPIRED BACKUP 命令：
RAMN》 crosscheck archivelog all;
RMAN>  DELETE EXPIRED BACKUP;
•删除EXPIRED副本，如下所示：
RMAN>  DELETE EXPIRED COPY;

•删除特定备份集，如下所示：
RMAN>  DELETE BACKUPSET 19;

•删除特定备份片，如下所示：
RMAN>  DELETE BACKUPPIECE  ' d:\backup\DEMO_19.bak ' ;

•删除所有备份集，如下所示：
RMAN>  DELETE BACKUP;

•删除特定映像副本，如下所示：
RMAN>  DELETE DATAFILE COPY  ' d:\backup\DEMO_19.bak ' ;

•删除所有映像副本，如下所示：
RMAN>  DELETE COPY;

•在备份后删除输入对象，如下所示：
RMAN>  BACKUP ARCHIVELOG ALL DELETE INPUT;

RMAN>  DELETE BACKUPSET 22 FORMAT  =  'd:\backup\%u.bak'  DELETE INPUT;
