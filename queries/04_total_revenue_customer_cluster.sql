WITH dim_customers AS (
	SELECT
		cus.company_name,
		SUM((od.unit_price) * od.quantity * (1.0 - od.discount)) AS total_revenue_w_discount
	FROM
		customers AS cus
	JOIN 
		orders AS o
		ON
			cus.customer_id = o.customer_id
	JOIN 
		order_details AS od
		ON
			o.order_id = od.order_id
	GROUP BY
		1
)
SELECT 
	company_name,
	total_revenue_w_discount, 
	NTILE(5) OVER(ORDER BY total_revenue_w_discount DESC) AS group_cluster
FROM 
	dim_customers
ORDER BY
	2 DESC;
