SELECT TOP 20
    qs.sql_handle,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
        qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
        (qs.total_worker_time/1000000) / qs.execution_count,
    qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
        qs.total_elapsed_time/1000000,
   st.text,
   qp.query_plan
from
    sys.dm_exec_query_stats as qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
    cross apply sys.dm_exec_query_plan (qs.plan_handle) as qp
ORDER BY qs.total_worker_time desc