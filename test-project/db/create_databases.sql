drop database if exists db_charmer_sandbox_test;
create database db_charmer_sandbox_test;

drop database if exists db_charmer_logs_test;
create database db_charmer_logs_test;

drop database if exists db_charmer_enrollments_test;
create database db_charmer_enrollments_test;

drop database if exists db_charmer_events_test_shard01;
create database db_charmer_events_test_shard01;

drop database if exists db_charmer_events_test_shard02;
create database db_charmer_events_test_shard02;

drop database if exists db_charmer_schools_shard_one;
create database db_charmer_schools_shard_one;

drop database if exists db_charmer_schools_shard_two;
create database db_charmer_schools_shard_two;

grant all privileges on db_charmer_sandbox_test.* to 'db_charmer_ro'@'localhost';
