http://blog.csdn.net/leshami/article/details/6073069

Oracle rman中recover和restore的区别：

restore just copy the physical file, recover will consistent the database.

restore 是还原，文件级的恢复。就是物理文件还原。
recover 是恢复，数据级的恢复。逻辑上恢复，比如应用归档日志、重做日志，全部同步，保持一致。

用我自己的土话讲就是，用restore先把备份文件拷贝到数据库目录下进行替换，再用recover经过一些处理，数据库就恢复正常了。

1、restore 命令：用于还原已经备份的数据文件。
  （1）、restore database 还原所有的数据文件。
  （2）、restore tablespace 还原特定表空间的数据文件。
  （3）、restore datafile 还原特定的数据文件。
  （4）、restore controlfile  还原控制文件。
  （5）、restore archivelog  还原归档日志文件。

2、recover 命令：当数据库需要应用归档日志文件恢复数据文件时，使用recover命令。使用该命令数据库系统会自动应用归档的日志文件。
  （1）、recover database 恢复所有的数据文件。
  （2）、recover tablespace 恢复特定表空间的数据文件。
  （3）、recover datafile 恢复特定的数据文件。


/**重要**/

--恢复命令：
restore database;(只能在mount状态下使用)
restore tablespace;(只能在open状态下使用)
restore datafile; (只能在open或者mount状态下使用)
restore controlfile;(只能在nomount状态下使用) 
restore archivelog;(open mount下均可) 
restore spfile;(nomount) 恢复数据库
--RAMN 完整恢复 	
--数据文件误删 
    /*数据库机子模拟 删除所有数据文件*/
    sql>shutdown immediate;
    [ ] rm -f $oracle_base/oradata/orcl/\*.dbf 删除所有文件
    sql>startup mount;
     /*rman机子执行恢复*/
    SQL>ho rman target sys/Communicate_1@orcl128 catalog RMAN/RMAN
    --注意必须把目标数据库mount;--可以在目标数据库自行startup mount;或者rman>startup force mount

    RMAN>startup force mount；
   			   run
   		       {
    			 restore database;
   				 recover database;
  		 sql 'alter database open';
   	       };

--	数据文件所在的磁盘不能用了
     run
                 { 
             set newname for datafile 1  to '新路径'；
             set newname for datafile 2  to '新路径'；
             set newname for datafile 3  to '新路径'；
             set newname for datafile 4  to '新路径'；
             restore database;
             switch datafile all;//switch的作用就是修改controlfile~ 文件路径变了，需要告诉rman不要用原来的路径了。
             recover database;
             sql 'alter database open';
                 };

--数据文件被删除 恢复 mount状态
  /**数据库机子 模拟数据文件删除或者损坏*/
    sql>shutdown immediate;
    SQL> ho rm -f /home/oracle_11/app/oradata/orcl/system01.dbf;
    sql>startup mount;
       /*rman机子执行恢复*/
      SQL>ho rman target sys/Communicate_1@orcl128 catalog RMAN/RMAN
      RMAN>  run
                 {
                  startup force mount;
             restore datafile 1;--多文件 restore datafile 1,3;
             recover datafile 1;
             sql 'alter database open';
                 };
    --open状态下 恢复数据文件
    SQL> ho rm -f /home/oracle_11/app/oradata/orcl/users01.dbf;

                 run
                 {
                  sql 'alter database datafile 4 offline';
             restore datafile 4;
             recover datafile 4;
             sql 'alter database datafile 4 online';
                 };
/*
			数据文件所在磁盘坏了
			ORA-01157: 无法标识/锁定数据文件 6 - 请参阅 DBWR 跟踪文件
			ORA-01110: 数据文件 6: 'D:\ORACLE\ORADATA\ORCL\DEMO.DBF' 
			rman;
			connect target sys/sys  记住不要（@orcl_192.168.0.5;）
			connect catalog rman/rman 记住不要（@orcl_192.168.0.5;）
		        
			       run
			       {
			        
			        sql 'alter database datafile 6 offline';
				sql 'alter database open';
				set newname for datafile 6 to '新路径'；
				 restore datafile 6;
				 switch datafile 6;
				 recover datafile 6;
				 sql 'alter database datafile 6 online';
			       };
OPEN状态下打开后意外丢失的文件

			数据文件误删  出现错误如下：
			ORA-01157: 无法标识/锁定数据文件 6 - 请参阅 DBWR 跟踪文件
			ORA-01110: 数据文件 6: 'D:\ORACLE\ORADATA\ORCL\DEMO.DBF' 
			rman;
			connect target sys/sys  记住不要（@orcl_192.168.0.5;）
			connect catalog rman/rman 记住不要（@orcl_192.168.0.5;）
			       run
			       {
			        sql 'alter database datafile 6 offline';
				 restore datafile 6;
				 recover datafile 6;
				 sql 'alter database datafile 6 online';
			       };*/

--表空间恢复 必须在open状态

  /*数据库机子 模拟表空间文件损坏*/
    SQL> shutdown immediate;
    SQL> ho rm -f /home/oracle_11/app/oradata/orcl/users01.dbf;
    SQL> startup mount;
    SQL> alter database datafile 4 offline;
    SQL> ALTER DATABASE OPEN;--打开
    /*rman机子执行恢复*/
    [oracle@localhost ~]$  rman target sys/Communicate_1@orcl128 catalog RMAN/RMAN;
    RMAN> run {
       sql 'alter tablespace users offline for recover';
       restore tablespace users;
       recover tablespace users;
       sql 'alter tablespace users online';
        }
--控制文件恢复 必须在nomount状态下
/*数据库机子 控制文件损坏*/
sys@ORCL> ho rm $ORACLE_BASE/oradata/orcl/\*.ctl                --删除所有的控制文件*/
SQL> shutdown immediate;
Database closed.
ORA-00210: cannot open the specified control file
ORA-00202: control file: '/home/oracle_11/app/oradata/orcl/control01.ctl'  --发生错误
ORA-27041: unable to open file
Linux Error: 2: No such file or directory
Additional information: 3
SQL> shutdown abort;
--注意这次是在数据库机子执行恢复
[oracle@localhost ~]$  rman target / catalog RMAN/RMAN@orcl129; --重新连接到RMAN，注意连接target时使用/,否则提示TNS无法解析

 RMAN> startup nomount;
            RMAN> run {
             restore controlfile;
             sql " alter database mount ";
             recover database;
             sql " alter database open resetlogs ";
            }

-- 5.联机重做日志文件的恢复(online redo log )
        当数据库置为mount状态，且将要转换为open状态时，数据文件，联机日志文件被打开，因此联机日志的丢失可以在mount状态完成
        恢复步骤
            a. 启动到mount状态(startup mount force)
            b. 还原数据库(restore database)
            c. 恢复数据库(recover database)

--不完整恢复
--基于时间点恢复
[oracle@dave ~]$ rman target / catalog RMAN/RMAN@orcl129
RMAN> host "date -R";
Wed, 17 Dec 2014 04:37:03 -0800
host command complete
RMAN> sql 'truncate table scott.emp';
RMAN> startup force mount;
RMAN> run {
/*
4> sql 'alter session set nls_date_format="yyyy-mm-dd hh24:mi:ss"';

5> set until time='2012-03-01 16:00:42';
*/
2> set until time "to_date( '2014-12-17 04:37:03','yyyy-MM-dd hh24:mi:ss')";
3> restore database;
4> recover database;
5> }
RMAN> sql 'alter database open resetlogs';

--基于scn恢复
SQL> select current_scn from v$database;
CURRENT_SCN
-----------
    1927655
SQL> ho  rman target / catalog RMAN/RMAN@orcl129;
RMAN> run {
2> set until scn=1927655;
3> restore database;
4> recover database;
5> }
RMAN> sql 'alter database open resetlogs';

recover tablespace users
 until time "to_timestamp('2014-12-1 06:16:00','yyyy-mm-dd hh24:mi:ss')" 
flashback table scott.t4 to timestamp to_timestamp('2014-12-1 06:16:00','yyyy-mm-dd hh24:mi:ss');
flashback table scott.t   to timestamp to_timestamp('2014-12-1 06:16:00','yyyy-mm-dd hh24:mi:ss');
