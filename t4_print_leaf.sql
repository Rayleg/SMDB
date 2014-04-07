# task 4 Вывести список всех "листовых" узлов дерева (сотрудники не имеющие подчинённых)

drop procedure if exists print_leaf;

delimiter $$

create procedure print_leaf()
begin
	select * from emps where id not in (select id from emps where id in (select boss_id from emps));
end $$

delimiter ;

-- Example
-- call print_leaf();