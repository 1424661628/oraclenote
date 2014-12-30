http://www.doc88.com/p-239796029571.html
http://blog.csdn.net/gyanp/article/details/6179470
--��������Ŀ¼
CREATE or replace DIRECTORY dump_dir as '/home/oracle/';-----ע�����Ŀ¼·���������
--��Ȩ
grant read,write on directory dump_dir to  test;
grant EXP_FULL_DATABASE to test;
grant IMP_FULL_DATABASE to test;

--������
expdp test/test directory=dump_dir tables=SAFFS dumpfile=table.dmp;
--������ռ�
expdp test/test directory=dump_dir tablespaces=test dumpfile=table.dmp;
--��������
expdp test/test directory=dump_dir schemas=test dumpfile=table.dmp;
--���ݿ�
expdp test/test directory=dump_dir full=y dumpfile=table.dmp;

--������ͬ��ռ�
impdp test/test directory=dump_dir schemas=test dumpfile=table.dmp;

--���뵽��ͬ�ı�ռ䲻ͬ���û�
impdp test1/test1 directory=dump_dir remap_schema=test:test1 remap_tablespace=test:test1 dumpfile=table.dmp;
--����dblink����Զ�����ݿ⵽����

--1.129���� ����dblick
create database link dblink128
  connect to test identified by test
  using '  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.73.128)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = orcl)
    )
  )';
--2.129���ӵ���128���ݿ�
impdp test1/test1 directory=dump_dir remap_schema=test:test1 remap_tablespace=test:test1 NETWORK_LINK=dblink128 TABLE_EXISTS_ACTION=replace

--http://www.eygle.com/archives/2005/04/ecineeeeiaeioae.html imp
--http://blog.csdn.net/songyang_oracle/article/details/6426756
EXPDP������ѡ��
1. ATTACH
��ѡ�������ڿͻ��Ự���Ѵ��ڵ�������֮�佨������.�﷨����
ATTACH=[schema_name.]job_name
Schema_name����ָ��������,job_name����ָ��������ҵ��.ע��,���ʹ��ATTACHѡ��,����    ���г��������ַ�����ATTACHѡ����,����ָ���κ�����ѡ��,ʾ������:
Expdp scott/tiger ATTACH=scott.export_job
2. CONTENT*************
  ��ѡ������ָ��Ҫ����������.Ĭ��ֵΪALL
  CONTENT={ALL | DATA_ONLY | METADATA_ONLY}
������CONTENTΪALL ʱ,�����������弰����������.ΪDATA_ONLYʱ,ֻ������������,ΪMETADATA_ONLYʱ,ֻ���������塣
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dump 
CONTENT=METADATA_ONLY
3. DIRECTORY*************
ָ��ת���ļ�����־�ļ����ڵ�Ŀ¼
DIRECTORY=directory_object
Directory_object����ָ��Ŀ¼��������.��Ҫע��,Ŀ¼������ʹ��CREATE DIRECTORY��� �����Ķ���,������OS Ŀ¼
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dump
����Ŀ¼:
CREATE DIRECTORY dump as ��d:dump��;
��ѯ��������Щ��Ŀ¼:
     SELECT * FROM dba_directories;
4. DUMPFILE*************
����ָ��ת���ļ�������,Ĭ������Ϊexpdat.dmp
DUMPFILE=[directory_object:]file_name [,��.]
Directory_object����ָ��Ŀ¼������,file_name����ָ��ת���ļ���.��Ҫע��,�����ָ��directory_object,�������߻��Զ�ʹ��DIRECTORYѡ��ָ����Ŀ¼����
Expdp scott/tiger DIRECTORY=dump1 DUMPFILE=dump2:a.dmp
5. ESTIMATE
ָ�����㱻��������ռ�ô��̿ռ�ַ���.Ĭ��ֵ��BLOCKS
EXTIMATE={BLOCKS | STATISTICS}
����ΪBLOCKSʱ,oracle�ᰴ��Ŀ�������ռ�õ����ݿ�����������ݿ�ߴ�������ռ  �õĿռ�,����ΪSTATISTICSʱ,�������ͳ��ֵ�������ռ�ÿռ�
Expdp scott/tiger TABLES=emp ESTIMATE=STATISTICS
DIRECTORY=dump DUMPFILE=a.dump
6. EXTIMATE_ONLY
ָ���Ƿ�ֻ���㵼����ҵ��ռ�õĴ��̿ռ�,Ĭ��ֵΪN
EXTIMATE_ONLY={Y | N}
����ΪYʱ,��������ֻ���������ռ�õĴ��̿ռ�,������ִ�е�����ҵ,ΪNʱ,�������������ռ�õĴ��̿ռ�,����ִ�е�������.
Expdp scott/tiger ESTIMATE_ONLY=y NOLOGFILE=y
7. EXCLUDE*************
��ѡ������ָ��ִ�в���ʱ�ͷ�Ҫ�ų��������ͻ���ض���
EXCLUDE=object_type[:name_clause] [,��.]
Object_type����ָ��Ҫ�ų��Ķ�������,name_clause����ָ��Ҫ�ų��ľ������.EXCLUDE�� INCLUDE����ͬʱʹ��
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dup EXCLUDE=VIEW
8. FILESIZE*************
 ָ�������ļ������ߴ�,Ĭ��Ϊ0,(��ʾ�ļ��ߴ�û������) �������������ļ��������ô�ѡ��
9. FLASHBACK_SCN
     ָ�������ض�SCNʱ�̵ı�����
     FLASHBACK_SCN=scn_value
     Scn_value���ڱ�ʶSCNֵ.FLASHBACK_SCN��FLASHBACK_TIME����ͬʱʹ��
     Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dmp 
     FLASHBACK_SCN=358523
10. FLASHBACK_TIME
       ָ�������ض�ʱ���ı�����
       FLASHBACK_TIME=��TO_TIMESTAMP(time_value)��
       Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dmp FLASHBACK_TIME=
      ��TO_TIMESTAMP(��25-08-2004 14:35:00��,��DD-MM-YYYY HH24:MI:SS��)��
11. FULL
       ָ�����ݿ�ģʽ����,Ĭ��ΪN
       FULL={Y | N}
       ΪYʱ,��ʶִ�����ݿ⵼��.
12. HELP
       ָ���Ƿ���ʾEXPDP������ѡ��İ�����Ϣ,Ĭ��ΪN
       ������ΪYʱ,����ʾ����ѡ��İ�����Ϣ.
       Expdp help=y
13. INCLUDE
       ָ������ʱҪ�����Ķ������ͼ���ض���
       INCLUDE = object_type[:name_clause] [,�� ]
14. JOB_NAME
       ָ��Ҫ�������õ�����,Ĭ��ΪSYS_XXX
       JOB_NAME=jobname_string
15. LOGFILE
ָ��������־�ļ��ļ�������,Ĭ������Ϊexport.log
LOGFILE=[directory_object:]file_name
Directory_object����ָ��Ŀ¼��������,file_name����ָ��������־�ļ���.�����    ָ��directory_object.�������û��Զ�ʹ��DIRECTORY����Ӧѡ��ֵ.
Expdp scott/tiger DIRECTORY=dump DUMPFILE=a.dmp logfile=a.log
16. NETWORK_LINK
       ָ�����ݿ�����,���Ҫ��Զ�����ݿ���󵼳����������̵�ת���ļ���,�������ø�ѡ��.
17. NOLOGFILE
       ��ѡ������ָ����ֹ���ɵ�����־�ļ�,Ĭ��ֵΪN.
18. PARALLEL
  ָ��ִ�е��������Ĳ��н��̸���,Ĭ��ֵΪ1
19. PARFILE
       ָ�����������ļ�������
       PARFILE=[directory_path] file_name
20. QUERY
����ָ�����˵������ݵ�where����
QUERY=[schema.] [table_name:] query_clause
Schema����ָ��������,table_name����ָ������,query_clause����ָ�����������Ӿ�.QUERYѡ�����CONNECT=METADATA_ONLY,EXTIMATE_ONLY,TRANSPORT_TABLESPACES��ѡ��ͬʱʹ��.
Expdp scott/tiger directory=dump dumpfiel=a.dmp
Tables=emp query=��WHERE deptno=20��
21. SCHEMAS
       �÷�������ָ��ִ�з���ģʽ����,Ĭ��Ϊ��ǰ�û�����.
22. STATUS
       ָ����ʾ�������ý��̵���ϸ״̬,Ĭ��ֵΪ0
23. TABLES
ָ����ģʽ����
TABLES=[schema_name.]table_name[:partition_name][,��]
Schema_name����ָ��������,table_name����ָ�������ı���,partition_name����ָ ��Ҫ�����ķ�����.
24. TABLESPACES
       ָ��Ҫ������ռ��б�
25. TRANSPORT_FULL_CHECK
��ѡ������ָ�������Ʊ�ռ��δ���Ʊ�ռ������ϵ�ļ�鷽ʽ,Ĭ��ΪN.
������ΪYʱ,�������û����ռ�ֱ�ӵ�����������ϵ,�����ռ����ڱ�ռ�����������ڵı�ռ�ֻ��һ����ռ䱻����,����ʾ������Ϣ.������ΪNʱ,��������ֻ��鵥������,��������������ڱ�ռ�,��δ���Ʊ����ڱ�ռ�,����ʾ������Ϣ,������Ʊ����ڱ�ռ�,δ�����������ڱ�ռ�,�򲻻���ʾ������Ϣ.
26. TRANSPORT_TABLESPACES
       ָ��ִ�б�ռ�ģʽ����
 
27. VERSION
ָ����������������ݿ�汾,Ĭ��ֵΪCOMPATIBLE.
VERSION={COMPATIBLE | LATEST | version_string}
ΪCOMPATIBLEʱ,����ݳ�ʼ������COMPATIBLE���ɶ���Ԫ����;ΪLATESTʱ,�����            ���ݿ� ��ʵ�ʰ汾���ɶ���Ԫ����.version_string����ָ�����ݿ�汾�ַ���.



--imp������ѡ��
 --IMPDP������ѡ����EXPDP�кܶ���ͬ��,��ͬ����:
ʹ��IMPDP
 IMPDP������ѡ����EXPDP�кܶ���ͬ��,��ͬ����:
1.REMAP_DATAFILE
��ѡ�����ڽ�Դ�����ļ���ת��ΪĿ�������ļ���,�ڲ�ͬƽ̨֮����Ʊ�ռ�ʱ������Ҫ  ��ѡ��.
EMAP_DATAFIEL=source_datafie:target_datafile
2.REMAP_SCHEMA
    ��ѡ�����ڽ�Դ���������ж���װ�ص�Ŀ�귽����.
    REMAP_SCHEMA=source_schema:target_schema
3.REMAP_TABLESPACE
    ��Դ��ռ�����ж����뵽Ŀ���ռ���
    REMAP_TABLESPACE=source_tablespace:target:tablespace
4.REUSE_DATAFILES
    ��ѡ��ָ��������ռ�ʱ�Ƿ񸲸��Ѵ��ڵ������ļ�.Ĭ��ΪN
    REUSE_DATAFIELS={Y | N}
5.SKIP_UNUSABLE_INDEXES
    ָ���������Ƿ���������ʹ�õ�����,Ĭ��ΪN
6.SQLFILE
    ָ��������Ҫָ��������DDL����д�뵽SQL�ű���
    SQLFILE=[directory_object:]file_name
    Impdp scott/tiger DIRECTORY=dump DUMPFILE=tab.dmp SQLFILE=a.sql
7.STREAMS_CONFIGURATION
ָ���Ƿ�����Ԫ����(Stream Matadata),Ĭ��ֵΪY.
8.TABLE_EXISTS_ACTION
��ѡ������ָ�������Ѿ�����ʱ������ҵҪִ�еĲ���,Ĭ��ΪSKIP
TABBLE_EXISTS_ACTION={SKIP | APPEND | TRUNCATE | FRPLACE }�����ø�ѡ��ΪSKIPʱ,������ҵ�������Ѵ��ڱ�����һ������;������ΪAPPENDʱ,��׷  ������,ΪTRUNCATEʱ,������ҵ��ضϱ�,Ȼ��Ϊ��׷��������;������ΪREPLACEʱ,������ҵ��ɾ���Ѵ��ڱ�,�ؽ���׷������,ע��,TRUNCATEѡ�������ر��NETWORK_LINKѡ��
9.TRANSFORM
��ѡ������ָ���Ƿ��޸Ľ��������DDL���
TRANSFORM=transform_name:value[:object_type]
Transform_name����ָ��ת����,����SEGMENT_ATTRIBUTES���ڱ�ʶ������(��������,�洢 ����,��ռ�,��־����Ϣ),STORAGE���ڱ�ʶ�δ洢����,VALUE����ָ���Ƿ���������Ի�δ洢����,object_type����ָ����������.
Impdp scott/tiger directory=dump dumpfile=tab.dmp
Transform=segment_attributes:n:table
10.TRANSPORT_DATAFILES
    ��ѡ������ָ�����ƿռ�ʱҪ�����뵽Ŀ�����ݿ�������ļ�
    TRANSPORT_DATAFILE=datafile_name
    Datafile_name����ָ�������Ƶ�Ŀ�����ݿ�������ļ�
    Impdp system/manager DIRECTORY=dump DUMPFILE=tts.dmp
    TRANSPORT_DATAFILES=��/user01/data/tbs1.f��
