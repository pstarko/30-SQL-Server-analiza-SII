/*
1. Dla każdego pracownika wygeneruj kod składający się z pierwszych dwóch liter job_id
oraz całego employee_id
*/

select 
	last_name,
	job_id, 
	employee_id, 
	concat(substring(job_id,1,2),employee_id) code 
	from employees

/*
2. Pozamieniaj litery l, m oraz k i zamień je na X. Zarówno poprzez funkcję TRANSLATE
jak i REPLACE
*/
select 
	last_name, 
	replace(replace(replace(last_name, 'L','X'), 'M','X'), 'K','X') change_replace,
	translate(last_name, 'lmk','XXX') change_translate 
	from employees

/*
3.	Dodaj podwyżkę 15% dla każdego pracownika. Uwzględnij również dodatek(commission_pct). 
Posortuj dane po kolumnie z dodaną podwyżką, którą zamień na typ danych money.
*/
select 
	last_name, 
	cast((salary + (salary * isnull(commission_pct,0)))*1.15 as money) more_money 
	from employees
order by more_money

/*
4. Policz ile dni jest zatrudniony każdy pracownik. Wyróżnij odpowiednim
komentarzem tych, którzy pracują ponad 3000 dni (Wynik na dzień 2024-01-01). Posortuj dane po nazwisku.
*/
select 
	last_name, 
	hire_date,
	CASE 
		WHEN floor(datediff(day, hire_date ,'2024-01-01')) > 3000
		THEN CONCAT('Pracuje ', floor(datediff(day, hire_date ,'2024-01-01')), ' dni')
		ELSE '---------'
		END result
	from employees
where
	floor(datediff(day, hire_date ,'2024-01-01')) > 3000
order by last_name

/*
5. Rozwiąż wyrażenie algebraiczne: Resztę z dzielenia 134 przez 8 przemnóż przez
pierwiastek z 81. Podziel to wszystko przez 244 i podnieś do 4 potęgi. Do wyniku
dodaj 0.0097. Zaogrąglij wszystko do 4 miejsc po przecinku zgodnie z zasadami
matematyki.
*/
select round(POWER(((134%8)*sqrt(81)/244),4) + 0.0097,4) result



/*
6.	Wiedząc, że do otrzymania nagrody trzeba pracować 10 lat pokaż dane: datę zatrudnienia, ile lat pracy, 
ile lat do nagrody oraz informacje o tym, że ktoś już odebrał nagrodę. 
Jeśli komuś do nagrody brakuje mniej niż 2 lata napisz: „jeszcze troszeczkę!” – (Stan na 2025-02-02)
*/
SELECT 
	last_name,
	hire_date,
	DATEDIFF(year, hire_date, GETDATE()) ile_lat_pracuje,
	DATEADD(year, 10, hire_date) rok_nagrody,
	DATEDIFF(year, getdate(), DATEADD(year, 10, hire_date)) ile_lat_do_nagrody,
	CASE
		WHEN 
		DATEDIFF(year, getdate(), dateadd(year, 10, hire_date)) < 0
			THEN 'Nagroda odebrana'	
		WHEN DATEDIFF(year, getdate(), dateadd(year, 10, hire_date)) < 2
			THEN 'jeszcze troszczkę!'
		else CONCAT('jeszcze ', datediff(year, getdate(), dateadd(year, 10, hire_date)), ' lat')
		END result
	from employees
	
/*
7. Otrzymaj poniższy wynik posortowany hire_date. Zmień format hire_date. Ostatnia
kolumna to pierwsza cyfra departamentu, następnie druga litera job_id i pozostałe
cyfry departamentu. Wykorzystaj funkcję CONVERT.
*/
SELECT 
	last_name,
	convert(varchar, hire_date, 106) hire_date,
	job_id,
	department_id,
	CONCAT(left(department_id,1), 
	substring(job_id,2,1), 
	RIGHT(department_id, len(department_id)-1)) code
	from employees
	
/*
8. Jeśli w nazwisku na drugiej pozycji znajdziejsz literę ‘i’ zamień wszystkie jej
występowania na XXX, jeśli ‘o’ zamień na YYY. Wykorzystaj zarówno CASE jak i
REPLACE. Pokaż tylko nazwiska ze zmianami (22 wiersze)
*/
SELECT
    last_name,
    case
    	when substring(last_name,2,1) = 'i' then replace(last_name,'i','XXX')
    	when substring(last_name,2,1) = 'o' then replace(last_name,'o','YYY')
    end zmiana    
FROM
    employees
where 
	substring(last_name,2,1) in ('i','o')

/*
9. Pokaż last name w taki sposób, by ostatnie trzy litery były w odwróconej kolejności. Jeśli nazwisko ma mniej niż 3 litery odwróć całe nazwisko
*/
SELECT
    last_name,
    CASE 
        WHEN LEN(last_name) >= 3 
            THEN SUBSTRING(last_name, 1, LEN(last_name) - 3) 
                 + REVERSE(SUBSTRING(last_name, LEN(last_name) - 2, 3))
        ELSE REVERSE(last_name) -- dla nazw krótszych niż 3 znaki można odwrócić cały ciąg
    END AS last_name_modified
FROM employees;

/*
10.	Zamiast drugiej litery w nazwisku wstaw 5 razy podkreślik. Użyj funkcji STUFF i REPLICATE.
*/
SELECT
    last_name,
	STUFF(last_name, 2,1, replicate('_', 5)) zmiana
from employees