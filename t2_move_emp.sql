# task 2 Перевести сотрудника из отдела в отдел. В случае перевода руководителя, переводятся все его подчинённые

drop procedure if exists move_emp;

delimiter $$

create procedure move_emp( e_id int, dep int )
begin
	declare run, c_id int;
	declare cur cursor for select id from emps where boss_id = e_id;
	declare continue handler for not found set run = 0;
	open cur;
		set run = 1;
		fetch from cur into c_id;
		while run = 1 do
			call move_emp(c_id, dep);
			fetch next from cur into c_id;
		end while;
	close cur;
	update emps set dept_id = dep where id = e_id;
	
end $$

-- Example
-- call move_emp(1, 3);