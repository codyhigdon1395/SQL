--44
SELECT	*
FROM	lgdepartment

--45
SELECT	PROD_SKU, PROD_DESCRIPT, PROD_TYPE, PROD_BASE, PROD_CATEGORY, PROD_PRICE
FROM	lgproduct
WHERE	prod_base = 'WATER' AND prod_category = 'SEALER'

--46
SELECT	EMP_FNAME, EMP_LNAME, EMP_EMAIL
FROM	lgemployee
WHERE	EMP_HIREDATE BETWEEN '2003-01-01' AND '2012-12-31'
ORDER	BY EMP_LNAME, EMP_FNAME

--47
SELECT	EMP_FNAME, EMP_LNAME, EMP_PHONE, EMP_TITLE, DEPT_NUM
FROM	lgemployee
WHERE	dept_num = '300' OR emp_title = 'CLERK I'
ORDER	BY emp_lname, emp_fname

--48
SELECT	E.emp_num, emp_lname, emp_fname, SAL_FROM, sal_end, sal_amount
FROM	lgemployee E inner join lgsalary_history H on E.emp_num = H.emp_num
WHERE	E.emp_num IN ('83731', '83745', '84039')
ORDER	BY E.emp_num, sal_from

--49
SELECT	cust_fname, cust_lname, cust_street, cust_city, cust_state, cust_zip
FROM	lgcustomer C inner join lginvoice I on C.cust_code = I.cust_code inner join
		lgline L on I.inv_num = L.inv_num inner join
		lgproduct P on L.prod_sku = P.prod_sku inner join
		lgbrand B on P.brand_id = B.brand_id
WHERE	brand_name = 'FORESTERS BEST' AND prod_category = 'TOP COAT' AND inv_date BETWEEN '2015-07-15' AND '2015-07-31'
ORDER	BY cust_state, cust_lname, cust_fname

--50
SELECT	E.EMP_NUM, EMP_LNAME, EMP_EMAIL, EMP_TITLE, DEPT_NAME
FROM	lgemployee E INNER JOIN lgdepartment D ON E.dept_num = D.dept_num
WHERE	emp_title LIKE '%ASSOCIATE'
ORDER	BY dept_name, emp_title

--51
SELECT	BRAND_NAME, COUNT(PROD_SKU) AS NUM_OF_PRODUCTS
FROM	lgbrand B INNER JOIN lgproduct P ON B.brand_id = P.brand_id
GROUP	BY BRAND_NAME
ORDER	BY BRAND_NAME

--52
SELECT	PROD_CATEGORY, COUNT(PROD_SKU) AS NUM_OF_PRODUCTS
FROM	lgproduct
WHERE	prod_base = 'WATER'
GROUP	BY prod_category

--53
SELECT	PROD_BASE, PROD_TYPE, COUNT(PROD_SKU) AS NUM_OF_PRODUCTS
FROM	lgproduct
GROUP	BY prod_base, prod_type
ORDER	BY prod_base

--54
SELECT	BRAND_ID, SUM(PROD_QOH)
FROM	lgproduct
GROUP	BY brand_id
ORDER	BY brand_id DESC

--55
SELECT	P.BRAND_ID, BRAND_NAME, ROUND(AVG(PROD_PRICE), 2) AS AVG_PRICE
FROM	lgproduct P INNER JOIN lgbrand B ON P.brand_id = B.brand_id
GROUP	BY P.brand_id, brand_name
ORDER	BY brand_name

--56
SELECT	DEPT_NUM, MAX(EMP_HIREDATE) AS MOST_RECENT_HIRE
FROM	lgemployee
GROUP	BY dept_num
ORDER	BY dept_num

--57
SELECT	E.EMP_NUM, EMP_FNAME, EMP_LNAME, MAX(SAL_AMOUNT) AS LARGEST_SAL
FROM	lgemployee E INNER JOIN lgsalary_history S ON E.emp_num = S.emp_num
WHERE	dept_num = '200'
GROUP	BY E.emp_num, emp_fname, emp_lname
ORDER	BY LARGEST_SAL DESC

--58
SELECT	C.CUST_CODE, CUST_FNAME, CUST_LNAME, SUM(INV_TOTAL) AS INV_TOTALS
FROM	lgcustomer C INNER JOIN lginvoice I ON C.cust_code = I.cust_code
GROUP	BY C.cust_code, cust_fname, cust_lname
HAVING	SUM(INV_TOTAL) > 1500
ORDER	BY INV_TOTALS DESC

--59
SELECT	D.DEPT_NUM, DEPT_NAME, DEPT_PHONE, D.EMP_NUM, EMP_LNAME
FROM	lgemployee E INNER JOIN lgdepartment D ON E.emp_num = D.emp_num
ORDER	BY dept_name

--60
SELECT	V.VEND_ID, V.VEND_NAME, BRAND_NAME, COUNT(P.PROD_SKU) AS NUM_OF_PRODUCTS
FROM	lgvendor V INNER JOIN lgsupplies S ON V.vend_id = S.vend_id
		INNER JOIN lgproduct P ON S.prod_sku = P.prod_sku
		INNER JOIN lgbrand B ON P.brand_id = B.brand_id
GROUP	BY V.vend_id, V.vend_name, brand_name
ORDER	BY vend_name, brand_name

--61
SELECT	EMP_NUM, EMP_LNAME, EMP_FNAME, SUM(INV_TOTAL) AS INV_TOTALS
FROM	lgemployee E INNER JOIN lginvoice I ON E.emp_num = I.employee_id
GROUP	BY emp_num, emp_lname, emp_fname
ORDER	BY emp_lname, emp_fname

--62
SELECT	MAX(AVG_PRICE) AS LARGEST_AVG
FROM	(SELECT	BRAND_ID, ROUND(AVG(PROD_PRICE), 2) AS AVG_PRICE
		FROM	lgproduct
		GROUP	BY brand_id)
		AVG_PRICE

--63
SELECT	P.BRAND_ID, BRAND_NAME, BRAND_TYPE, ROUND(AVG(PROD_PRICE), 2) AS AVG_PRICE
FROM	lgproduct P INNER JOIN lgbrand B ON P.brand_id = B.brand_id
GROUP	BY P.brand_id, brand_name, brand_type
HAVING	ROUND(AVG(PROD_PRICE), 2) = 
		(SELECT MAX(AVG_PRICE) AS LARGEST_AVG
		FROM	(SELECT brand_id, ROUND(AVG(PROD_PRICE), 2) AS AVG_PRICE
				FROM	lgproduct
				GROUP	BY brand_id) AVG_PRICE)

--64
SELECT	DE.EMP_FNAME, DE.EMP_LNAME, DEPT_NAME, DEPT_PHONE, E.EMP_FNAME, E.EMP_LNAME, CUST_FNAME, CUST_LNAME, INV_DATE, INV_TOTAL
FROM	lgemployee DE INNER JOIN lgdepartment D ON DE.emp_num = D.emp_num
		INNER JOIN lgemployee E ON D.dept_num = E.dept_num
		INNER JOIN lginvoice I ON E.emp_num = I.employee_id
		INNER JOIN lgcustomer C ON I.cust_code = C.cust_code
WHERE	CUST_LNAME = 'HAGAN' AND inv_date = '2015-05-18'