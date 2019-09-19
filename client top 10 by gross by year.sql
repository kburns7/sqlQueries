/* by Kevin Burns */

SELECT COUNT,
	yearlyspend,
	CLASS,
	drug,
	YEAR,
	yearlyspendrank 
FROM
	(
	SELECT
		count (DISTINCT s_audit_number ) AS COUNT,
		SUM ( s_gross_amount ) as yearlyspend,
		t_therapeutic_class AS CLASS,
		v_drug_name_mddb AS drug,
		EXTRACT ( YEAR FROM ( s_date_dispensed ) ) AS YEAR,
		RANK ( ) OVER ( PARTITION BY YEAR ORDER BY yearlyspend DESC ) AS yearlyspendrank 
	FROM
		tgdata 
	WHERE
		is_reversal = 'f' 
		AND (( t_contract_id IN ( '90541' ) AND s_date_dispensed BETWEEN '01-01-2019' AND '12-31-2019' ) 
		OR ( t_contract_id IN ( '96715' ) AND s_date_dispensed BETWEEN '01-01-2018' AND '12-31-2018' ) 
		OR ( t_contract_id IN ( '52503' ) AND s_date_dispensed BETWEEN '01-01-2017' AND '12-31-2017' ) )
	GROUP BY
		year,
		4,
		t_therapeutic_class	
	) 
WHERE
	( yearlyspendrank BETWEEN 1 AND 10 ) 
GROUP BY
	4,
	3,
	YEAR,
	yearlyspendrank,1,2 
ORDER BY
	YEAR,
	yearlyspendrank asc