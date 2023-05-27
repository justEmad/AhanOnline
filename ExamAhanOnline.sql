-- 1- کل فروش شرکت چه مقدار است
SELECT SUM(unitprice * quantity) AS totalsales FROM SaleTable
WHERE unitprice IS NOT NULL AND quantity IS NOT NULL


-- 2- تعداد متمایز مشتریانی که از این شرکت خرید داشته اند، چند تاست؟
SELECT COUNT(*) as totalcustomers FROM (SELECT DISTINCT Customer FROM SaleTable) AS customer_list

-- و اگر بخوایم حساب کنیم که هر مشتری چه مقدار خرید داشته از دستور زیر استفاده میکنیم
SELECT Customer, SUM(unitprice * quantity) AS totalsale FROM SaleTable
GROUP BY Customer


-- 3- این شرکت از هر محصول چه مقدار فروخته است؟
SELECT product, SUM(unitprice * quantity) AS totalSale FROM SaleTable
where unitprice IS NOT NULL AND quantity IS NOT NULL
GROUP BY product


-- 4- یک کوئری بنویسید که در آن مشتریانی نمایش داده شوند که حداقل یک فاکتور بیش از مبلغ 1500 دارند 
--و به ازای هر کدام از این مشتریان، مبلغ خرید، تعداد فاکتور و تعداد آیتم خریداری شده نمایش داده شود
SELECT 
    Customer, 
    SUM(unitprice * quantity) AS totalSale, 
    COUNT(DISTINCT OrderId) AS totalOrders, 
    SUM(quantity) AS totalItemsPurchased
FROM SaleTable 
WHERE unitprice * quantity > 1500
GROUP BY Customer


-- 5- مبلغ سود و درصد سود حاصل از فروش کل را محاسبه نمایید
SELECT 
    'Total Sales' as Description, 
    CAST(SUM(unitprice * quantity) AS varchar) as Amount
FROM SaleTable
CROSS JOIN (SELECT 0.1 AS ProfitRatio) AS pr
WHERE unitprice IS NOT NULL AND quantity IS NOT NULL 
UNION ALL
SELECT 
    'Total Profit Ratio', 
    CAST(ROUND(SUM(CASE WHEN TRY_CONVERT(decimal(18,2), REPLACE(ProfitRatio, '%', '')) IS NOT NULL 
                        THEN TRY_CONVERT(decimal(18,2), REPLACE(ProfitRatio, '%', '')) / 100 * unitprice * quantity 
                        ELSE 0.1 * unitprice * quantity END)/100,2) AS varchar) + '%'
FROM SaleTable
LEFT JOIN SaleProfit ON SaleTable.product = SaleProfit.product
WHERE SaleTable.unitprice IS NOT NULL AND SaleTable.quantity IS NOT NULL


-- 6- با فرض اینکه خریدهای هر مشتری در هر روز فقط 1 بار شمرده شود، در مجموع چند مشتری از شرکت خرید داشته اند
WITH CustomerCount AS (
  SELECT 
    date, 
    COUNT(DISTINCT customer) AS cnt FROM SaleTable 
  GROUP BY date
)
SELECT 
  'Total Customers' AS Description, 
  CAST(SUM(cnt) AS varchar) AS Amount FROM CustomerCount 
UNION ALL
SELECT 
  CONVERT(varchar, date, 101) AS Description, 
  CAST(cnt AS varchar) AS Amount FROM CustomerCount
--سطر اول مجموع مشتری هاست و سطرهای بعدی به ترتیب تعداد مشتری های روز اول و دوم و سوم قرار دارد


--ب – جدول چارت سازمانی که در لینک زیر نیز قابل مشاهده است، مربوط به چارت سازمانی شرکت پخش مذکور می باشد 
--که نام و آی دی هر کارشناس به همراه مدیر مستقیم بالادستی و آیدی مدیر بالادستی را نمایش می دهد
--علاوه بر ساخت این جدول با استفاده از کوئری، در کنار نام هر کارشناس، لول آن کارشناس در چارت سازمانی 
--و بالاترین مدیر مربوط به آن کارشناس در چارت سازمانی را با استفاده از کوئری ثبت کنید
--بالاترین مدیران سازمان لول 1، زیردستان آنها لول 2 و به همین ترتیب تا پایین ترین لایه چارت ادامه می یابد
--بالاترین مدیران سازمان کسانی هستند که مدیر بالادستی ندارند و در فیلد Manager عبارت Null درج شده است


CREATE TABLE Chart ( Id	INT , name	NCHAR(20) , Manager	NCHAR(20)  ,  ManagerId	INT )

INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('1', 'Ken', NULL, NULL);
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('2', 'Hugo', NULL, NULL);
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('3', 'James', 'Carol', '5');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('4', 'Mark', 'Morgan', '13');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('5', 'Carol', 'Alex', '12');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('6', 'David', 'Rose', '21');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('7', 'Michael', 'Markos', '11');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('8', 'Brad', 'Alex', '12');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('9', 'Rob', 'Matt', '15');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('10', 'Dylan', 'Alex', '12');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('11', 'Markos', 'Carol', '5');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('12', 'Alex', 'Ken', '1');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('13', 'Morgan', 'Matt', '15');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('14', 'Jennifer', 'Morgan', '13');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('15', 'Matt', 'Hugo', '2');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('16', 'Tom', 'Brad', '8');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('17', 'Oliver', 'Dylan', '10');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('18', 'Daniel', 'Rob', '9');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('19', 'Amanda', 'Markos', '11');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('20', 'Ana', 'Dylan', '10');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('21', 'Rose', 'Rob', '9');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('22', 'Robert', 'Rob', '9');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('23', 'Fill', 'Morgan', '13');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('24', 'Antoan', 'David', '6');
INSERT INTO Chart (Id, name, manager, ManagerId) VALUES ('25', 'Eddie', 'Mark', '4');


--برای دسته بندی کردن براساس لول سازمان میتوانیم از این کوئری استفاده کنیم
select name,Manager,ManagerId from Chart
order by ManagerId 


--پایان