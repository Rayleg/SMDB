# task 3 Вывести отдел - начальник, все непосредственные подчинённые

drop procedure if exists print_dept;

delimiter $$

create procedure print_dept( in dep int )
begin
	select * from emps where dept_id = dep and boss_id is null
	union
	select * from emps where boss_id in
		(select id from emps where dept_id = dep and boss_id is null);
end $$

-- Example
-- call print_dept(1);
