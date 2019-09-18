CREATE TEMP TABLE gtcontract42 AS SELECT
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
	select exclusion, sum(amt), sum(s_ic),sum(s_awp),sum(s_df), sum(amt * discount)/sum(amt)as Discount, avg(gtdiscount), sum(amt*avg_ic)/sum(amt) as avg_ic,sum(amt*avg_awp)/sum(amt) as avg_awp,sum(amt*avg_df)/sum(amt) as avg_df from 
(SELECT
	'rtgnGTdmr' AS exclusion, amt, s_ic,s_awp,s_df, 
--	ISNULL ( SUM ( amt ), 0 ) AS amt,
--	ISNULL ( SUM ( S_IC ), 0 ) AS s_ic,
	--ISNULL ( SUM ( S_AWP ), 0 ) AS s_awp,
	--ISNULL ( SUM ( S_DF ), 0 ) AS s_df,
(CASE
		
		WHEN s_awp = 0 THEN
		null ELSE ( 1-(s_ic / s_awp ) )
	END) AS Discount, gtdiscount, avg_ic,avg_awp,avg_df
	--ISNULL ( AVG ( gtdiscount ), 0 ) AS gtdiscount,
	--( discount - gtdiscount ) * s_awp AS Surplus,
	--ISNULL ( AVG ( avg_IC ), 0 ) AS avg_ic,
--	ISNULL ( AVG ( Avg_AWP ), 0 ) AS avg_awp,
	--ISNULL ( AVG ( avg_DF ), 0 ) AS avg_df
	--SUM ( discount ) AS summeddiscount,
	--SUM ( s_awp ) AS summeds_awp 
FROM
	GTcontract42
WHERE
	claim_tags LIKE'%,rtgn,%' 
	AND claim_tags LIKE'%dmr%') as subq
	
	
	
	
group by exclusion--, gtdiscount, discount, s_awp, s_ic
