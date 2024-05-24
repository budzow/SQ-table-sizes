
--------------------------------------------------------------------------------
-- Postgres --------------------------------------------------------------------
--------------------------------------------------------------------------------
-- analyze to have a correct estimate
ANALYZE;
-- get rows per table
select relname as table_name, n_live_tup as rows_number from pg_stat_user_tables order by n_live_tup desc;
-- get table sizes
select relname as table_name, pg_size_pretty(pg_total_relation_size(relid)) as table_size from pg_catalog.pg_statio_user_tables order by pg_total_relation_size(relid) desc
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- SQL Server ------------------------------------------------------------------
--------------------------------------------------------------------------------
-- refresh stats
execute sp_updatestats;
-- get rows per table
select t.name table_name, i.rows rows_number from sysobjects t, sysindexes i where t.xtype = 'U' and i.id = t.id and i.indid in (0,1) order by rows_number desc;
-- get table sizes

-- get rows number and table size in one query
SELECT
t.name AS table_name,
p.rows AS RowCounts,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name, s.Name, p.Rows
ORDER BY p.rows desc





--------------------------------------------------------------------------------
-- Oracle ----------------------------------------------------------------------
--------------------------------------------------------------------------------
-- refresh stats
EXEC dbms_stats.gather_schema_stats('<SQ_USER_NAME>', cascade=>TRUE);
select table_name, num_rows as rows_number from user_tables where table_name in (select table_name from user_tables) order by rows_number desc;
-- get table sizes
select segment_name as table_name, bytes as table_size from user_segments where segment_type = 'TABLE' order by bytes desc;