# task 7 Проверить граф подчинения на отсутствие аномалий (двойное подчинение, отсутствие руководителя и т.д.)
# Двойного подчинения быть не может по структуре базы.

drop procedure if exists check_anomaly;

delimiter $$

create procedure check_anomaly()
begin
	# Проверка наличия единственного руководителя у отдела
	declare run int default 1;
	declare dep int;
	declare cur cursor for select dept_id from emps;
	declare continue handler for not found set run = 0;
	drop table if exists log_table;
	create table log_table (
		dept int,
		log varchar(120)
	);
	open cur;
		fetch from cur into dep;
		while run = 1 do
			if (select count(*) from emps where (dept_id = dep) and (boss_id is null)) <> 1 then
				insert into log_table (dept, log) value (dep, 'Wrong number of department bosses');
			end if;
			fetch next from cur into dep;
		end while;
	close cur;
	# Проверка, что у подчиненных отдел совпадает с отделом руководителя
	--
	# Сообщение о корректности базы, если не найдено аномалий
	if (select count(8) from log_table) = 0 then
		insert into log_table value (null, '404: Anomaly not found');
	end if;
	select * from log_table;
	drop table log_table;
end $$

-- Example
-- call check_anomaly();

