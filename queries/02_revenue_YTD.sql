WITH dim_mth_rev AS (
	SELECT 
		EXTRACT(YEAR FROM o.order_date) AS year_ref,
		EXTRACT(MONTH FROM o.order_date) AS mth_ref, 
		SUM((od.unit_price) * od.quantity * (1.0 - od.discount)) AS revenue_w_discount
	FROM 
		orders AS o 
	INNER JOIN 
		order_details AS od
			ON 
                o.order_id = od.order_id
	GROUP BY 
        1, 2
),
dim_rev_ytd AS (
	SELECT
		year_ref, 
		mth_ref, 
		revenue_w_discount,
		SUM(revenue_w_discount) OVER (PARTITION BY year_ref ORDER BY mth_ref) AS revenue_ytd
	FROM 
		dim_mth_rev
), 
dim_rev_calc AS (
	SELECT 
		year_ref, 
		mth_ref,
		revenue_w_discount,
		LAG(revenue_w_discount) OVER (PARTITION BY year_ref ORDER BY mth_ref) AS previous_revenue,
		revenue_ytd
	FROM
		dim_rev_ytd
)
SELECT year_ref,
	mth_ref,
	revenue_w_discount,
	revenue_w_discount - previous_revenue AS rev_abs_diff, 
	(revenue_w_discount - previous_revenue) / previous_revenue * 100 AS rev_pct_diff,
	revenue_ytd
FROM 
	dim_rev_calc
ORDER BY 
    1, 2;
