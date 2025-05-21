SELECT
	p.product_name,
	SUM((od.unit_price) * od.quantity * (1.0 - od.discount)) AS total_revenue_w_discount
FROM
	products AS p
JOIN
	order_details AS od
	ON
		p.product_id = od.product_id
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	10;
