--1
select max(salary) maks, min(salary) mini,
max(salary) - min(salary) diff from employees

--2
select
	job_id,
	avg(salary) srednia
	from employees
group by 
	job_id
order by
	srednia desc

--3
select 
	count(*) ilosc
	from employees
where job_id = 'IT_PROG'

--4
select
	department_id,
	sum(salary + isnull(commission_pct,0)) suma
	from employees
where department_id is not null
group by department_id

--5
select
	manager_id,
	min(salary) mini
	from employees
group by manager_id
order by mini desc


/*
6. Sprawdź, ilu mamy pracowników z literą O i R w nazwisku. Przed sprawdzeniem zamień wszystkie litery na wielkie.
*/
select 
	count(*) counter
	from employees
where
	upper(last_name) like '%O%' and
	upper(last_name) like '%R%'

/*
7. Czy istnieje dział, który zarobi łącznie ponad 50000 (salary), gdy otrzyma 10% wzrost
na 10 lat? Pokaż identyfikator tego działu (7 wierszy)
*/
select
	department_id,
	sum(salary) * power(1.1, 10) kwota
	from employees
group by
	department_id
having 
	sum(salary) * power(1.1, 10) > 50000

/*
8. Pokaż maksymalne i minimalne wynagrodzenie dla pracowników zatrudnionych
przed 2000 r. I posiadających szefa o identyfikatorze 100 lub 130
*/
select
	max(salary) maks,
	min(salary) mini
	from employees
where 
	manager_id in (100, 130)
	and hire_date < cast('2015-01-01' as date)

/*
9. Wyświetl numery zespołów wraz z liczbą pracowników w każdym dziale. Sortuj wynik
po malejącym id_działu tak, by efekt był jak poniżej (12 wierszy).
*/
select
    department_id,
    count(employee_id) ilosc
from employees
group by department_id
order by 
	CASE
		when department_id is null then 200
		when department_id = 10 then 199
		else department_id
		end desc
/*
10. Utwórz zapytanie, które wyświetla liczbę pracowników zatrudnionych w każdym roku
i miesiącu. Posortuj wyniki według roku zatrudnienia (53 wiersze).
*/
select  year(hire_date) year,
        month(hire_date) month,
        count(*) counter
    from employees
group by year(hire_date),
        month(hire_date)
order by year desc

/*
11. Zbuduj zapytanie, które liczy liczbę liter w kombinacji pracowników FIRST i LAST
NAME i wyświetla liczbę nazw z podaną liczbą liter (12 wierszy)
*/
select
	LEN(first_name) + LEN(last_name) ilosc_znakow,
	COUNT(*) ilosc_osob
	from employees
group by
	LEN(first_name) + LEN(last_name)
order by ilosc_znakow