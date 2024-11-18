CREATE TABLE jaffle_shop.events (
    page_view_id SERIAL PRIMARY KEY,      -- 唯一標識頁面視圖，主鍵
    event TEXT NOT NULL,                 -- 事件類型
    collector_tstamp TIMESTAMP NOT NULL, -- 收集時間
    derived_tstamp TIMESTAMP NOT NULL,   -- 衍生時間
    other_field TEXT                     -- 其他相關數據
);

INSERT INTO jaffle_shop.events (event, collector_tstamp, derived_tstamp, other_field) VALUES
('page_view', '2024-01-01 10:00:00', '2024-01-01 09:59:55', 'data_1'),
('page_view', '2024-01-01 10:05:00', '2024-01-01 10:04:50', 'data_2'),
('page_view', '2024-01-01 10:10:00', '2024-01-01 10:09:58', 'data_3'),
('click', '2024-01-01 10:15:00', '2024-01-01 10:14:50', 'data_4'),
('page_view', '2024-01-01 10:20:00', '2024-01-01 10:19:59', 'data_5'),
('purchase', '2024-01-01 10:25:00', '2024-01-01 10:24:55', 'data_6');

select * from jaffle_shop.events