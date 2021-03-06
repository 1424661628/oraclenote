http://www.doc88.com/p-239796029571.html
http://blog.csdn.net/gyanp/article/details/6179470
--创建导出目录
CREATE or replace DIRECTORY dump_dir as '/home/oracle/';-----注意这个目录路径必须存在
--授权
grant read,write on directory dump_dir to  test;
grant EXP_FULL_DATABASE to test;
grant IMP_FULL_DATABASE to test;

--导出表
expdp test/test directory=dump_dir tables=SAFFS dumpfile=table.dmp;
--导出表空间
expdp test/test directory=dump_dir tablespaces=test dumpfile=table.dmp;
--导出方案
expdp test/test directory=dump_dir schemas=test dumpfile=table.dmp;
--数据库
expdp test/test directory=dump_dir full=y dumpfile=table.dmp;

--导入相同表空间
impdp test/test directory=dump_dir schemas=test dumpfile=table.dmp;

--导入到不同的表空间不同的用户
impdp test1/test1 directory=dump_dir remap_schema=test:test1 remap_tablespace=test:test1 dumpfile=table.dmp;
--利用dblink导入远程数据库到本地

--1.129机子 创建dblick
create database link dblink128
  connect to test identified by test
  using '  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.73.128)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = orcl)
    )
  )';
--2.129机子导出128数据库
impdp test1/test1 directory=dump_dir remap_schema=test:test1 remap_tablespace=test:test1 NETWORK_LINK=dblink128 TABLE_EXISTS_ACTION=replace

--http://www.eygle.com/archives/2005/04/ecineeeeiaeioae.html imp
--http://blog.csdn.net/songyang_oracle/article/details/6426756
EXPDP命令行选项
1. ATTACH
该选项用于在客户会话与已存在导出作用之间建立关联.语法如下
ATTACH=[schema_name.]job_name
Schema_name用于指定方案名,job_name用于指定导出作业名.注意,如果使用ATTACH选项,在命    令行除了连接字符串和ATTACH选项外,不能指定任何其他选项,示例如下:
Expdp scott/tiger ATTACH=scott.export_job
2. CONTENT*************
  该选项用于指定要导出的内容.默认值为ALL
  CONTENT={ALL | DATA_ONLY | METADATA_ONLY}
当设置CONTENT为ALL 时,将导出对象定义及其所有数据.为DATA_ONLY时,只导出对象数据,为METADATA_ONLY时,只导出对象定义。
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dump 
CONTENT=METADATA_ONLY
3. DIRECTORY*************
指定转储文件和日志文件所在的目录
DIRECTORY=directory_object
Directory_object用于指定目录对象名称.需要注意,目录对象是使用CREATE DIRECTORY语句 建立的对象,而不是OS 目录
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dump
建立目录:
CREATE DIRECTORY dump as ‘d:dump’;
查询创建了那些子目录:
     SELECT * FROM dba_directories;
4. DUMPFILE*************
用于指定转储文件的名称,默认名称为expdat.dmp
DUMPFILE=[directory_object:]file_name [,….]
Directory_object用于指定目录对象名,file_name用于指定转储文件名.需要注意,如果不指定directory_object,导出工具会自动使用DIRECTORY选项指定的目录对象
Expdp scott/tiger DIRECTORY=dump1 DUMPFILE=dump2:a.dmp
5. ESTIMATE
指定估算被导出表所占用磁盘空间分方法.默认值是BLOCKS
EXTIMATE={BLOCKS | STATISTICS}
设置为BLOCKS时,oracle会按照目标对象所占用的数据块个数乘以数据块尺寸估算对象占  用的空间,设置为STATISTICS时,根据最近统计值估算对象占用空间
Expdp scott/tiger TABLES=emp ESTIMATE=STATISTICS
DIRECTORY=dump DUMPFILE=a.dump
6. EXTIMATE_ONLY
指定是否只估算导出作业所占用的磁盘空间,默认值为N
EXTIMATE_ONLY={Y | N}
设置为Y时,导出作用只估算对象所占用的磁盘空间,而不会执行导出作业,为N时,不仅估算对象所占用的磁盘空间,还会执行导出操作.
Expdp scott/tiger ESTIMATE_ONLY=y NOLOGFILE=y
7. EXCLUDE*************
该选项用于指定执行操作时释放要排除对象类型或相关对象
EXCLUDE=object_type[:name_clause] [,….]
Object_type用于指定要排除的对象类型,name_clause用于指定要排除的具体对象.EXCLUDE和 INCLUDE不能同时使用
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dup EXCLUDE=VIEW
8. FILESIZE*************
 指定导出文件的最大尺寸,默认为0,(表示文件尺寸没有限制) 如果导出到多个文件可以设置此选项
9. FLASHBACK_SCN
     指定导出特定SCN时刻的表数据
     FLASHBACK_SCN=scn_value
     Scn_value用于标识SCN值.FLASHBACK_SCN和FLASHBACK_TIME不能同时使用
     Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dmp 
     FLASHBACK_SCN=358523
10. FLASHBACK_TIME
       指定导出特定时间点的表数据
       FLASHBACK_TIME=”TO_TIMESTAMP(time_value)”
       Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dmp FLASHBACK_TIME=
      “TO_TIMESTAMP(’25-08-2004 14:35:00’,’DD-MM-YYYY HH24:MI:SS’)”
11. FULL
       指定数据库模式导出,默认为N
       FULL={Y | N}
       为Y时,标识执行数据库导出.
12. HELP
       指定是否显示EXPDP命令行选项的帮助信息,默认为N
       当设置为Y时,会显示导出选项的帮助信息.
       Expdp help=y
13. INCLUDE
       指定导出时要包含的对象类型及相关对象
       INCLUDE = object_type[:name_clause] [,… ]
14. JOB_NAME
       指定要导出作用的名称,默认为SYS_XXX
       JOB_NAME=jobname_string
15. LOGFILE
指定导出日志文件文件的名称,默认名称为export.log
LOGFILE=[directory_object:]file_name
Directory_object用于指定目录对象名称,file_name用于指定导出日志文件名.如果不    指定directory_object.导出作用会自动使用DIRECTORY的相应选项值.
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dmp logfile=a.log
16. NETWORK_LINK
       指定数据库链名,如果要将远程数据库对象导出到本地例程的转储文件中,必须设置该选项.
17. NOLOGFILE
       该选项用于指定禁止生成导出日志文件,默认值为N.
18. PARALLEL
  指定执行导出操作的并行进程个数,默认值为1
19. PARFILE
       指定导出参数文件的名称
       PARFILE=[directory_path] file_name
20. QUERY
用于指定过滤导出数据的where条件
QUERY=[schema.] [table_name:] query_clause
Schema用于指定方案名,table_name用于指定表名,query_clause用于指定条件限制子句.QUERY选项不能与CONNECT=METADATA_ONLY,EXTIMATE_ONLY,TRANSPORT_TABLESPACES等选项同时使用.
Expdp scott/tiger directory=dump dumpfiel=a.dmp
Tables=emp query=’WHERE deptno=20’
21. SCHEMAS
       该方案用于指定执行方案模式导出,默认为当前用户方案.
22. STATUS
       指定显示导出作用进程的详细状态,默认值为0
23. TABLES
指定表模式导出
TABLES=[schema_name.]table_name[:partition_name][,…]
Schema_name用于指定方案名,table_name用于指定导出的表名,partition_name用于指 定要导出的分区名.
24. TABLESPACES
       指定要导出表空间列表
25. TRANSPORT_FULL_CHECK
该选项用于指定被搬移表空间和未搬移表空间关联关系的检查方式,默认为N.
当设置为Y时,导出作用会检查表空间直接的完整关联关系,如果表空间所在表空间或其索引所在的表空间只有一个表空间被搬移,将显示错误信息.当设置为N时,导出作用只检查单端依赖,如果搬移索引所在表空间,但未搬移表所在表空间,将显示出错信息,如果搬移表所在表空间,未搬移索引所在表空间,则不会显示错误信息.
26. TRANSPORT_TABLESPACES
       指定执行表空间模式导出
 
27. VERSION
指定被导出对象的数据库版本,默认值为COMPATIBLE.
VERSION={COMPATIBLE | LATEST | version_string}
为COMPATIBLE时,会根据初始化参数COMPATIBLE生成对象元数据;为LATEST时,会根据            数据库 的实际版本生成对象元数据.version_string用于指定数据库版本字符串.



--imp命令行选项
 --IMPDP命令行选项与EXPDP有很多相同的,不同的有:
使用IMPDP
 IMPDP命令行选项与EXPDP有很多相同的,不同的有:
1.REMAP_DATAFILE
该选项用于将源数据文件名转变为目标数据文件名,在不同平台之间搬移表空间时可能需要  该选项.
EMAP_DATAFIEL=source_datafie:target_datafile
2.REMAP_SCHEMA
    该选项用于将源方案的所有对象装载到目标方案中.
    REMAP_SCHEMA=source_schema:target_schema
3.REMAP_TABLESPACE
    将源表空间的所有对象导入到目标表空间中
    REMAP_TABLESPACE=source_tablespace:target:tablespace
4.REUSE_DATAFILES
    该选项指定建立表空间时是否覆盖已存在的数据文件.默认为N
    REUSE_DATAFIELS={Y | N}
5.SKIP_UNUSABLE_INDEXES
    指定导入是是否跳过不可使用的索引,默认为N
6.SQLFILE
    指定将导入要指定的索引DDL操作写入到SQL脚本中
    SQLFILE=[directory_object:]file_name
    Impdp scott/tiger DIRECTORY=dump DUMPFILE=tab.dmp SQLFILE=a.sql
7.STREAMS_CONFIGURATION
指定是否导入流元数据(Stream Matadata),默认值为Y.
8.TABLE_EXISTS_ACTION
该选项用于指定当表已经存在时导入作业要执行的操作,默认为SKIP
TABBLE_EXISTS_ACTION={SKIP | APPEND | TRUNCATE | FRPLACE }当设置该选项为SKIP时,导入作业会跳过已存在表处理下一个对象;当设置为APPEND时,会追  加数据,为TRUNCATE时,导入作业会截断表,然后为其追加新数据;当设置为REPLACE时,导入作业会删除已存在表,重建表病追加数据,注意,TRUNCATE选项不适用与簇表和NETWORK_LINK选项
9.TRANSFORM
该选项用于指定是否修改建立对象的DDL语句
TRANSFORM=transform_name:value[:object_type]
Transform_name用于指定转换名,其中SEGMENT_ATTRIBUTES用于标识段属性(物理属性,存储 属性,表空间,日志等信息),STORAGE用于标识段存储属性,VALUE用于指定是否包含段属性或段存储属性,object_type用于指定对象类型.
Impdp scott/tiger directory=dump dumpfile=tab.dmp
Transform=segment_attributes:n:table
10.TRANSPORT_DATAFILES
    该选项用于指定搬移空间时要被导入到目标数据库的数据文件
    TRANSPORT_DATAFILE=datafile_name
    Datafile_name用于指定被复制到目标数据库的数据文件
    Impdp system/manager DIRECTORY=dump DUMPFILE=tts.dmp
    TRANSPORT_DATAFILES=’/user01/data/tbs1.f’
