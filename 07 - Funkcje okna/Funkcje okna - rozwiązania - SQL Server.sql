--1
SELECT
    year(hire_date) rok,
    count(*)AS ilosc_zatrudnien,
    sum(count(*))OVER( ORDER BY year(hire_date))AS narast
FROM
    employees e
GROUP BY
    year(hire_date) 

	
--2
SELECT
    year(hire_date)  year,
    j.job_title,
    COUNT(*)AS employee_number,
    SUM(COUNT(*))OVER( ORDER BY year(hire_date), j.job_title )AS narast
FROM
    employees e JOIN jobs j on e.job_id=j.job_id
GROUP BY
    year(hire_date) , j.job_title

/

/*
3. Posortuj dane pracowników po job_title. Pokaż first and last name oraz salary. W dodatkowej
kolumnie pokaż ile w sumie wydajemy dla całego etatu. Kolejna kolumna to procent udziału
poszczególnego pracownika w wydatkach na etat
*/
select
	t1.*,
	CONCAT(cast(t1.salary / t1.suma_jobs as money) * 100, '%') prct
	from (
		select
			j.job_title,
			e.first_name,
			e.last_name,
			e.salary,
			SUM(e.salary) over (partition by j.job_title) suma_jobs
			from employees e join jobs j on e.job_id = j.job_id ) t1

with
	q1 as (
		select
			j.job_title,
			e.first_name,
			e.last_name,
			e.salary,
			SUM(e.salary) over (partition by j.job_title) suma_jobs
			from employees e join jobs j on e.job_id = j.job_id )
select  
	q1.*,
	CONCAT(cast(q1.salary / q1.suma_jobs as money) * 100, '%') prct
	from q1

--4
SELECT
    first_name,
    last_name,
    hire_date,
    LAG(CONCAT(first_name, ' ' ,last_name),1,'----') OVER(
        ORDER BY hire_date) poprzednio_zatrudniony
FROM
    employees
	
--5
SELECT
    d.department_name,
    STRING_AGG(last_name,',') WITHIN GROUP(
            ORDER BY last_name) AS lista_klientow
FROM
    employees e join departments d on e.department_id=d.department_id
group by
    d.department_name
	
--or
SELECT
    d.department_name,
    STRING_AGG(last_name,',')AS lista_klientow
FROM
    employees e join departments d on e.department_id=d.department_id
group by
    d.department_name

--6
select
	t1.department_name,
	STRING_AGG(t1.last_name,',')
	from (
	select
		department_name,
		last_name,
		RANK() over (partition by department_name order by last_name) rn
	FROM
		employees e join departments d on e.department_id=d.department_id ) t1
where
	t1.rn <= 2 
group by 
	t1.department_name
	
--7
SELECT
	distinct c.country_name,
	FIRST_VALUE(CONCAT(first_name , ' ' , last_name , '' , salary)) 
            over (partition by c.country_name order by salary DESC) the_best
	from employees e join departments d on e.department_id=d.department_id
					 join locations l on d.location_id=l.location_id
					 right join countries c on c.country_id=l.country_id
order by the_best desc;

--8a
select 
    year(hire_date) rok,
    DATEPART(QUARTER, hire_date) kwartal,
    sum(sum(salary)) OVER (order by year(hire_date), DATEPART(QUARTER, hire_date)) wzrost
    from employees e
group by
    year(hire_date),
    DATEPART(QUARTER, hire_date)
	
--8b
select
    t1.kwartal,
    t1.ilosc,
    t1.poprzednik,
    t1.poprzednik - t1.ilosc roznica,
    rank() over (order by t1.ilosc desc) ranking
    from(
        select
            DATEPART(QUARTER, hire_date) kwartal,
            count(*) ilosc,
            lag(count(*)) over (order by DATEPART(QUARTER, hire_date)) poprzednik
            from employees e
        group by
            DATEPART(QUARTER, hire_date)) t1;

