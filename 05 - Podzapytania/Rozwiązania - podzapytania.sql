--1
select
	e.first_name,
	e.last_name,
	j.job_title
	from employees e join jobs j on e.job_id = j.job_id
where
	e.department_id = 
	(select department_id 
		from employees where last_name ='Jackson')

--2
select
	*
	from employees
where hire_date = 
		(
			select min(hire_date) from employees
			where job_id = 'FI_ACCOUNT')
and job_id = 'FI_ACCOUNT'

--3
select
    e.first_name,
    e.last_name,
    e.department_id,
    e.hire_date
    from employees e 
where e.hire_date = (select min(hire_date) from employees
						where department_id = e.department_id
						  )
order by e.hire_Date

--4
select * from jobs
where
	job_id in (select job_id from employees
					where department_id not in (select department_id
												from departments
												where 
												department_name='Marketing'))
												
--5
select e.first_name, e.last_name, e.salary
        from employees e
where salary > (select avg(salary) from employees
                    where department_id = e.department_id)

--6
select e.first_name, e.last_name, e.salary
        from employees e
where salary >= (select salary*0.85 from employees
                    where employee_id = e.manager_id)

--7
select
	*
	from employees e
where
	job_id = 'IT_PROG'
	and hire_date > '2015-12-31'
	and manager_id !=
		(select employee_id from employees
			where department_id =10)						
												
--8
select
    e.first_name,
    e.last_name
    from employees e 
    where not exists (select 1 from departments where department_id = e.department_id)
	
	
--9
select
    e.department_id
    from employees e 
group by  e.department_id
having sum(e.salary) >= all (select sum(salary) from employees 
                                                group by department_id)
									
--10
select
    e.first_name,
    e.last_name
    from employees e 
where e.salary 
    not between (select min_salary from jobs
                            where job_title = 'Sales Representative')
            and (select max_salary from jobs
                            where job_title = 'Sales Representative')
order by 1

--11
select 
	last_name,
	salary
from employees e 
where 
	department_id in (
		select 	
			department_id 
			from departments d
		where 
			location_id in (select location_id from locations l 
								where l.city in ('Toronto', 'Oxford','Munich')))
and salary > 10000
and charindex ('y', last_name) > 0