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
ORDER BY 
	2 DESC;
