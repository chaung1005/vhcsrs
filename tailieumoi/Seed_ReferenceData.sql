
/* Seed_ReferenceData.sql – Seed dữ liệu tham chiếu cơ bản */

USE QLCLN;
GO

INSERT INTO dbo.Species(Code, Name) VALUES (N'CATRA', N'Cá tra'), (N'ROPHI', N'Rô phi');

INSERT INTO dbo.FarmRegion(Name, WaterChangeCycleDays, MaxIntakeM3PerDay, MaxDischargeM3PerDay)
VALUES (N'Binh Thanh', 7, 8640, 10000),
       (N'Tan Khanh Trung', 7, 8640, 10000);

INSERT INTO dbo.Manufacturer(Name) VALUES (N'Vemedim'), (N'UV JSC'), (N'Provimi'), (N'Abtech');

INSERT INTO dbo.Warehouse(Name, FarmRegionId, CapacityLiquidL, CapacitySolidKg)
SELECT N'Kho chính ' + fr.Name, fr.FarmRegionId, 20000, 50000 FROM dbo.FarmRegion fr;

INSERT INTO dbo.WasteType(Name) VALUES (N'Cá chết'), (N'Thức ăn thừa'), (N'Bao bì rỗng');
