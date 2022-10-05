
-- 1. �������� ��� � ������� �����������, � ������� �������� �� ������ � 
--�������� �� ����������� �� ������������ ������ �������� ��������������� �� ���������.

select emp.first_name
	, emp.last_name
from PortfolioProject.dbo.EMP as emp
join PortfolioProject.dbo.JOB as job on emp.job_id = job.job_id
where emp.sal not between job.min_sal and job.max_sal



-- 2. �������� ��� � ������� �����������, ������� �� ����� ������ � 
--�������� ������� ��������� �� ����� 3 ��� (�.�. �������� �� 3 ������ ����������).

with Result (emp_id, first_name, last_name, count)
as
(
select job_hist.emp_id
	, emp.first_name
	, emp.last_name
	, count(job_hist.emp_id) over() as count
from PortfolioProject.dbo.EMP as emp
join PortfolioProject.dbo.JOB_HIST as job_hist on emp.emp_id = job_hist.emp_id
)
select first_name
	, last_name
from Result
where count >= 3



-- 3. �� ���� �����������, ������� ������ ����� �����������, �������� ������� � 
--���� ����� ����� �����������, � ����� ������� � ���� ����� �� �����������.

select distinct emp.last_name
	, emp.hire_date
	, emp1.last_name
	, emp1.hire_date
from PortfolioProject.dbo.EMP as emp, PortfolioProject.dbo.EMP as emp1 
where emp.emp_id != emp1.emp_id and emp.hire_date < emp1.hire_date





-- 4. ������� ���� �����������, ������� �������� � ������ �������, �� ����� ���������� ��������. 
--������� ����� ������ � ������� ������� ����������, ����� ������ � ������� ������� ����������, ��������. 
--��������� ������������ ���, �.�. ���� �������� ���� ������ � ������, �� �� �������� ���� ������ � ������.

select distinct emp.dep_id
	, emp.last_name
	, emp1.dep_id
	, emp1.last_name
	, emp.sal
from PortfolioProject.dbo.EMP as emp, PortfolioProject.dbo.EMP as emp1 
where emp.sal = emp1.sal and emp.emp_id != emp1.emp_id and emp.dep_id != emp1.dep_id




---8. �������� ����������� �������� � ������ ��������, �.�. �������� �� 10 �� 12 ��������
--, �� �������� ������� � ������.
--��������� �� � ������� ������� +7(���)���-��-��.
--????????????????????????????????????????????????????????????????????????????????????

--SELECT right(CAST(phone AS VARCHAR(12)), 10)
--from PortfolioProject.dbo.EMP

select 
	format(
		cast(RIGHT(phone, 10) AS bigint),
		'+7(###)###-##-##'
	)
from PortfolioProject.dbo.EMP


--SELECT RIGHT(+89063667886, 10) as text FROM PortfolioProject.dbo.EMP
--(CONVERT(nvarchar(12), phone))

--update telephone set telephone_number=case when len(telephone_number)=14 then telephone_number
--else concat('001 ',right(telephone_number,10)) end





--WITH
--cteTally10 AS (
--     SELECT * FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS numbers(number)
--),
--cteTally100 AS (
--     SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS number
--     FROM cteTally10 c1
--     CROSS JOIN cteTally10 c2
--)
--SELECT *
--FROM #data d
--CROSS APPLY (
--     SELECT ((SELECT 
--         CASE WHEN SUBSTRING(phone_number, t.number, 1) LIKE '[0-9]' THEN '9'
--            WHEN SUBSTRING(phone_number, t.number, 1) LIKE '[ .-]' THEN 'D'
--            WHEN SUBSTRING(phone_number, t.number, 1) LIKE '[+()]' THEN
--            SUBSTRING(phone_number, t.number, 1)
--          ELSE '?' END + ''
--    FROM cteTally100 t
--    WHERE t.number BETWEEN 1 AND LEN(phone_number)
--    FOR XML PATH(''))) AS phone_pattern
--) AS alias1


--6. ��� ������� ������ ������� ����� ��� ����� ������� �������.
--���� � ������ � ���������� ����������� ���������� ��������, 
--�� ���������� ��������� ����� �������� ������ ���� ���.

--SELECT salary  
--FROM (SELECT salary FROM Employee ORDER BY salary DESC LIMIT 2) AS emp ORDER BY salary LIMIT 1;


--SELECT top 3
--	dep_id
--	,sum(sal)
--FROM PortfolioProject.dbo.EMP as emp
--group by dep_id


select dep_id
	,sum(sal) 
from 
(select DISTINCT
	dep_id
	, sal
	, ROW_NUMBER() over (partition by dep_id order by sal desc) as salary_rank
from PortfolioProject.dbo.EMP as emp
group by dep_id, sal
) as EMP
where salary_rank in (1,2,3)
group by dep_id




-- 5. ������� ������ �����������, ��������� ������� ��������� � ����������, 
--������� ��� �������� ��� ������ �� ������. 
--������� �������, ������ ��������� ���������� � ���� �������� ��������� � 
--������� ���������� ���������� � ���� ��������.


select first_name
	, last_name
from
(select distinct 
	emp.first_name
	, emp.last_name
	, first_value(emp.job_id) over (partition by emp.emp_id order by emp.hire_date) as first
	, last_value(emp.job_id) over (partition by emp.emp_id order by emp.hire_date) as last
from PortfolioProject.dbo.EMP as emp 
) as tab
where first = last



--7. ������� � ������ ������ ���������� �����������, �������� � ������ �� ���� 2022 ����. 
--???????????????????????????????????????????????????????????????????????????????????

select dep_id
	, (hired_jan_cnt + hired_feb_cnt + hired_mar_cnt) as hired
from zadanie_7



--9. �������� ����� �������� ������ �� ������ ����������:
--�������� �������� ������, � ������� ������� ������� ������, ��� ������� �������� � ������ �������.
--���������� �������� ������, � ������� ���������� ���������� �����������, ���������� ������ 5 ��� � ��������.
--�������� ������ ������� � �������� ����������.




--10. ����� ����� ���� ����� ������� ������� � ������ �����������. 
--������� �������, � ���� ������ �� ���������� ����� ����������, �� �� � ����� ����� 
--������� ���������� ����� ����������.

