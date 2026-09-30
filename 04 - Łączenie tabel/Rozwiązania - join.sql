--1
select
	e.first_name,
	e.last_name,
	e.department_id,
	j.job_title
	from employees e join jobs j on e.job_id = j.job_id
					 join departments d on e.department_id=d.department_id


--2
select
	e.first_name,
	e.last_name,
	l.city
	from employees e join departments d on e.department_id=d.department_id
					 join locations l on d.location_id=l.location_id
where
	l.city in ('London','Toronto')

--3
select 
	e.last_name,
	d.department_name 
	from employees e right join departments d on e.department_id =d.department_id
where 
	d.department_name not in ('Opertations')

--4
select 
	l.city,
	count(e.employee_id) ilosc_pracownikow
	from employees e join departments d on e.department_id =d.department_id
					 right join locations l on d.location_id = l.location_id 
where l.city in ('Stretford',
'Bombay',
'Sydney',
'London',
'Munich',
'Seattle')
group by l.city

/*
5. Pokaż liczbę pracowników, którzy nie pracują w prowincji stanowej, zaczynając od
litery T (1 wiersz) (1 wiersz)
*/

select
count(employee_id) counter
from employees e join departments d on e.department_id = d.department_id
			   	 join locations l on d.location_id = l.location_id
where
	--state_province not like 't%'
	--left(l.state_province,1) != 't'
	SUBSTRING(upper(l.state_province),1,1) ! = 'T'

--6
select
    e.first_name,
	e.last_name,
	j.job_title,
    (salary + (salary * isnull(commission_pct,0))) * 12 year_income
    from employees e join jobs j on e.job_id = j.job_id
where 
	j.job_title in ('Accountant','Purchasing Clerk')
	and (salary + (salary * isnull(commission_pct,0))) * 12 > 37200


--7
select 
    e.first_name boss_first_name,
    e.last_name boss_last_name,
    b.first_name,
    b.last_name 
    from employees e join employees b on e.employee_id = b.manager_id
	
--8
select 
    e.first_name boss_first_name,
    e.last_name boss_last_name,
    b.first_name,
    b.last_name 
    from employees e right join employees b on e.employee_id = b.manager_id


--9
select
    d.department_name,
    count(*) counter,
    CONCAT(cast(round(avg(e.salary),2) as money) , ' zł') avg
    from employees e join departments d on  e.department_id = d.department_id
group by d.department_name

--10
select
    j.job_title,
    count(*) counter
    from employees e join jobs j on e.job_id = j.job_id    				 
group by 
    j.job_title
having 
	count(*) > 10
order by 2 desc


--11
select
    d.department_name,
    sum(salary + (salary * coalesce(commission_pct,0))) result
    from employees e join departments d on  e.department_id = d.department_id
group by d.department_name












