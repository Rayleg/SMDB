# task 10 Вывести "путь" между двумя сотрудниками - всех непосредственных и промежуточных руководителей сотрудников

drop procedure if exists path;
drop procedure if exists out_rang;
drop procedure if exists print_bosses_rec;
drop procedure if exists get_boss;

delimiter $$

create procedure print_bosses_rec( e_id int )
begin
	declare b_id int;
	declare run int default 1;
	declare emp_id int;
	declare emp_name varchar(80);
	declare cur cursor for select id, name from emps where id = e_id;
	declare continue handler for not found set run = 0;
	open cur;
	fetch from cur into emp_id, emp_name;
	while run <> 0 do
		set b_id = (select boss_id from emps where id = emp_id limit 1);
		insert into tmp_tbl (id, name) value (emp_id, emp_name);
		if (b_id is not null) then
			call print_bosses_rec(b_id);
		end if;
		fetch next from cur into emp_id, emp_name;
	end while;
	close cur;
end $$

create procedure out_rang( e_id int, out num int )
begin
	drop table if exists tmp_tbl;
	create table tmp_tbl (
		id int,
		name varchar(80)
	);

	call print_bosses_rec(e_id);
	set num = (select count(*) from tmp_tbl);
	drop table if exists tmp_tbl;
end $$


create procedure get_boss( in e_id int, in lvl int, out b_id int, out res varchar(200), in inv boolean )
begin
	declare emp_name varchar(80);
	declare emp_id int default e_id;

	set res = '';
	while (lvl > 0) and (emp_id is not null) do
		select boss_id, name into emp_id, emp_name from emps where id = e_id;
		if inv then
			set res = concat(emp_name, concat(' ', res));
		else
			set res = concat(res, concat(' ', emp_name));
		end if;
		set e_id = emp_id;
		set lvl = lvl - 1;
	end while;
	set b_id = emp_id;
end $$

create procedure path( e1_id int, e2_id int )
begin
	declare n1, n2, b1, b2 int;
	declare e1_name, e2_name varchar(80);
	declare res1, res2 varchar(200) default '';
	# Проверка, что у служащих один отдел
	if (select dept_id from emps where id = e1_id limit 1) <> (select dept_id from emps where id = e2_id) then
		select 'No common head because if different department';
	else
		# Выравнивание по уровню подчинения
		call out_rang(e1_id, n1);
		call out_rang(e2_id, n2);
		if (n1 > n2) then
			call get_boss(e1_id, n1 - n2, b1, res1, false);
			set e1_id = b1;
		elseif (n2 > n1) then
			call get_boss(e2_id, n2 - n1, b2, res2, true);
			set e2_id = b2;
		end if;
		# Нахождение общего руководителя
		set b1 = e1_id;
		set b2 = e2_id;
		while (b1 <> b2) do
			select boss_id, name into b1, e1_name from emps where id = e1_id;
			select boss_id, name into b2, e2_name from emps where id = e2_id;
			set res1 = concat(res1, concat(' ', e1_name));
			set res2 = concat(e2_name, concat(' ', res2));
			set e1_id = b1;
			set e2_id = b2;
		end while;
		select name into e1_name from emps where id = b1;
		select concat(res1, concat(' ', concat(e1_name, concat(' ', res2))));
	end if;
end $$

-- Example
delimiter ;

set max_sp_recursion_depth = 100;
call path(2, 13);