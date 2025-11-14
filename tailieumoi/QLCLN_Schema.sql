
/* QLCLN_Schema.sql – Tạo database & bảng cốt lõi */
IF DB_ID('QLCLN') IS NULL
BEGIN
  CREATE DATABASE QLCLN;
END
GO

USE QLCLN;
GO

/* =============== Danh mục chung =============== */
CREATE TABLE dbo.FarmRegion(
  FarmRegionId INT IDENTITY(1,1) CONSTRAINT PK_FarmRegion PRIMARY KEY,
  Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_FarmRegion_Name UNIQUE,
  WaterChangeCycleDays TINYINT NULL,
  MaxIntakeM3PerDay INT NULL,
  MaxDischargeM3PerDay INT NULL
);

CREATE TABLE dbo.Pond(
  PondId INT IDENTITY(1,1) CONSTRAINT PK_Pond PRIMARY KEY,
  PondCode NVARCHAR(50) NOT NULL CONSTRAINT UQ_Pond_Code UNIQUE,
  FarmRegionId INT NOT NULL CONSTRAINT FK_Pond_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  AreaM2 INT NULL,
  WaterSurfaceM2 INT NULL,
  DepthM DECIMAL(4,2) NULL,
  Address NVARCHAR(255) NULL,
  ManagerName NVARCHAR(100) NULL,
  ManagerPhone NVARCHAR(30) NULL,
  Status NVARCHAR(30) NULL
);
CREATE INDEX IX_Pond_Region ON dbo.Pond(FarmRegionId);

CREATE TABLE dbo.Hatchery(
  HatcheryId INT IDENTITY(1,1) CONSTRAINT PK_Hatchery PRIMARY KEY,
  Name NVARCHAR(200) NOT NULL,
  Address NVARCHAR(255) NULL,
  Phone NVARCHAR(50) NULL
);

CREATE TABLE dbo.Species(
  SpeciesId INT IDENTITY(1,1) CONSTRAINT PK_Species PRIMARY KEY,
  Code NVARCHAR(50) NOT NULL CONSTRAINT UQ_Species_Code UNIQUE,
  Name NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.StockingEvent(
  StockingId INT IDENTITY(1,1) CONSTRAINT PK_StockingEvent PRIMARY KEY,
  PondId INT NOT NULL CONSTRAINT FK_Stocking_Pond REFERENCES dbo.Pond(PondId),
  SpeciesId INT NOT NULL CONSTRAINT FK_Stocking_Species REFERENCES dbo.Species(SpeciesId),
  HatcheryId INT NULL CONSTRAINT FK_Stocking_Hatchery REFERENCES dbo.Hatchery(HatcheryId),
  StockingDate DATE NOT NULL,
  FingerlingCount INT NOT NULL,
  FingerlingWeightKg DECIMAL(12,3) NULL,
  FingerlingAgeDays INT NULL,
  InitialAvgSizeCm DECIMAL(5,2) NULL,
  StockingDensityPerM2 DECIMAL(8,2) NULL,
  EstYieldTon DECIMAL(10,2) NULL,
  Notes NVARCHAR(4000) NULL
);
CREATE INDEX IX_Stocking_Pond ON dbo.StockingEvent(PondId, StockingDate DESC);

CREATE TABLE dbo.Manufacturer(
  ManufacturerId INT IDENTITY(1,1) CONSTRAINT PK_Manufacturer PRIMARY KEY,
  Name NVARCHAR(200) NOT NULL CONSTRAINT UQ_Manufacturer_Name UNIQUE
);

CREATE TABLE dbo.FeedType(
  FeedTypeId INT IDENTITY(1,1) CONSTRAINT PK_FeedType PRIMARY KEY,
  MTPCode NVARCHAR(20) NOT NULL CONSTRAINT UQ_FeedType_MTP UNIQUE,
  Name NVARCHAR(200) NOT NULL,
  SizeMm DECIMAL(5,2) NULL,
  ProteinPercent DECIMAL(5,2) NULL,
  ManufacturerId INT NULL CONSTRAINT FK_FeedType_Manufacturer REFERENCES dbo.Manufacturer(ManufacturerId),
  StandardPackKg DECIMAL(9,2) NULL
);

CREATE TABLE dbo.ChemicalProduct(
  ChemicalProductId INT IDENTITY(1,1) CONSTRAINT PK_ChemicalProduct PRIMARY KEY,
  Name NVARCHAR(200) NOT NULL CONSTRAINT UQ_ChemicalProduct_Name UNIQUE,
  Unit NVARCHAR(20) NOT NULL, -- kg/lít/...
  Pack NVARCHAR(50) NULL,
  ManufacturerId INT NULL CONSTRAINT FK_ChemicalProduct_Manufacturer REFERENCES dbo.Manufacturer(ManufacturerId),
  Category NVARCHAR(50) NOT NULL -- 'Dinh duong','Xu ly nuoc','Ky sinh trung','Tri benh'
);

CREATE TABLE dbo.Warehouse(
  WarehouseId INT IDENTITY(1,1) CONSTRAINT PK_Warehouse PRIMARY KEY,
  Name NVARCHAR(100) NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_Warehouse_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  CapacityLiquidL INT NULL,
  CapacitySolidKg INT NULL
);
CREATE INDEX IX_Warehouse_Region ON dbo.Warehouse(FarmRegionId);

CREATE TABLE dbo.Boat(
  BoatId INT IDENTITY(1,1) CONSTRAINT PK_Boat PRIMARY KEY,
  CarrierName NVARCHAR(100) NOT NULL,
  BoatNumber NVARCHAR(50) NOT NULL CONSTRAINT UQ_BoatNumber UNIQUE,
  CapacityTon DECIMAL(10,2) NULL
);

/* =============== Giao nhận =============== */
CREATE TABLE dbo.FeedDelivery(
  FeedDeliveryId INT IDENTITY(1,1) CONSTRAINT PK_FeedDelivery PRIMARY KEY,
  DeliveryDate DATE NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_FeedDelivery_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  BoatId INT NOT NULL CONSTRAINT FK_FeedDelivery_Boat REFERENCES dbo.Boat(BoatId),
  DeliveredBy1 NVARCHAR(100) NULL,
  DeliveredBy2 NVARCHAR(100) NULL,
  Receiver NVARCHAR(100) NULL,
  Location48h NVARCHAR(255) NULL,
  Sanitation_Oil BIT NULL,
  Sanitation_Trash BIT NULL,
  Sanitation_Dry BIT NULL,
  HygieneFixActions NVARCHAR(1000) NULL,
  Packaging_Integrity BIT NULL,
  Packaging_Dry BIT NULL,
  Packaging_Mould BIT NULL,
  Packaging_Clean BIT NULL,
  ConclusionOk BIT NULL,
  CreatedOn DATETIME2 NOT NULL CONSTRAINT DF_FeedDelivery_CreatedOn DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.FeedDeliveryLine(
  LineId BIGINT IDENTITY(1,1) CONSTRAINT PK_FeedDeliveryLine PRIMARY KEY,
  FeedDeliveryId INT NOT NULL CONSTRAINT FK_FeedDeliveryLine_Header REFERENCES dbo.FeedDelivery(FeedDeliveryId) ON DELETE CASCADE,
  FeedTypeId INT NULL CONSTRAINT FK_FeedDeliveryLine_FeedType REFERENCES dbo.FeedType(FeedTypeId),
  ManufacturerId INT NULL CONSTRAINT FK_FeedDeliveryLine_Mf REFERENCES dbo.Manufacturer(ManufacturerId),
  SizeMm DECIMAL(5,2) NULL,
  Packing NVARCHAR(50) NULL,
  Unit NVARCHAR(20) NOT NULL CONSTRAINT DF_FeedDeliveryLine_Unit DEFAULT N'kg',
  Quantity DECIMAL(12,2) NOT NULL,
  Notes NVARCHAR(500) NULL
);

CREATE TABLE dbo.ChemicalDelivery(
  ChemicalDeliveryId INT IDENTITY(1,1) CONSTRAINT PK_ChemicalDelivery PRIMARY KEY,
  DeliveryDate DATE NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_ChemicalDelivery_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  Supplier NVARCHAR(200) NULL,
  Address NVARCHAR(255) NULL,
  DeliveredBy NVARCHAR(100) NULL,
  Receiver NVARCHAR(100) NULL,
  Location48h NVARCHAR(255) NULL,
  Packaging_Integrity BIT NULL,
  Packaging_Dry BIT NULL,
  Packaging_Clean BIT NULL,
  CreatedOn DATETIME2 NOT NULL CONSTRAINT DF_ChemicalDelivery_CreatedOn DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.ChemicalDeliveryLine(
  LineId BIGINT IDENTITY(1,1) CONSTRAINT PK_ChemicalDeliveryLine PRIMARY KEY,
  ChemicalDeliveryId INT NOT NULL CONSTRAINT FK_ChemicalDeliveryLine_Header REFERENCES dbo.ChemicalDelivery(ChemicalDeliveryId) ON DELETE CASCADE,
  ChemicalProductId INT NOT NULL CONSTRAINT FK_ChemicalDeliveryLine_Product REFERENCES dbo.ChemicalProduct(ChemicalProductId),
  Packing NVARCHAR(50) NULL,
  Unit NVARCHAR(20) NOT NULL,
  Quantity DECIMAL(12,2) NOT NULL,
  ProductionDate DATE NULL,
  ExpiryDate DATE NULL,
  ManufacturerId INT NULL CONSTRAINT FK_ChemicalDeliveryLine_Mf REFERENCES dbo.Manufacturer(ManufacturerId),
  Notes NVARCHAR(500) NULL
);

/* =============== Tồn kho =============== */
CREATE TABLE dbo.FeedInventoryTransaction(
  TransactionId BIGINT IDENTITY(1,1) CONSTRAINT PK_FeedInventoryTransaction PRIMARY KEY,
  WarehouseId INT NOT NULL CONSTRAINT FK_FeedInvTx_Warehouse REFERENCES dbo.Warehouse(WarehouseId),
  TranDate DATE NOT NULL,
  FeedTypeId INT NOT NULL CONSTRAINT FK_FeedInvTx_FeedType REFERENCES dbo.FeedType(FeedTypeId),
  BatchCode NVARCHAR(50) NULL,
  ExpiryDate DATE NULL,
  QtyInKg DECIMAL(12,2) NOT NULL CONSTRAINT DF_FeedInvTx_In DEFAULT 0,
  QtyOutKg DECIMAL(12,2) NOT NULL CONSTRAINT DF_FeedInvTx_Out DEFAULT 0,
  PondId INT NULL CONSTRAINT FK_FeedInvTx_Pond REFERENCES dbo.Pond(PondId),
  Notes NVARCHAR(1000) NULL
);
CREATE INDEX IX_FeedInvTx_Wh_Feed ON dbo.FeedInventoryTransaction(WarehouseId, FeedTypeId, TranDate DESC);

CREATE TABLE dbo.ChemicalInventoryTransaction(
  TransactionId BIGINT IDENTITY(1,1) CONSTRAINT PK_ChemInvTx PRIMARY KEY,
  WarehouseId INT NOT NULL CONSTRAINT FK_ChemInvTx_Warehouse REFERENCES dbo.Warehouse(WarehouseId),
  TranDate DATE NOT NULL,
  ChemicalProductId INT NOT NULL CONSTRAINT FK_ChemInvTx_Product REFERENCES dbo.ChemicalProduct(ChemicalProductId),
  BatchCode NVARCHAR(50) NULL,
  ExpiryDate DATE NULL,
  QtyIn DECIMAL(12,2) NOT NULL CONSTRAINT DF_ChemInvTx_In DEFAULT 0,
  QtyOut DECIMAL(12,2) NOT NULL CONSTRAINT DF_ChemInvTx_Out DEFAULT 0,
  Unit NVARCHAR(20) NOT NULL, -- kg/lít/...
  PondId INT NULL CONSTRAINT FK_ChemInvTx_Pond REFERENCES dbo.Pond(PondId),
  Notes NVARCHAR(1000) NULL
);
CREATE INDEX IX_ChemInvTx_Wh_Prod ON dbo.ChemicalInventoryTransaction(WarehouseId, ChemicalProductId, TranDate DESC);

/* =============== Nhật ký & theo dõi =============== */
CREATE TABLE dbo.DailyLog(
  DailyLogId BIGINT IDENTITY(1,1) CONSTRAINT PK_DailyLog PRIMARY KEY,
  PondId INT NOT NULL CONSTRAINT FK_DailyLog_Pond REFERENCES dbo.Pond(PondId),
  StockingId INT NULL CONSTRAINT FK_DailyLog_Stocking REFERENCES dbo.StockingEvent(StockingId),
  [Date] DATE NOT NULL,
  DaysFromStocking INT NULL,
  FishNumber INT NULL,
  DO_AM DECIMAL(4,2) NULL,
  DO_PM DECIMAL(4,2) NULL,
  Temp_AM DECIMAL(4,1) NULL,
  Temp_PM DECIMAL(4,1) NULL,
  PH_AM DECIMAL(3,1) NULL,
  PH_PM DECIMAL(3,1) NULL,
  FeedCompany NVARCHAR(100) NULL,
  FeedProtein DECIMAL(4,1) NULL,
  FeedSizeMm DECIMAL(4,1) NULL,
  FeedBatchCode NVARCHAR(50) NULL,
  FeedExpiryDate DATE NULL,
  FeedTotalKg DECIMAL(12,2) NULL,
  DeadFishCount INT NULL,
  DeadFishTotalKg DECIMAL(12,2) NULL,
  ChemicalProductId INT NULL CONSTRAINT FK_DailyLog_Chem REFERENCES dbo.ChemicalProduct(ChemicalProductId),
  ChemicalBatch NVARCHAR(50) NULL,
  ChemicalExpiryDate DATE NULL,
  ChemicalQuantity DECIMAL(12,2) NULL,
  ChemicalReason NVARCHAR(200) NULL,
  Notes NVARCHAR(1000) NULL,
  ResponsibleStaff NVARCHAR(100) NULL
);
CREATE INDEX IX_DailyLog_Pond_Date ON dbo.DailyLog(PondId, [Date] DESC);

CREATE TABLE dbo.ProductUsage(
  ProductUsageId INT IDENTITY(1,1) CONSTRAINT PK_ProductUsage PRIMARY KEY,
  [Date] DATE NOT NULL,
  RequestedBy NVARCHAR(100) NOT NULL,
  Position NVARCHAR(100) NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_ProductUsage_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  Proposal NVARCHAR(200) NULL
);

CREATE TABLE dbo.ProductUsageLine(
  LineId BIGINT IDENTITY(1,1) CONSTRAINT PK_ProductUsageLine PRIMARY KEY,
  ProductUsageId INT NOT NULL CONSTRAINT FK_ProductUsageLine_Header REFERENCES dbo.ProductUsage(ProductUsageId) ON DELETE CASCADE,
  PondId INT NOT NULL CONSTRAINT FK_ProductUsageLine_Pond REFERENCES dbo.Pond(PondId),
  ProductName NVARCHAR(200) NULL,
  ChemicalProductId INT NULL CONSTRAINT FK_ProductUsageLine_Product REFERENCES dbo.ChemicalProduct(ChemicalProductId),
  Unit NVARCHAR(20) NOT NULL,
  Quantity DECIMAL(12,2) NOT NULL,
  Reason NVARCHAR(200) NULL,
  Notes NVARCHAR(500) NULL
);

CREATE TABLE dbo.FishHealthCheck(
  HealthCheckId INT IDENTITY(1,1) CONSTRAINT PK_FishHealthCheck PRIMARY KEY,
  [Date] DATE NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_FishHealthCheck_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  FisheryStaff NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.FishHealthCheckLine(
  LineId BIGINT IDENTITY(1,1) CONSTRAINT PK_FishHealthCheckLine PRIMARY KEY,
  HealthCheckId INT NOT NULL CONSTRAINT FK_FishHealthCheckLine_Header REFERENCES dbo.FishHealthCheck(HealthCheckId) ON DELETE CASCADE,
  PondId INT NOT NULL CONSTRAINT FK_FishHealthCheckLine_Pond REFERENCES dbo.Pond(PondId),
  AvgWeightKg DECIMAL(8,3) NULL,
  DeadFishCount INT NULL,
  Parasites NVARCHAR(100) NULL,
  ClinicalSigns NVARCHAR(200) NULL,
  Solution NVARCHAR(200) NULL
);

CREATE TABLE dbo.WaterIntakeDrain(
  RecordId BIGINT IDENTITY(1,1) CONSTRAINT PK_WaterIntakeDrain PRIMARY KEY,
  [Date] DATE NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_WaterIntakeDrain_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  PondId INT NOT NULL CONSTRAINT FK_WaterIntakeDrain_Pond REFERENCES dbo.Pond(PondId),
  IntakeM3 DECIMAL(12,2) NOT NULL CONSTRAINT DF_WaterIntakeDrain_Intake DEFAULT 0,
  DrainM3 DECIMAL(12,2) NOT NULL CONSTRAINT DF_WaterIntakeDrain_Drain DEFAULT 0,
  Performer NVARCHAR(100) NULL
);
CREATE INDEX IX_WaterIntakeDrain_Date ON dbo.WaterIntakeDrain([Date]);

CREATE TABLE dbo.WastewaterResult(
  RecordId BIGINT IDENTITY(1,1) CONSTRAINT PK_WastewaterResult PRIMARY KEY,
  [Date] DATE NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_WastewaterResult_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  DischargeTime TIME NULL,
  DischargeVolumeM3 DECIMAL(12,2) NULL,
  IntakeTime TIME NULL,
  IntakeVolumeM3 DECIMAL(12,2) NULL,
  DO_Before DECIMAL(4,2) NULL,
  DO_During DECIMAL(4,2) NULL,
  PH_Before DECIMAL(3,1) NULL,
  PH_During DECIMAL(3,1) NULL,
  Smell_Before NVARCHAR(50) NULL,
  Smell_During NVARCHAR(50) NULL,
  Performer NVARCHAR(100) NULL,
  ConclusionOk BIT NULL
);

CREATE TABLE dbo.WasteType(
  WasteTypeId INT IDENTITY(1,1) CONSTRAINT PK_WasteType PRIMARY KEY,
  Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_WasteType_Name UNIQUE
);

CREATE TABLE dbo.WasteDelivery(
  RecordId BIGINT IDENTITY(1,1) CONSTRAINT PK_WasteDelivery PRIMARY KEY,
  [Date] DATE NOT NULL,
  FarmRegionId INT NOT NULL CONSTRAINT FK_WasteDelivery_Region REFERENCES dbo.FarmRegion(FarmRegionId),
  WasteTypeId INT NOT NULL CONSTRAINT FK_WasteDelivery_Type REFERENCES dbo.WasteType(WasteTypeId),
  Unit NVARCHAR(20) NOT NULL,
  Quantity DECIMAL(12,2) NOT NULL,
  Deliverer NVARCHAR(100) NULL,
  Receiver NVARCHAR(100) NULL
);

/* =============== View tồn kho =============== */
CREATE OR ALTER VIEW dbo.v_FeedInventoryBalance AS
SELECT
  WarehouseId, FeedTypeId,
  SUM(QtyInKg - QtyOutKg) AS BalanceKg
FROM dbo.FeedInventoryTransaction
GROUP BY WarehouseId, FeedTypeId;

CREATE OR ALTER VIEW dbo.v_ChemicalInventoryBalance AS
SELECT
  WarehouseId, ChemicalProductId,
  SUM(QtyIn - QtyOut) AS Balance
FROM dbo.ChemicalInventoryTransaction
GROUP BY WarehouseId, ChemicalProductId;

/* =============== Hàm & SP hỗ trợ =============== */

-- Hàm tính ngày HSD từ MSL theo quy tắc linh hoạt (tham số hoá)
CREATE OR ALTER FUNCTION dbo.fn_ExpiryFromMSL
(
  @MSL NVARCHAR(50),
  @BaseYear INT,         -- ví dụ: 2024
  @JulianDigits TINYINT, -- 3 hoặc 4 tuỳ format
  @AddDays INT           -- số ngày cộng thêm (ví dụ 89)
)
RETURNS DATE
AS
BEGIN
  DECLARE @digits NVARCHAR(10) = REVERSE(@MSL);
  DECLARE @jul NVARCHAR(4) = SUBSTRING(@digits, 2, @JulianDigits); -- ký tự 2-... từ phải
  SET @jul = REVERSE(@jul);
  DECLARE @julian INT = TRY_CONVERT(INT, LEFT(@jul,3)); -- 3 ký tự đầu là ngày trong năm
  IF @julian IS NULL OR @julian NOT BETWEEN 1 AND 366 RETURN NULL;
  DECLARE @d DATE = DATEADD(DAY, @julian-1, DATEFROMPARTS(@BaseYear,1,1));
  RETURN DATEADD(DAY, @AddDays, @d);
END;
GO

-- Báo cáo tốc độ tăng trưởng & mật độ cho ngày bất kỳ
CREATE OR ALTER PROCEDURE dbo.sp_GrowthAndDensity
  @TheDate DATE
AS
BEGIN
  SET NOCOUNT ON;
  ;WITH LatestHC AS (
     SELECT fhl.PondId, fhl.AvgWeightKg,
            ROW_NUMBER() OVER(PARTITION BY fhl.PondId ORDER BY fh.[Date] DESC) rn
     FROM dbo.FishHealthCheckLine fhl
     JOIN dbo.FishHealthCheck fh ON fh.HealthCheckId = fhl.HealthCheckId
     WHERE fh.[Date] <= @TheDate
  )
  SELECT p.PondCode, p.WaterSurfaceM2,
         dl.FishNumber,
         hc.AvgWeightKg,
         DensityKgPerM2 = CASE WHEN p.WaterSurfaceM2 IS NULL OR p.WaterSurfaceM2=0 OR dl.FishNumber IS NULL OR hc.AvgWeightKg IS NULL
                               THEN NULL
                               ELSE (dl.FishNumber*hc.AvgWeightKg)/NULLIF(p.WaterSurfaceM2,0) END
  FROM dbo.Pond p
  LEFT JOIN dbo.DailyLog dl ON dl.PondId = p.PondId AND dl.[Date] = @TheDate
  LEFT JOIN LatestHC hc ON hc.PondId = p.PondId AND hc.rn=1
  ORDER BY p.PondCode;
END;
GO

-- Tổng hợp cá chết theo ngày (trừ ao vượt ngưỡng)
CREATE OR ALTER PROCEDURE dbo.sp_DeadFishSummary
  @TheDate DATE,
  @ThresholdPercent DECIMAL(5,2) = 0.30  -- ví dụ theo giai đoạn
AS
BEGIN
  SET NOCOUNT ON;
  SELECT p.PondCode, dl.DeadFishTotalKg
  FROM dbo.DailyLog dl
  JOIN dbo.Pond p ON p.PondId = dl.PondId
  WHERE dl.[Date] = @TheDate
    AND (dl.DeadFishTotalKg IS NOT NULL)
    -- giả sử có cột FishNumber hôm trước để kiểm ngưỡng %, ở đây chỉ minh hoạ
  ORDER BY p.PondCode;
END;
GO

-- Kiểm tra giới hạn cấp/xả theo vùng
CREATE OR ALTER PROCEDURE dbo.sp_WaterLimitCheck
  @TheDate DATE
AS
BEGIN
  SET NOCOUNT ON;
  SELECT fr.Name AS Region, SUM(w.IntakeM3) AS TotalIntake, SUM(w.DrainM3) AS TotalDrain,
         fr.MaxIntakeM3PerDay, fr.MaxDischargeM3PerDay,
         IntakeExceeded = CASE WHEN SUM(w.IntakeM3) > ISNULL(fr.MaxIntakeM3PerDay, 9999999) THEN 1 ELSE 0 END,
         DrainExceeded = CASE WHEN SUM(w.DrainM3) > ISNULL(fr.MaxDischargeM3PerDay, 9999999) THEN 1 ELSE 0 END
  FROM dbo.WaterIntakeDrain w
  JOIN dbo.FarmRegion fr ON fr.FarmRegionId = w.FarmRegionId
  WHERE w.[Date] = @TheDate
  GROUP BY fr.Name, fr.MaxIntakeM3PerDay, fr.MaxDischargeM3PerDay
  ORDER BY fr.Name;
END;
GO
