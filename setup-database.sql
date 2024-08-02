CREATE DATABASE vexeexpress;

\c vexeexpress;

-- Tạo các bảng trong schema public
\i /docker-entrypoint-initdb.d/src/data_tables.sql
