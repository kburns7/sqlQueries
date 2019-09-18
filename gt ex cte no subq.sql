CREATE TEMP TABLE gtcontract1 AS SELECT
claim_tags,
COUNT ( claim_tags ) AS amt,
ISNULL ( SUM ( submittedawp * submitted_quantity_dispensed ), 0 ) AS S_AWP,
ISNULL ( SUM ( submittedingredientcost ), 0 ) AS S_IC,
ISNULL ( SUM ( dispensing_fee ), 0 ) AS S_DF,
CASE
		
		WHEN claim_tags LIKE'%,rtgn,%' THEN
		0.76 
		WHEN claim_tags LIKE'%,rtbr,%' THEN
		0.165 
		WHEN claim_tags LIKE'%,mogn,%' THEN
		0.79 
		WHEN claim_tags LIKE'%,mobr,%' THEN
		0.2425 
		WHEN claim_tags LIKE'%,sp,%' THEN
		0.16 
		WHEN claim_tags LIKE'%,rtgn90,%' THEN
		0.8 
		WHEN claim_tags LIKE'%,rtbr90,%' THEN
		0.2 ELSE 0 
	END AS gtdiscount,
(CASE
		
		WHEN s_awp = 0 THEN
		NULL ELSE ( 1-(s_ic / s_awp ) )
	END) AS Discount,
	( discount - gtdiscount ) * s_awp AS Surplus,
	ISNULL ( AVG ( submittedawp * submitted_quantity_dispensed ), 0 ) AS Avg_AWP,
	ISNULL ( AVG ( dispensing_fee ), 0 ) AS avg_DF,
	ISNULL ( AVG ( submittedingredientcost ), 0 ) AS avg_IC 
FROM
	claims 
WHERE
	contract_id = '74313' 
	AND is_reversal = 'f' 
	AND datedispensed BETWEEN '2017-09-01' 
	AND '2018-08-31' 
GROUP BY
	claim_tags;
	select 'rtgnDMR' as exclusion, sum(amt), sum(s_ic),sum(s_awp),sum(s_df), sum(amt * discount)/sum(amt)as Discount, avg(gtdiscount), sum(amt*avg_ic)/sum(amt) as avg_ic,sum(amt*avg_awp)/sum(amt) as avg_awp,sum(amt*avg_df)/sum(amt) as avg_df 
FROM
	gtcontract1
WHERE
	claim_tags LIKE'%,rtgn,%' 
	AND claim_tags LIKE'%dmr%' union
	select 'rtgnCOB' as exclusion, sum(amt), sum(s_ic),sum(s_awp),sum(s_df), sum(amt * discount)/sum(amt)as Discount, avg(gtdiscount), sum(amt*avg_ic)/sum(amt) as avg_ic,sum(amt*avg_awp)/sum(amt) as avg_awp,sum(amt*avg_df)/sum(amt) as avg_df 
FROM
	gtcontract1
WHERE
	claim_tags LIKE'%,rtgn,%' 
	AND claim_tags LIKE'%cob%'and not (claim_tags like '%dmr%')

group by exclusion
