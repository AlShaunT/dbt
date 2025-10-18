
{{ config(
    materialized='table',
    schema='dbt_build'
) }}

select 
    ticker, 
    date as report_date, 
    open, 
    high, 
    low, 
    close, 
    adj_close, 
    volume, 
    created_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/Los_Angeles' as created_date_src,
    now() AT TIME ZONE 'America/Los_Angeles' as created_date
from (
    SELECT * FROM {{ source('stockdb', 'ohlcv') }} where date <> '2025-10-15'
    union
    SELECT * FROM {{ source('stockdb', 'ohlcv_delta') }}
) a
