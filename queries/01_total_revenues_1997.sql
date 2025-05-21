WITH dim_orders AS (
	SELECT DISTINCT 
		order_id
	FROM 
		orders
	WHERE 
		EXTRACT(YEAR FROM order_date) = 1997
), 
dim_total AS (
	SELECT 
		od.order_id, 
		SUM(od.unit_price * od.quantity) AS total,
		SUM((od.unit_price) * od.quantity * (1.0 - od.discount)) AS total_w_discount
	FROM 
		order_details AS od
	INNER JOIN 
		dim_orders AS o
			ON 
                od.order_id = o.order_id
	GROUP BY 
        1
)
SELECT 
	1997 AS year_reference, 
	SUM(total) AS total_revenue, 
	SUM(total_w_discount) AS total_revenue_w_discount
FROM 
	dim_total
GROUP BY 
    1;
