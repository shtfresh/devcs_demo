set serveroutput on;
declare
v_count number;
begin
dbms_output.put_line('begin---------');
select count(1) into v_count from all_tables where TABLE_NAME='EMPLOYEE';
if v_count > 0 then
dbms_output.put_line('drop table EMPLOYEE---------');
execute immediate 'drop table EMPLOYEE';
end if;
end;