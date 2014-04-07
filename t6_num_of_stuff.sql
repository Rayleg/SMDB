# task 6 - Вывести количество сотрудников в отделе

drop procedure if exists num_of_stuff;

delimiter $$

create procedure num_of_stuff( dep int )
begin
	select count(*) from emps where dept_id = dep;
end $$

-- Example
-- call num_of_stuff(2);