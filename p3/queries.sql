--Problem 3 Part C

--i 
WITH PriceDifference AS(
    SELECT 
        (SELECT yearly_cost FROM MembershipTier WHERE tier = 'Executive')- 
        (SELECT yearly_cost FROM MembershipTier WHERE tier = 'Basic') AS difference
)
SELECT M.name
FROM Member M JOIN OverallTransaction T 
ON M.member_id = T.member_id
JOIN TransactionItem TI 
on T.tid = TI.tid
WHERE M.tier = 'Basic'
GROUP BY M.member_id, M.name 
HAVING 0.02*SUM(TI.quantity * TI.unit_price_paid) > (SELECT difference FROM PriceDifference);

--ii
SELECT W.wid, W.address
FROM Warehouse W JOIN InventoryBatch IB 
ON W.wid = IB.wid
JOIN Product P ON IB.sku = P.sku
WHERE P.name = 'Kirkland Paper Towels'
GROUP BY W.wid, W.address
HAVING SUM(IB.quantity_remaining) = 0;

--iii
SELECT P.sku, P.name, DI.wid
FROM Product P
JOIN DailyInventory DI --had to add a new relation in the DB for this query! 
ON P.sku = DI.sku
WHERE P.category = 'Grocery'
    AND DI.inventory_date BETWEEN '2025-12-18' AND '2025-12-24'
GROUP BY P.sku, P.name, DI.wid
HAVING SUM(DI.quantity_remaining) = 0;

--iv
WITH MemberSpending AS (
    SELECT M.member_id, M.name, COUNT(DISTINCT OT.wid) AS num_warehouses,
        SUM(TI.quantity * TI.unit_price_paid) AS total_spending
    FROM Member M
    JOIN OverallTransaction OT
        ON M.member_id = OT.member_id
    JOIN TransactionItem TI
        ON OT.tid = TI.tid
    WHERE OT.t_timestamp >= '2024-01-01' AND OT.t_timestamp < '2025-01-01'
    GROUP BY M.member_id, M.name
)
SELECT name, total_spending
FROM MemberSpending
WHERE num_warehouses > 1
  AND total_spending > 500;
