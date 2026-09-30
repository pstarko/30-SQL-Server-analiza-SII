--1
select
	department_id,
	sum(salary) suma
	from employees
where department_id is not null
group by rollup(department_id)

/*
2. Zamień NULL na wartość RESULT. Nie używaj COALESCE ani ISNULL (13 wierszy).
*/
select
	IIF(GROUPING(department_id)=1, 'Result', cast(department_id as varchar)) department_id,
	sum(salary)	suma
	from employees
group by cube(department_id)



/*
3. Dla każdego departamentu o nr pomiędzy 10 i 50 oraz etatu pokaż sumę płacy podstawowej wraz z podsumowaniami dla każdej podgrupy. Usuń podsumowanie dla całości(23 wiersze)
*/
select
	department_id,
	job_id,
	sum(salary)
	from employees
where department_id between 10 and 50
group by cube(department_id, job_id)
having GROUPING_ID(department_id, job_id) <> 3


select
	department_id,
	job_id,
	SUM(salary) suma
	from employees
where
	department_id between 10 and 50
group by grouping sets((department_id), (department_id, job_id),(job_id))

select 
    department_id,
    job_id,
    sum(salary) sum,
	GROUPING_ID(department_id, job_id)
    from employees
where department_id between 10 and 50
group by cube (department_id, job_id)
having GROUPING_ID(department_id, job_id) <> 3


/*
4.	W sumie departamenty poza 80,100 i 110 będą miały podwyżkę w 2026 w sumie o 10%, a w 2027 o kolejne 10%. 
Minimum budżetu będzie się zmniejszało od 20000 w 2024 poprzez 15000 w 2025, aż po 10000 w 2026 roku. 
Pokaż jak będą się kształtować sumy wydatków dla wskazanych departamentów w poniższej formie (9 wierszy)*/
/*
4. W sumie departamenty poza 80,100 i 110 będą miały podwyżkę w 2026 w sumie o 10%, a w
2027 o kolejne 10%. 
Minimum budżetu będzie się zmniejszało od 20000 w 2025 
poprzez 15000 w 2026, aż po 10000 w 2027 roku. 

Pokaż jak będą się kształtować sumy wydatków dla
wskazanych departamentów w poniższej formie (9 wierszy)
*/

select
	IIF(GROUPING(department_id) = 1, 'Suma budżetów', CAST(department_id as varchar)),
	SUM(salary) sum2025,
	CASE
		WHEN SUM(salary) > 20000 AND GROUPING(department_id) <> 1 THEN 'Minimum osiągnięte'
		ELSE '---' END summary2025,
	SUM(salary) * 1.1 sum2026,
	CASE
		WHEN SUM(salary) > 15000 AND GROUPING(department_id) <> 1 THEN 'Minimum osiągnięte'
		ELSE '---' END summary2026,
	SUM(salary) * POWER(1.10,2) sum2027,
	CASE
		WHEN SUM(salary) > 10000 AND GROUPING(department_id) <> 1 THEN 'Minimum osiągnięte'
		ELSE '---' END summary2027
	from employees
where 
	department_id not in (80,100,110) and department_id is not null
group by 
	cube(department_id)

--5
select
	IIF(GROUPING(r.region_name)=1 and GROUPING(c.country_name)=1, 'Podsumowanie',  r.region_name) region,
	IIF(GROUPING(c.country_name)=1, '---------', c.country_name) kraj,
	COUNT(e.employee_id) ilość_pracowników
	from employees e join departments d on e.department_id=d.department_id
					 join locations l on d.location_id = l.location_id
					 right join countries c on c.country_id = l.country_id
					 join regions r on r.region_id = c.region_id
group by 
	cube (r.region_name,c.country_name)
having
	r.region_name is not null 
	or (GROUPING(r.region_name)=1 and GROUPING(c.country_name)=1)
order by 1 desc,2 desc