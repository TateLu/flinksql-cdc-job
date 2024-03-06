
CREATE TABLE `mysql_source` (
    id      STRING,
    name    STRING,
    PRIMARY KEY(id) NOT ENFORCED
)
WITH (
    'connector' = 'mysql-cdc',
    ${dbserver1},
    'database-name' = 'test',
    'table-name' = 'demo',
    'server-time-zone' = 'Asia/Shanghai',
    'scan.startup.mode' = 'initial',
    'scan.snapshot.fetch.size' = '10240',
    'scan.incremental.close-idle-reader.enabled' = 'true'
);


CREATE TABLE `mysql_sink` (
    name      VARCHAR,
    total    BIGINT NOT NULL,
    PRIMARY KEY(name) NOT ENFORCED
)
WITH (
    'connector' = 'jdbc',
    ${dbserver2},
    'table-name' = 'demo_sum'
);

insert into mysql_sink select name, count(1) as total from mysql_source group by name;