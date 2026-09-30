
--1
select 
	e.first_name,
	e.last_name,
	e.salary,
	l.street_address,
	l.city,
	rank() over (order by e.salary DESC) rank
	from employees e join departments d on e.department_id=d.department_id
						  join locations l on d.location_id=l.location_id
						  

--2
select 
    e.first_name,
    e.last_name,
    e.salary,
    l.street_address,
    l.city,
    rank() over (order by e.salary) rank,
    dense_rank() over (order by e.salary) rank_d
	from employees e join departments d on e.department_id=d.department_id
						  join locations l on d.location_id=l.location_id
						  
--3
select * from (
        select 
            e.first_name,
            e.last_name,
            e.salary,
            l.street_address,
            l.city,
            rank() over (order by e.salary DESC) rank,
            dense_rank() over (order by e.salary DESC) rank_d
            from employees e join departments d on e.department_id=d.department_id
						  join locations l on d.location_id=l.location_id) t1
where t1.rank<6

--4
select * from (
        select 
            e.first_name,
            e.last_name,
            e.salary,
            l.street_address,
            l.city,
            rank() over (order by e.salary ) rank,
            dense_rank() over (order by e.salary ) rank_d
            from employees e join departments d on e.department_id=d.department_id
						  join locations l on d.location_id=l.location_id) t1
where t1.rank<6

--5
select
	d.department_name,
	COUNT(*) counter,
	(PERCENT_RANK() over (order by count(*) DESC)) * 100 percentRank
	from employees e join departments d on e.department_id=d.department_id
group by 
	d.department_name

--6
select
	*
	from (
		select
			d.department_name,
			COUNT(*) counter,
			(PERCENT_RANK() over (order by count(*) DESC)) * 100 percentRank
			from employees e join departments d on e.department_id=d.department_id
		group by 
			d.department_name ) t1
where
	t1.percentRank <= 25

--7
select
	*
	from (
		select
			d.department_name,
			COUNT(*) counter,
			(PERCENT_RANK() over (order by count(*) DESC)) * 100 percentRank,
			round(CUME_DIST() over (order by count(*) DESC),2) cumeDist
			from employees e join departments d on e.department_id=d.department_id
		group by 
			d.department_name ) t1

--8
select 
    d.department_name department_name,
    count(*) counter,
	rank() over (order by count(*)  DESC) rank,
	row_number() over (order by count(*)  DESC) numer_porzadkowy
    from employees e join departments d on e.department_id=d.department_id
group by d.department_name
				
--9
select 
        d.department_name department_name,
		count(*) counter,
		rank() over (order by count(*)  DESC) rank,
		CONCAT('Basket ', ntile(4) over (order by count(*) DESC)) basket        
        from employees e join departments d on e.department_id=d.department_id
group by d.department_name
				
--10
select 
        d.department_name department_name,
		j.job_title,
		count(*) counter,
		rank() over (order by count(*)  DESC) rank    
        from employees e join departments d on e.department_id=d.department_id
						 join jobs j on e.job_id = j.job_id
group by 
	d.department_name,
	j.job_title


