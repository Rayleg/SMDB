# task 5 Вывести список подчинения - руководитель, руководитель руководителя, и т.д. до вершины иерархии

drop procedure if exists print_bosses;
drop procedure if exists print_bosses_rec;

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

create procedure print_bosses( e_id int )
begin
	drop table if exists tmp_tbl;
	create table tmp_tbl (
		id int,
		name varchar(80)
	);

	call print_bosses_rec(e_id);
	select * from tmp_tbl;
	drop table if exists tmp_tbl;
end $$

-- Example
-- set max_sp_recursion_depth = 100;
-- call print_bosses(8);