WITH dim_customers AS (
	SELECT
		cus.country,
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
		1, 2
)
SELECT
	country,
	company_name,
	total_revenue_w_discount
FROM
	dim_customers
WHERE
	country = 'UK'
	AND
		total_revenue_w_discount >= 1000;
