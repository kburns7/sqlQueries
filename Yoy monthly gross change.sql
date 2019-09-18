/*by Kevin Burns

change contract ids and dates to match, no repeating dates*/

with previous (year2, month2, ic2, gross2) as
(select 	extract(year from (dateadd(year, 1, s_date_dispensed))),extract(month from (s_date_dispensed)), sum(s_ic), sum(s_gross_amount) from tgdata WHERE is_reversal = 'f' and
	(t_contract_id in ('90541') and s_date_dispensed between '01-01-2019' and '12-31-2019')  OR
	(t_contract_id in ('96715') and s_date_dispensed between '01-01-2018' and '12-31-2018')  or
	(t_contract_id in ('52503') and s_date_dispensed between '01-01-2017' and '12-31-2017') group by 1,2)

SELECT
	extract(month from (s_date_dispensed)) as month,
	extract(year from (s_date_dispensed)) as year,
	SUM (s_gross_amount) AS CurrentGross,
	avg(gross2) as PrevGross,
	(((SUM (s_gross_amount)-avg(p.gross2))/SUM (s_gross_amount))*100) as YoYpercentchange
FROM
	tgdata 
	/*'left outer join' to include first year, 'join' to only look at years with a previous year to compare to*/
	left outer join previous p on extract(year from (s_date_dispensed)) = p.year2 and extract(month from (s_date_dispensed)) = p.month2
WHERE is_reversal = 'f' and(
	(t_contract_id in ('90541') and s_date_dispensed between '01-01-2019' and '12-31-2019')  OR
	(t_contract_id in ('96715') and s_date_dispensed between '01-01-2018' and '12-31-2018')  or
	(t_contract_id in ('52503') and s_date_dispensed between '01-01-2017' and '12-31-2017'))
GROUP BY
	1,2
	 
ORDER BY
	2,1 asc