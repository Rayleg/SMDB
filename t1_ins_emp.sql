# task 1 Добавить сотрудника

drop function if exists ins_emp;

delimiter $$

CREATE FUNCTION ins_emp( n varchar(45), bi int )
RETURNS varchar(80)
BEGIN
	DECLARE var varchar(80);
	DECLARE _id integer;
	

	if (select count(*) from `emploee`.emps where id = bi) = 0 then
		return 'bad';
	else
		set _id = (select dept_id as di from `emploee`.emps where id = bi);
		insert into `emploee`.emps (name, dept_id, boss_id) value (n, _id, bi);
		return 'ok';
	end if;
END
$$

-- Example
-- call ins_emp('Vasiliy', 3);