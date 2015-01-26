USE Guitar_Shop;

--1) Write a query that returns the Employees and their level of expertise that have skills 
--in Percussion, Piano Education or Sales and who reside in either Michigan or Georgia.
SELECT e.EmpFName, e.EmpLName, e.EmpState, s.SkillName, l.LevelName
FROM tblEMPLOYEE e
	JOIN tblEMPLOYEE_SKILL es
		ON es.EmpID = e.EmpID
	JOIN tblLevel l
		ON l.LevelID = es.LevelID
	JOIN tblSKILL s
		ON s.SkillID = es.SkillID
WHERE (s.SkillName = 'Percussion' OR s.SkillName = 'Piano Education' OR s.SkillName = 'Sales') AND
	  (e.EmpState LIKE '%Michigan%' OR e.EmpState LIKE '%Georgia%');

--2) Write a query that returns the 3 employees that have sold the most accessories by dollar volume during December 2012.
SELECT TOP 3 e.EmpFName, e.EmpLName, SUM(li.Qty * pv.Price) AS TotalSold
FROM tblEMPLOYEE e
	JOIN tblOrder o
		ON o.EmpID = e.EmpID
	JOIN tblLINE_ITEM li
		ON li.OrderID = o.OrderID
	JOIN tblPRODUCT_VENDOR pv
		ON pv.ProductVendorID = li.ProductVendorID
	JOIN tblPRODUCT p
		ON p.ProductID = pv.ProductID
	JOIN tblPRODUCT_TYPE pt
		ON pt.ProductTypeID = p.ProductTypeID
WHERE pt.ProductTypeName = 'Accessories' AND 
		o.OrderDate BETWEEN '2012-12-01' and '2012-12-31'
GROUP BY e.EmpID, e.EmpLName, e.EmpFName
ORDER BY TotalSold DESC, e.EmpLName, e.EmpFName;

--3) Write a query that returns the product type that generated the least amount of revenue during July of 2007.
SELECT TOP 1 pt.ProductTypeName, SUM(li.Qty * pv.Price) AS TotalSold
FROM tblPRODUCT_TYPE pt
	JOIN tblPRODUCT p
		ON p.ProductTypeID = pt.ProductTypeID
	JOIN tblPRODUCT_VENDOR pv
		ON pv.ProductID = p.ProductID
	JOIN tblLINE_ITEM li
		ON li.ProductVendorID = pv.ProductVendorID
	JOIN tblORDER o
		ON o.OrderID = li.OrderID
WHERE o.OrderDate BETWEEN '2007-07-01' and '2007-07-31'
GROUP BY pt.ProductTypeID, pt.ProductTypeName
ORDER BY SUM(li.Qty * pv.Price) ASC;

--4) Write a query that returns the total quantity of items sold since February 15, 2009 from Vendors who deal in Vintage equipment.
SELECT v.VendorName, SUM(li.Qty) AS ItemsSold
FROM tblLINE_ITEM li
	JOIN tblORDER o
		ON o.OrderID = li.OrderID
	JOIN tblPRODUCT_VENDOR pv
		ON pv.ProductVendorID = li.ProductVendorID
	JOIN tblVENDOR v
		ON v.VendorID = pv.VendorID
	JOIN tblVENDOR_TYPE vt
		ON vt.VendorTypeID = v.VendorTypeID
WHERE vt.VendorTypeName = 'Vintage'AND
		o.OrderDate >= '2009-02-15'
GROUP BY v.VendorID, v.VendorName
ORDER BY ItemsSold DESC;

--5) Write a query that returns the list of all T-Shirts that have at least 3 sold during 2006 to customers living in California.
SELECT p.ProductName, SUM(li.Qty) AS ItemsSold
FROM tblPRODUCT p
	JOIN tblPRODUCT_VENDOR pv
		ON pv.ProductID = p.ProductID
	JOIN tblLINE_ITEM li
		ON li.ProductVendorID = pv.ProductVendorID
	JOIN tblORDER o
		ON o.OrderID = li.OrderID
	JOIN tblCUSTOMER c
		ON c.CustID = o.CustID
	JOIN tblPRODUCT_TYPE pt
		ON pt.ProductTypeID = p.ProductTypeID
WHERE pt.ProductTypeName = 'Clothing' AND
		p.ProductName LIKE '%T-Shirt%' AND
		c.CustState LIKE '%California%' AND
		o.OrderDate BETWEEN '2006-01-01' and '2006-12-31'
GROUP BY p.ProductID, p.ProductName
HAVING SUM(li.Qty) >= 3
ORDER BY ItemsSold  DESC, p.ProductName ASC;