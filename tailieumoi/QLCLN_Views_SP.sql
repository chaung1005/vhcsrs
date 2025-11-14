
/* QLCLN_Views_SP.sql – (Có thể mở rộng thêm SP/Trigger/Views) */

USE QLCLN;
GO

-- View tồn kho lỏng vượt 90% sức chứa (cảnh báo kho hoá chất lỏng)
CREATE OR ALTER VIEW dbo.v_LiquidChemOverCapacity AS
SELECT w.WarehouseId, w.Name, w.CapacityLiquidL,
       SUM(CASE WHEN cit.Unit IN (N'lít', N'lit', N'litre', N'liter') THEN (cit.QtyIn - cit.QtyOut) ELSE 0 END) AS LiquidBalance
FROM dbo.Warehouse w
LEFT JOIN dbo.ChemicalInventoryTransaction cit ON cit.WarehouseId = w.WarehouseId
GROUP BY w.WarehouseId, w.Name, w.CapacityLiquidL
HAVING w.CapacityLiquidL IS NOT NULL AND
       SUM(CASE WHEN cit.Unit IN (N'lít', N'lit', N'litre', N'liter') THEN (cit.QtyIn - cit.QtyOut) ELSE 0 END) > 0.9 * w.CapacityLiquidL;
