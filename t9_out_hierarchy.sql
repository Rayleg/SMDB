# task 9 Вывести иерархию в графическом виде
# 	одно значение - на одной строке, отсортировано в порядке подчинения,
# 	количество отступов перед именем сотрудника - степень подчинения в иерархии

drop procedure if exists out_hierarchy;
drop procedure if exists out_dep_hier;
drop procedure if exists out_emp_list;

delimiter $$

create procedure out_emp_list( b_id int, ofs varchar(200) )
begin
	declare run int default 1;
	declare e_id int;
	declare e_name varchar(80);
	declare dcur cursor for select id, name from emps where boss_id = b_id;
	declare continue handler for not found set run = 0;
	open dcur;
		fetch from dcur into e_id, e_name;
		while run = 1 do
			insert into hier value (CONCAT(ofs, e_name));
			call out_emp_list(e_id, CONCAT(ofs, '  '));
			fetch next from dcur into  e_id, e_name;
		end while;
	close dcur;
end $$

create procedure out_dep_hier( dep int )
begin
	declare run int default 1;
	declare e_id int;
	declare e_name varchar(80);
	declare dcur cursor for select id, name from emps where (dept_id = dep) and (boss_id is null);
	declare continue handler for not found set run = 0;
	open dcur;
		fetch from dcur into e_id, e_name;
		while run = 1 do
			insert into hier value(e_name);
			call out_emp_list(e_id, '  ');
			fetch next from dcur into  e_id, e_name;
		end while;
	close dcur;
end $$

create procedure out_hierarchy()
begin
	declare run int default 1;
	declare dep int;
	declare dep_cur cursor for select distinct dept_id from emps;
	declare continue handler for not found set run = 0;

	drop table if exists hier;
	create table hier (
		name varchar(80)
	);
	open dep_cur;
		fetch from dep_cur into dep;
		while run = 1 do
			call out_dep_hier(dep);
			fetch next from dep_cur into dep;
		end while;
	close dep_cur;
	select * from hier;
	drop table hier;
end $$

-- Example
call out_hierarchy();