{{ config(
    materialized = 'incremental',
    unique_key = 'page_view_id'
) }}

-- page_view_id 是自動生成的每筆資料的 unique id, 用這個當作去除重複的 unique key

with events as (
    select * from {{ source('jaffle_shop', 'events') }}
    {% if is_incremental() %}
    where anonymous_user_id in (
        select distinct anonymous_user_id from {{ source('snowplow', 'events') }}
        where event_timestamp >= (select dateadd('day', -3, max(event_timestamp)::date) from {{ this }})
    )
    {% endif %}
),

page_views as (
    select * from events
    where event = 'page_view'
),
aggregated_page_events as (
    select
        page_view_id,
        count(*) * 10 as approx_time_on_page,
        min(derived_tstamp) as page_view_start,
        max(collector_tstamp) as max_collector_tstamp
    from events
    group by 1
),
joined as (
    select
        *
    from page_views
    left join aggregated_page_events using (page_view_id)
)
select * from joined