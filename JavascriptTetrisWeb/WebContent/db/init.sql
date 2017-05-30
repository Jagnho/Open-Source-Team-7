--drop sequence user_seq;
--drop table user_tb;
create table user_tb (
	id number not null,
	name varchar2(100),
	score number,
	primary key (id)
);
create sequence user_seq start with 1 increment by 1;