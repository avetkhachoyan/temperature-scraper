CREATE DATABASE IF NOT EXISTS tsData;
USE tsData;
CREATE TABLE IF NOT EXISTS tsCityData (
    id bigint PRIMARY KEY AUTO_INCREMENT,
    tsDBInsertTime TIMESTAMP,
    tsDateNTime varchar(255) NOT NULL,
    tsCity varchar(255) NOT NULL,
    tsIPFS varchar(255) NOT NULL,
    UNIQUE KEY name__unique_idx (tsIPFS)
);