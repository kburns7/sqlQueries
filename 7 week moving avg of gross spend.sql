/*By Kevin Burns, with ideas taken from Ben Sullins SQL Tips,Tricks, & Techniques Course*/

select avg(weeklyspend) over (order by week rows between 6 preceding and current row) as avgsales, 
weeklyspend as totalsales, 
week,
year from (


select sum(s_gross_amount) as weeklyspend,
extract(week from (s_date_dispensed)) as week,  
extract(year from (s_date_dispensed)) as year 
from tgdata WHERE is_reversal = 'f' and
	(t_contract_id in ('90541') and s_date_dispensed between '01-01-2019' and '12-31-2019')  OR
	(t_contract_id in ('96715') and s_date_dispensed between '01-01-2018' and '12-31-2018')  or
	(t_contract_id in ('52503') and s_date_dispensed between '01-01-2017' and '12-31-2017') group by 3,2) 
	
	group by 4,3,2
	
	order by year
