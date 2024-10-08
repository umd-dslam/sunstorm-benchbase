CREATE EXTENSION IF NOT EXISTS remotexact;

DROP TABLE IF EXISTS history CASCADE;
DROP TABLE IF EXISTS new_order CASCADE;
DROP TABLE IF EXISTS order_line CASCADE;
DROP TABLE IF EXISTS oorder CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS district CASCADE;
DROP TABLE IF EXISTS stock CASCADE;
DROP TABLE IF EXISTS item CASCADE;
DROP TABLE IF EXISTS warehouse CASCADE;

CREATE TABLE warehouse (
    w_id       int            NOT NULL,
    w_ytd      decimal(12, 2) NOT NULL,
    w_tax      decimal(4, 4)  NOT NULL,
    w_name     varchar(10)    NOT NULL,
    w_street_1 varchar(20)    NOT NULL,
    w_street_2 varchar(20)    NOT NULL,
    w_city     varchar(20)    NOT NULL,
    w_state    char(2)        NOT NULL,
    w_zip      char(9)        NOT NULL,
    PRIMARY KEY (w_id)
) PARTITION BY RANGE (w_id);

CREATE TABLE warehouse_1 PARTITION OF warehouse FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'warehouse_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'warehouse_1_pkey';

CREATE TABLE warehouse_2 PARTITION OF warehouse FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'warehouse_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'warehouse_2_pkey';


CREATE TABLE item (
    i_id    int           NOT NULL,
    i_name  varchar(24)   NOT NULL,
    i_price decimal(5, 2) NOT NULL,
    i_data  varchar(50)   NOT NULL,
    i_im_id int           NOT NULL,
    PRIMARY KEY (i_id)
);

CREATE TABLE stock (
    s_w_id       int           NOT NULL,
    s_i_id       int           NOT NULL,
    s_quantity   int           NOT NULL,
    s_ytd        decimal(8, 2) NOT NULL,
    s_order_cnt  int           NOT NULL,
    s_remote_cnt int           NOT NULL,
    s_data       varchar(50)   NOT NULL,
    s_dist_01    char(24)      NOT NULL,
    s_dist_02    char(24)      NOT NULL,
    s_dist_03    char(24)      NOT NULL,
    s_dist_04    char(24)      NOT NULL,
    s_dist_05    char(24)      NOT NULL,
    s_dist_06    char(24)      NOT NULL,
    s_dist_07    char(24)      NOT NULL,
    s_dist_08    char(24)      NOT NULL,
    s_dist_09    char(24)      NOT NULL,
    s_dist_10    char(24)      NOT NULL,
    FOREIGN KEY (s_w_id) REFERENCES warehouse (w_id) ON DELETE CASCADE,
    FOREIGN KEY (s_i_id) REFERENCES item (i_id) ON DELETE CASCADE,
    PRIMARY KEY (s_w_id, s_i_id)
) PARTITION BY RANGE (s_w_id);

CREATE TABLE stock_1 PARTITION OF stock FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'stock_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'stock_1_pkey';

CREATE TABLE stock_2 PARTITION OF stock FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'stock_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'stock_2_pkey';

CREATE TABLE district (
    d_w_id      int            NOT NULL,
    d_id        int            NOT NULL,
    d_ytd       decimal(12, 2) NOT NULL,
    d_tax       decimal(4, 4)  NOT NULL,
    d_next_o_id int            NOT NULL,
    d_name      varchar(10)    NOT NULL,
    d_street_1  varchar(20)    NOT NULL,
    d_street_2  varchar(20)    NOT NULL,
    d_city      varchar(20)    NOT NULL,
    d_state     char(2)        NOT NULL,
    d_zip       char(9)        NOT NULL,
    FOREIGN KEY (d_w_id) REFERENCES warehouse (w_id) ON DELETE CASCADE,
    PRIMARY KEY (d_w_id, d_id)
) PARTITION BY RANGE (d_w_id);

CREATE TABLE district_1 PARTITION OF district FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'district_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'district_1_pkey';

CREATE TABLE district_2 PARTITION OF district FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'district_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'district_2_pkey';

CREATE TABLE customer (
    c_w_id         int            NOT NULL,
    c_d_id         int            NOT NULL,
    c_id           int            NOT NULL,
    c_discount     decimal(4, 4)  NOT NULL,
    c_credit       char(2)        NOT NULL,
    c_last         varchar(16)    NOT NULL,
    c_first        varchar(16)    NOT NULL,
    c_credit_lim   decimal(12, 2) NOT NULL,
    c_balance      decimal(12, 2) NOT NULL,
    c_ytd_payment  float          NOT NULL,
    c_payment_cnt  int            NOT NULL,
    c_delivery_cnt int            NOT NULL,
    c_street_1     varchar(20)    NOT NULL,
    c_street_2     varchar(20)    NOT NULL,
    c_city         varchar(20)    NOT NULL,
    c_state        char(2)        NOT NULL,
    c_zip          char(9)        NOT NULL,
    c_phone        char(16)       NOT NULL,
    c_since        timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    c_middle       char(2)        NOT NULL,
    c_data         varchar(500)   NOT NULL,
    FOREIGN KEY (c_w_id, c_d_id) REFERENCES district (d_w_id, d_id) ON DELETE CASCADE,
    PRIMARY KEY (c_w_id, c_d_id, c_id)
) PARTITION BY RANGE (c_w_id);

CREATE TABLE customer_1 PARTITION OF customer FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'customer_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'customer_1_pkey';
CREATE INDEX idx_customer_name_1 ON customer_1 (c_w_id, c_d_id, c_last, c_first);
UPDATE pg_class SET relregion = 1 WHERE relname = 'idx_customer_name_1';

CREATE TABLE customer_2 PARTITION OF customer FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'customer_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'customer_2_pkey';
CREATE INDEX idx_customer_name_2 ON customer_2 (c_w_id, c_d_id, c_last, c_first);
UPDATE pg_class SET relregion = 2 WHERE relname = 'idx_customer_name_2';

CREATE TABLE history (
    h_c_id   int           NOT NULL,
    h_c_d_id int           NOT NULL,
    h_c_w_id int           NOT NULL,
    h_d_id   int           NOT NULL,
    h_w_id   int           NOT NULL,
    h_date   timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    h_amount decimal(6, 2) NOT NULL,
    h_data   varchar(24)   NOT NULL,
    FOREIGN KEY (h_c_w_id, h_c_d_id, h_c_id) REFERENCES customer (c_w_id, c_d_id, c_id) ON DELETE CASCADE,
    FOREIGN KEY (h_w_id, h_d_id) REFERENCES district (d_w_id, d_id) ON DELETE CASCADE
) PARTITION BY RANGE (h_w_id);

CREATE TABLE history_1 PARTITION OF history FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'history_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'history_1_pkey';

CREATE TABLE history_2 PARTITION OF history FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'history_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'history_2_pkey';

CREATE TABLE oorder (
    o_w_id       int       NOT NULL,
    o_d_id       int       NOT NULL,
    o_id         int       NOT NULL,
    o_c_id       int       NOT NULL,
    o_carrier_id int                DEFAULT NULL,
    o_ol_cnt     int       NOT NULL,
    o_all_local  int       NOT NULL,
    o_entry_d    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (o_w_id, o_d_id, o_id),
    FOREIGN KEY (o_w_id, o_d_id, o_c_id) REFERENCES customer (c_w_id, c_d_id, c_id) ON DELETE CASCADE,
    UNIQUE (o_w_id, o_d_id, o_c_id, o_id)
) PARTITION BY RANGE (o_w_id);

CREATE TABLE oorder_1 PARTITION OF oorder FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'oorder_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'oorder_1_pkey';
UPDATE pg_class SET relregion = 1 WHERE relname = 'oorder_1_o_w_id_o_d_id_o_c_id_o_id_key';
CREATE INDEX idx_order_1 ON oorder_1 (o_w_id, o_d_id, o_c_id, o_id);
UPDATE pg_class SET relregion = 1 WHERE relname = 'idx_order_1';

CREATE TABLE oorder_2 PARTITION OF oorder FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'oorder_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'oorder_2_pkey';
UPDATE pg_class SET relregion = 1 WHERE relname = 'oorder_2_o_w_id_o_d_id_o_c_id_o_id_key';
CREATE INDEX idx_order_2 ON oorder_2 (o_w_id, o_d_id, o_c_id, o_id);
UPDATE pg_class SET relregion = 2 WHERE relname = 'idx_order_2';

CREATE TABLE new_order (
    no_w_id int NOT NULL,
    no_d_id int NOT NULL,
    no_o_id int NOT NULL,
    FOREIGN KEY (no_w_id, no_d_id, no_o_id) REFERENCES oorder (o_w_id, o_d_id, o_id) ON DELETE CASCADE,
    PRIMARY KEY (no_w_id, no_d_id, no_o_id)
) PARTITION BY RANGE (no_w_id);

CREATE TABLE new_order_1 PARTITION OF new_order FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'new_order_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'new_order_1_pkey';

CREATE TABLE new_order_2 PARTITION OF new_order FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'new_order_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'new_order_2_pkey';

CREATE TABLE order_line (
    ol_w_id        int           NOT NULL,
    ol_d_id        int           NOT NULL,
    ol_o_id        int           NOT NULL,
    ol_number      int           NOT NULL,
    ol_i_id        int           NOT NULL,
    ol_delivery_d  timestamp     NULL DEFAULT NULL,
    ol_amount      decimal(6, 2) NOT NULL,
    ol_supply_w_id int           NOT NULL,
    ol_quantity    decimal(6,2)  NOT NULL,
    ol_dist_info   char(24)      NOT NULL,
    FOREIGN KEY (ol_w_id, ol_d_id, ol_o_id) REFERENCES oorder (o_w_id, o_d_id, o_id) ON DELETE CASCADE,
    FOREIGN KEY (ol_supply_w_id, ol_i_id) REFERENCES stock (s_w_id, s_i_id) ON DELETE CASCADE,
    PRIMARY KEY (ol_w_id, ol_d_id, ol_o_id, ol_number)
) PARTITION BY RANGE (ol_w_id);

CREATE TABLE order_line_1 PARTITION OF order_line FOR VALUES FROM (0) TO (10);
UPDATE pg_class SET relregion = 1 WHERE relname = 'order_line_1';
UPDATE pg_class SET relregion = 1 WHERE relname = 'order_line_1_pkey';

CREATE TABLE order_line_2 PARTITION OF order_line FOR VALUES FROM (10) TO (20);
UPDATE pg_class SET relregion = 2 WHERE relname = 'order_line_2';
UPDATE pg_class SET relregion = 2 WHERE relname = 'order_line_2_pkey';
