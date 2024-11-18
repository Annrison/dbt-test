CREATE TABLE jaffle_shop.products (
    id SERIAL PRIMARY KEY,
    cogs INTEGER,
    price INTEGER,
    product_name TEXT,
    is_active BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO jaffle_shop.products (id, cogs, price, product_name, is_active, created_at, updated_at) VALUES
(3, 4, 9, 'jaffle royale', true, '2018-10-01 00:00:00', '2018-10-01 00:00:00'),
(4, 5, 11, 'jaffle supreme', true, '2019-10-01 00:00:00', '2019-10-01 00:00:00'),
(5, 3, 7, 'blt', true, '2018-03-10 00:00:00', '2018-03-10 00:00:00'),
(6, 3, 7, 'avo love-o', true, '2018-03-10 00:00:00', '2018-03-10 00:00:00'),
(7, 3, 8, 'reuben', true, '2018-09-15 00:00:00', '2018-09-15 00:00:00'),
(8, 5, 12, 'lunch combo', true, '2018-06-01 00:00:00', '2018-06-01 00:00:00'),
(9, 10, 25, 'jafflers dozen', true, '2019-06-01 00:00:00', '2019-06-01 00:00:00'),
(10, 4, 6, 'fried ice cream jaffle', true, '2018-01-01 00:00:00', '2020-10-28 17:42:26');
