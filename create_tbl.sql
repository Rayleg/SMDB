create table emps
(
	id serial	PRIMARY key,
	name	varchar(45),
	dept_id int,
	boss_id int references emps(id)
);

