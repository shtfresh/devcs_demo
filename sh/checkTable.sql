declare
v_count number;
begin
select count(1) into v_count from all_tables where TABLE_NAME='EMPLOYEE';
if v_count > 0 then
execute immediate 'drop table EMPLOYEE';
end if;
end;