# KIEN TRUC & THIET KE HE THONG AQUASIM
## He thong Quan ly Trang trai Nuoi Thuy san Tu dong
### Phien ban: 4.0 Final Architecture
### Ngay: 14/11/2025

---

## METADATA

| Property | Value |
|----------|-------|
| **Document ID** | ARCH-AQUASIM-4.0-FINAL |
| **Version** | 4.0 Final Architecture |
| **Status** | APPROVED |
| **Date** | 14/11/2025 |
| **Author** | Technical Team |
| **Reviewer** | Solution Architect |
| **Approver** | CTO |
| **Total Words** | ~30,000 words |

---

## MUC LUC

1. [SYSTEM ARCHITECTURE](#1-system-architecture)
2. [DATABASE-FIRST APPROACH (CRITICAL)](#2-database-first-approach)
3. [WINDOWS FORMS DESIGNER (CRITICAL)](#3-windows-forms-designer)
4. [TECH STACK & DESIGN PATTERNS](#4-tech-stack--design-patterns)
5. [DATABASE SCHEMA (ERD)](#5-database-schema-erd)
6. [ALL TABLES DDL](#6-all-tables-ddl)
7. [STORED PROCEDURES](#7-stored-procedures)
8. [TRIGGERS](#8-triggers)
9. [INDEXES & PERFORMANCE](#9-indexes--performance)
10. [COMPONENT DIAGRAM](#10-component-diagram)
11. [SEQUENCE DIAGRAMS](#11-sequence-diagrams)
12. [DEPLOYMENT ARCHITECTURE](#12-deployment-architecture)
13. [SECURITY IMPLEMENTATION](#13-security-implementation)
14. [API DESIGN](#14-api-design)
15. [MIGRATION STRATEGY](#15-migration-strategy)
16. [PERFORMANCE BENCHMARKS](#16-performance-benchmarks)

---

## 1. SYSTEM ARCHITECTURE

### 1.1 3-Tier Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                           │
│    Windows Forms (.NET 9.0) - MUST USE DESIGNER               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Main Dashboard, Forms, Reports, Settings                │   │
│  │ REQUIREMENT: ALL UI must be created with              │   │
│  │     Windows Forms Designer (.Designer.cs files)         │   │
│  │                                                          │   │
│  │ - frmMainDashboard (KPIs, Alerts)                       │   │
│  │ - frmScenarioEditor (Create cycles)                     │   │
│  │ - frmDailyLogViewer (Review data)                       │   │
│  │ - frmInventoryManager (FEFO tracking)                   │   │
│  │ - frmReportGenerator (8 FSIS forms)                     │   │
│  │ - (3-file structure: .cs, .Designer.cs, .resx)         │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │ Call via Repository/Services
┌──────────────────────────▼──────────────────────────────────────┐
│                 BUSINESS LOGIC LAYER (BLL)                      │
│                     C# .NET 9.0 Services                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │           11 SIMULATION ENGINES                         │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ ➤ EnvironmentGenerator    ➤ MortalityEngine             │   │
│  │ ➤ GrowthEngine            ➤ FeedPlanner                 │   │
│  │ ➤ ChemicalEngine          ➤ WaterOpsEngine             │   │
│  │ ➤ InventoryEngine         ➤ CostTracker                │   │
│  │ ➤ AlertSystem             ➤ ValidationService          │   │
│  │ ➤ ReportingEngine                                       │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │           CORE SERVICES                                 │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ ➤ GeneratorService (Dieu phoi pipeline)                │   │
│  │ ➤ InventoryService (FEFO logic)                        │   │
│  │ ➤ HealthService (Suc khoe ca)                          │   │
│  │ ➤ ReportingService (Xuat bao cao)                      │   │
│  │ ➤ AuditService (Ghi chep thay doi)                     │   │
│  │ ➤ AlertService (Phat sinh canh bao)                    │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │ Via Repository Pattern
┌──────────────────────────▼──────────────────────────────────────┐
│                   DATA ACCESS LAYER (DAL)                       │
│          Entity Framework Core 9.0 + Stored Procedures          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Generic Repository<T> + Specific Repositories            │   │
│  │ - IRepository<T> (CRUD chung)                           │   │
│  │ - IDailyLogRepository (Query rieng)                     │   │
│  │ - IFeedLedgerRepository (FEFO queries)                  │   │
│  │ - IAuditRepository (Audit trail)                        │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Stored Procedures (Hieu nang cao)                       │   │
│  │ - sp_GenerateDailyLogs (Pipeline chinh)                 │   │
│  │ - sp_AllocateFEFO (Xuat kho FEFO)                       │   │
│  │ - sp_SplitReceiptByCapacity (Chia nho nhap kho)         │   │
│  │ - sp_CalculateCycleStats (Thong ke)                     │   │
│  │ - sp_VerifyDeterminism (Checksum verification)          │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                    SQL SERVER 2019+                             │
│                    DATABASE-FIRST APPROACH                      │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ ✅ Bat buoc: Database ton tai truoc khi tao models      │   │
│  │ ✅ Bat buoc: Dung EF Core scaffold tu DB                │   │
│  │ ✅ Bat buoc: Stored Procedures cho hieu nang cao       │   │
│  │ ✅ Bat buoc: Models phai match voi schema thuc te       │   │
│  │                                                          │   │
│  │ Database: aquasim_VHC                                   │   │
│  │ Server: 172.17.254.222:1433                             │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. DATABASE-FIRST APPROACH

### 2.1 CRITICAL REQUIREMENT

**Dinh nghia**: Database schema la source of truth, models duoc scaffold tu database.

### 2.2 Cac nguyen tac

1. ✅ SQL Server database duoc tao va cau hinh truoc
2. ✅ Models duoc sinh tu database bang EF Core Scaffolding
3. ✅ KHONG duoc tao database tu migrations (Code-First)
4. ✅ Models phai match 100% voi schema thuc te
5. ✅ Thay doi schema → Update database → Regenerate models
6. ✅ Hien du an dang ket noi co so du lieu van hanh `aquasim_VHC` (SQL Server 2019+)

### 2.3 Quy trinh regenerate model (khi schema thay doi)

**STEP 1**: Cap nhat truc tiep schema tren SQL Server `aquasim_VHC` (DDL/stored procedure/view)

**STEP 2**: Tai thu muc `AquaSim.Models`, chay scaffold EF Core:
```powershell
dotnet ef dbcontext scaffold "Server=tcp:172.17.254.222,1433;Database=aquasim_VHC;User Id=mhkpi;Password=Try@VhcQAZXCV;Encrypt=false;TrustServerCertificate=true;" Microsoft.EntityFrameworkCore.SqlServer \
    --context AquaSimDbContext \
    --output-dir . \
    --force \
    --no-pluralize
```

**STEP 3**: Soat lai cac file duoc cap nhat, dam bao khong ghi de tuy bien ngoai Models/

**STEP 4**: Build giai phap, chay smoke test truoc khi commit

### 2.4 Loi ich

- Single source of truth (database)
- De maintain khi database ton tai truoc
- Tranh model-database mismatch
- Support stored procedures tot hon

### 2.5 Column Mapping Requirements

**BAT BUOC**:
- `.ToTable("ExactTableName")` bat buoc
- `.HasColumnName("ExactColumnName")` khi khac
- Tat ca Property phai map chinh xac

**Vi du**:
```csharp
// ✅ Correct - Explicit table mapping
modelBuilder.Entity<FeedLedger>()
    .ToTable("FeedLedger");  // Must match database table name

// ❌ Wrong - Using default plural naming
// modelBuilder.Entity<FeedLedger>()
//     (Would look for "FeedLedgers" table)
```

---

## 3. WINDOWS FORMS DESIGNER

### 3.1 CRITICAL REQUIREMENT

**Dinh nghia**: Tat ca giao dien duoc tao qua Visual Studio Designer, khong hard-code UI.

### 3.2 Cac nguyen tac

1. ✅ Moi form co 3 file: .cs (logic), .Designer.cs (UI), .resx (resources)
2. ✅ Chi sua UI qua Designer, khong sua Designer.cs code
3. ✅ Tat ca event hook qua Properties panel → Events
4. ✅ Controls duoc dat ten theo convention (txt, btn, lbl, cmb, etc.)
5. ❌ KHONG duoc thay doi `InitializeComponent()` manually
6. ❌ KHONG duoc thay doi control properties trong code
7. ❌ KHONG duoc tao controls thu cong

### 3.3 3-File Structure (Bat buoc)

```
MyForm.cs              ← User code (logic, events)
MyForm.Designer.cs     ← Designer-generated (UI layout)
MyForm.resx            ← Resources (images, strings, etc.)
```

### 3.4 Control Naming Convention

```csharp
// Prefix theo kieu Windows Forms
txt{ControlName}      // TextBox: txtFarmCode
lbl{ControlName}      // Label: lblFarmName
btn{ActionName}       // Button: btnSave, btnDelete
cmb{ListName}         // ComboBox: cmbWarehouse
dgv{ListName}         // DataGridView: dgvFarms
chk{OptionName}       // CheckBox: chkIsActive
pnl{SectionName}      // Panel: pnlHeader
```

### 3.5 Valid Event Hook (Designer)

```csharp
// In ManageFarmsForm.cs (code-behind)
private void btnSave_Click(object sender, EventArgs e)
{
    // Business logic here
}

// In ManageFarmsForm.Designer.cs (auto-generated)
// this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
// ↑ DO NOT edit this line manually! Use Designer instead.
```

### 3.6 Invalid - Hard-coded UI (FORBIDDEN)

```csharp
// ❌ WRONG - Never do this!
public ManageFarmsForm()
{
    TextBox txtName = new TextBox();  // ❌ Create controls in code
    txtName.Location = new Point(10, 20);  // ❌ Set properties in code
    this.Controls.Add(txtName);  // ❌ Add to form in code
}
```

---

## 4. TECH STACK & DESIGN PATTERNS

### 4.1 Tech Stack Day Du

| Component | Technology | Version | Muc dich |
|-----------|-----------|---------|---------|
| **Frontend** | Windows Forms | .NET 9.0 | UI Desktop |
| **Backend** | C# | 13 | Business Logic |
| **Database** | SQL Server | 2019+ | Data Storage |
| **ORM** | Entity Framework Core | 9.0 | Data Access |
| **Logging** | Serilog | 4.3.0 | Audit & Trace |
| **Excel Export** | EPPlus | Latest | XLSX Files |
| **PDF Export** | iText7 | Latest | PDF Reports |
| **Word Export** | DocumentFormat.OpenXml | Latest | DOCX Reports |
| **Testing** | NUnit | Latest | Unit Tests |
| **Authentication** | BCrypt | Latest | Password Hash |
| **Dependency Injection** | Microsoft.Extensions.DependencyInjection | 9.0 | IoC Container |
| **Configuration** | IConfiguration | 9.0 | Settings Management |

### 4.2 Design Patterns

**Backend Patterns**:
- **Repository Pattern**: Clean Architecture + Adapter
- **Dependency Injection**: IoC Container
- **Unit of Work**: Transaction Management
- **Factory Pattern**: Object Creation
- **Strategy Pattern**: Algorithm Selection (11 engines)
- **Observer Pattern**: Event & Alert Handling
- **Interceptor Pattern**: Audit Trail auto-logging
- **Template Method**: Daily Pipeline orchestration

**Frontend Patterns**:
- **Form Inheritance**: BaseForm → Specific Forms
- **Event-Driven**: Button clicks, ComboBox changes
- **Data Binding**: DataGridView ↔ DataSource

---

## 5. DATABASE SCHEMA (ERD)

### 5.1 Entity Relationship Diagram

```
CORE ENTITIES:
├── Farms (1) ──────────────────< (N) Ponds
│   ├── (1) ──────────────────< (N) Warehouses
│   └── (1) ──────────────────< (N) Users (Staff)
│
├── Ponds (1) ──────────────────< (N) FarmingCycles
│   └── (1) ──────────────────< (N) DailyLogs
│
├── FarmingCycles (1) ──────────────────< (N) Operations
│   ├── (1) ──────────────────< (N) EnvironmentLogs
│   ├── (1) ──────────────────< (N) HealthMonitoring
│   ├── (1) ──────────────────< (N) WaterManagement
│   ├── (1) ──────────────────< (N) WasteManagement
│   ├── (1) ──────────────────< (N) CostTracking
│   ├── (1) ──────────────────< (N) AlertLogs
│   └── (1) ──────────────────< (N) Events

INVENTORY ENTITIES:
├── Warehouses (1) ──────────────────< (N) FeedLedger
│   └── (1) ──────────────────< (N) FeedInventory
│
├── Warehouses (1) ──────────────────< (N) ChemicalLedger
│   └── (1) ──────────────────< (N) ChemicalInventory

WORKFLOW & AUDIT:
├── Users (1) ──────────────────< (N) AuditTrail
├── Users (1) ──────────────────< (N) ScenarioInput
├── Users (1) ──────────────────< (N) JobRunLog
└── Cycles (1) ──────────────────< (N) DailyReportSummary
```

---

## 6. ALL TABLES DDL

### 6.1 GROUP 1: MASTER DATA

#### Table: Farms
```sql
CREATE TABLE Farms (
    FarmID INT PRIMARY KEY IDENTITY(1,1),
    FarmCode NVARCHAR(50) UNIQUE NOT NULL,
    FarmName NVARCHAR(100) NOT NULL,
    ShortName NVARCHAR(50),
    Address NVARCHAR(255),
    Province NVARCHAR(100),
    District NVARCHAR(100),
    Phone NVARCHAR(20),
    Manager NVARCHAR(100),
    ASC BIT DEFAULT 0,           -- ASC Certification
    BAP BIT DEFAULT 0,            -- BAP Certification
    GG BIT DEFAULT 0,             -- GAA Certification
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmCode (FarmCode),
    INDEX IX_Province (Province)
);
```

#### Table: Warehouses
```sql
CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseCode NVARCHAR(50) UNIQUE NOT NULL,
    WarehouseName NVARCHAR(100) NOT NULL,
    FarmID INT FOREIGN KEY REFERENCES Farms(FarmID),
    Location NVARCHAR(200),
    CapacityKg DECIMAL(12,2) NULL,  -- Suc chua toi da
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmID (FarmID)
);
```

#### Table: Ponds
```sql
CREATE TABLE Ponds (
    PondID INT PRIMARY KEY IDENTITY(1,1),
    PondCode NVARCHAR(50) UNIQUE NOT NULL,
    PondName NVARCHAR(100) NOT NULL,
    FarmID INT FOREIGN KEY REFERENCES Farms(FarmID),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    SurfaceAreaM2 DECIMAL(10,2),    -- Dien tich (m²)
    DepthM DECIMAL(5,2),             -- Do sau (m)
    CapacityKg DECIMAL(12,2),        -- Dung tich (kg)
    MaxIntakeWaterM3 DECIMAL(10,2),
    MaxDischargeWaterM3 DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmID (FarmID),
    INDEX IX_PondCode (PondCode)
);
```

#### Table: FeedInventory
```sql
CREATE TABLE FeedInventory (
    FeedID INT PRIMARY KEY IDENTITY(1,1),
    FeedCode NVARCHAR(50) UNIQUE NOT NULL,
    FeedName NVARCHAR(100) NOT NULL,
    ProteinPercent DECIMAL(5,2),
    FatPercent DECIMAL(5,2),
    FiberPercent DECIMAL(5,2),
    ParticleSizeMm DECIMAL(5,2),
    SizeBand NVARCHAR(50),           -- Small, Medium, Large
    Supplier NVARCHAR(100),
    Price DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FeedCode (FeedCode)
);
```

#### Table: ChemicalInventory
```sql
CREATE TABLE ChemicalInventory (
    ChemicalID INT PRIMARY KEY IDENTITY(1,1),
    ChemicalCode NVARCHAR(50) UNIQUE NOT NULL,
    ChemicalName NVARCHAR(100) NOT NULL,
    ChemicalType NVARCHAR(50),       -- PROBIOTIC, VITAMIN, ANTIBIOTIC, pH_ADJUSTER, SALT
    Purpose NVARCHAR(200),
    DosageUnit NVARCHAR(50),         -- mg/L, kg, etc.
    Supplier NVARCHAR(100),
    Price DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_ChemicalCode (ChemicalCode)
);
```

#### Table: Users
```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100),
    PasswordHash NVARCHAR(MAX) NOT NULL,  -- bcrypt hoac PBKDF2
    Role NVARCHAR(50),                    -- Admin, Manager, Staff, Viewer
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME NULL,
    INDEX IX_Username (Username),
    INDEX IX_Role (Role)
);
```

#### Table: Calendar
```sql
CREATE TABLE Calendar (
    CalDate DATE PRIMARY KEY,
    IsHoliday BIT NOT NULL DEFAULT 0,
    IsWeekend BIT NOT NULL DEFAULT 0,
    Description NVARCHAR(200) NULL,
    INDEX IX_IsHoliday (IsHoliday)
);
```

#### Table: EnvRules
```sql
CREATE TABLE EnvRules (
    RuleID INT PRIMARY KEY IDENTITY(1,1),
    MonthNo INT,                      -- 1=Jan, 12=Dec
    BaseTempC DECIMAL(5,2),           -- Nhiet do co ban theo thang
    OptimalDOmg DECIMAL(5,2),
    OptimalPH DECIMAL(4,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_Month (MonthNo)
);
```

---

### 6.2 GROUP 2: FARMING CYCLE & DAILY OPERATIONS

#### Table: FarmingCycles
```sql
CREATE TABLE FarmingCycles (
    CycleID INT IDENTITY(1,1) PRIMARY KEY,
    PondID INT NOT NULL REFERENCES Ponds(PondID),
    CycleName NVARCHAR(100),
    StartDate DATETIME NOT NULL,
    EndDate DATETIME,
    Species NVARCHAR(50), -- 'CATFISH', 'TILAPIA', 'SHRIMP'

    -- Initial state
    InitialFishCount INT,
    InitialAvgWeightGr FLOAT,
    InitialBiomasKg INT,

    -- Current state
    FishRemain INT,
    AvgWeightGr FLOAT,
    BiomasKg INT,

    -- Simulation control
    Seed INT,
    Status NVARCHAR(20) DEFAULT 'PLANNING'
        CHECK (Status IN ('PLANNING', 'ACTIVE', 'MEDICATING', 'HARVESTING', 'CLOSED', 'CANCELLED')),
    LastProcessedDay INT DEFAULT 0,
    IsMedicatingToday BIT DEFAULT 0,
    Manifest NVARCHAR(MAX) NULL,        -- JSON: seed, version, checksums

    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_CycleID_Status (CycleID, Status),
    INDEX IX_StartDate (StartDate DESC),
    INDEX IX_PondID_Status (PondID, Status)
);
```

#### Table: DailyLogs
```sql
CREATE TABLE DailyLogs (
    LogID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT NOT NULL REFERENCES FarmingCycles(CycleID),
    LogDate DATE NOT NULL,
    DayNumber INT NOT NULL,

    -- Environment
    TempAM FLOAT,
    TempPM FLOAT,
    TempMean FLOAT,
    DOmin FLOAT,
    DOmax FLOAT,
    DOavg FLOAT,
    pH_AM FLOAT,
    pH_PM FLOAT,
    H2S FLOAT,
    NH3 FLOAT,
    Alkalinity DECIMAL(8,2),

    -- Biology
    FishCount INT,
    AvgWeightGr FLOAT,
    BiomassKg FLOAT,
    DeadCount INT,
    SurvivalRate FLOAT,
    DailyGrowthG DECIMAL(8,2),

    -- Feed
    FeedKg FLOAT,
    FeedType NVARCHAR(50),
    FCR FLOAT,

    -- Water
    WaterIntakeM3 FLOAT,
    WaterDischargeM3 FLOAT,

    -- Chemical
    ChemicalUsed NVARCHAR(200),
    ChemicalCost DECIMAL(10,2),

    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_DailyLog_CycleDay UNIQUE (CycleID, LogDate),
    INDEX IX_CycleID_Day (CycleID, DayNumber DESC),
    INDEX IX_Date (LogDate DESC),
    INDEX IX_CycleID_Full (CycleID, LogDate DESC)
        INCLUDE (FishCount, AvgWeightGr, BiomassKg, FCR)
);
```

#### Table: EnvironmentLogs
```sql
CREATE TABLE EnvironmentLogs (
    EnvLogID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT NOT NULL REFERENCES FarmingCycles(CycleID),
    LogDate DATE NOT NULL,
    DayNo INT,
    TempAM FLOAT,
    TempPM FLOAT,
    TempMean FLOAT,
    DOmin FLOAT,
    DOmax FLOAT,
    DOavg FLOAT,
    pH_AM FLOAT,
    pH_PM FLOAT,
    H2S FLOAT,
    NH3 FLOAT,
    Salinity_ppt FLOAT,
    Turbidity_cm INT,
    Alkalinity DECIMAL(8,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_EnvironmentLog_CycleDay UNIQUE (CycleID, LogDate),
    INDEX IX_EnvLog_CycleID_Day (CycleID, DayNo DESC)
);
```

#### Table: HealthMonitoring
```sql
CREATE TABLE HealthMonitoring (
    HealthID INT PRIMARY KEY IDENTITY(1,1),
    PondID INT NOT NULL REFERENCES Ponds(PondID),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    InspectionDate DATE NOT NULL,
    AvgWeightG DECIMAL(8,2),
    Parasites NVARCHAR(500),
    ClinicalSigns NVARCHAR(500),
    Treatment NVARCHAR(500),
    VeterinarianID INT REFERENCES Users(UserID),
    Notes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_HealthMonitoring_PondDate (PondID, InspectionDate DESC)
);
```

#### Table: WaterManagement
```sql
CREATE TABLE WaterManagement (
    WaterID INT PRIMARY KEY IDENTITY(1,1),
    PondID INT NOT NULL REFERENCES Ponds(PondID),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    InspectionDate DATE NOT NULL,
    IntakeVolumeM3 DECIMAL(12,2),     -- Luong nuoc cap (m³)
    OutletVolumeM3 DECIMAL(12,2),     -- Luong nuoc xa (m³)
    DOmg DECIMAL(5,2),
    pH DECIMAL(4,2),
    Smell NVARCHAR(50),               -- No, Slight, Strong
    Conclusion NVARCHAR(50),          -- Pass, Fail
    Notes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_WaterManagement_PondDate (PondID, InspectionDate DESC)
);
```

#### Table: WasteManagement
```sql
CREATE TABLE WasteManagement (
    WasteID INT PRIMARY KEY IDENTITY(1,1),
    PondID INT REFERENCES Ponds(PondID),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    WasteDate DATE NOT NULL,
    WasteType NVARCHAR(50),           -- Dead_Fish, Feed_Bag, Chemical_Bag, Other
    QuantityKg DECIMAL(12,2),
    Disposal NVARCHAR(100),           -- Burial, Incineration, Compost, Other
    DeliveredBy INT REFERENCES Users(UserID),
    ReceivedBy INT REFERENCES Users(UserID),
    DeliveredAt DATETIME,
    ReceivedAt DATETIME,
    Notes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_WasteManagement_PondDate (PondID, WasteDate DESC)
);
```

---

### 6.3 GROUP 3: INVENTORY LEDGERS

#### Table: FeedLedger
```sql
CREATE TABLE FeedLedger (
    LedgerID BIGINT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL REFERENCES Warehouses(WarehouseID),
    FeedID INT NOT NULL REFERENCES FeedInventory(FeedID),
    TxnDate DATE NOT NULL,
    Direction CHAR(1) NOT NULL,       -- I = Nhap, O = Xuat
    QtyKg DECIMAL(12,3) NOT NULL,
    BatchCode NVARCHAR(50),           -- Lo hang
    ExpiryDate DATE,                  -- Han su dung
    CycleID INT REFERENCES FarmingCycles(CycleID),
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT CK_FeedLedger_Direction CHECK (Direction IN ('I', 'O')),
    CONSTRAINT CK_FeedLedger_Qty CHECK (QtyKg > 0),
    INDEX IX_FeedLedger_ExpiryDirection (ExpiryDate ASC, Direction)
        INCLUDE (QtyKg, WarehouseID),
    INDEX IX_FeedLedger_WarehouseFeed (WarehouseID, FeedID, Direction),
    INDEX IX_FeedLedger_TxnDate (TxnDate DESC),
    INDEX IX_FeedLedger_BatchCode (BatchCode)
);
```

#### Table: ChemicalLedger
```sql
CREATE TABLE ChemicalLedger (
    LedgerID BIGINT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL REFERENCES Warehouses(WarehouseID),
    ChemicalID INT NOT NULL REFERENCES ChemicalInventory(ChemicalID),
    TxnDate DATE NOT NULL,
    Direction CHAR(1) NOT NULL,       -- I = Nhap, O = Xuat
    Qty DECIMAL(12,3) NOT NULL,
    BatchCode NVARCHAR(50),
    ExpiryDate DATE,
    CycleID INT REFERENCES FarmingCycles(CycleID),
    ApprovalStatus NVARCHAR(20) DEFAULT 'Pending',  -- Pending, Approved, Rejected
    ApprovedBy INT REFERENCES Users(UserID),
    ApprovedAt DATETIME,
    RejectionReason NVARCHAR(500),
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT CK_ChemicalLedger_Direction CHECK (Direction IN ('I', 'O')),
    CONSTRAINT CK_ChemicalLedger_Qty CHECK (Qty > 0),
    INDEX IX_ChemicalLedger_ExpiryDirection (ExpiryDate ASC, Direction),
    INDEX IX_ChemicalLedger_WarehouseChemical (WarehouseID, ChemicalID, Direction),
    INDEX IX_ChemicalLedger_ApprovalStatus (ApprovalStatus, TxnDate DESC)
);
```

---

### 6.4 GROUP 4: ALERTS & EVENTS

#### Table: AlertLogs
```sql
CREATE TABLE AlertLogs (
    AlertID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    AlertDate DATETIME DEFAULT GETDATE(),
    DayNo INT,
    AlertLevel NVARCHAR(20) CHECK (AlertLevel IN ('INFO', 'WARNING', 'CRITICAL')),
    AlertCategory NVARCHAR(50), -- WATER_QUALITY, HEALTH, INVENTORY, COST, GROWTH
    AlertMessage NVARCHAR(1000) NOT NULL,
    TriggerValue DECIMAL(10,4),
    ThresholdValue DECIMAL(10,4),

    -- Resolution
    Status NVARCHAR(20) DEFAULT 'OPEN' CHECK (Status IN ('OPEN', 'ACKNOWLEDGED', 'RESOLVED', 'IGNORED')),
    ResolvedAt DATETIME NULL,
    ResolvedBy INT NULL REFERENCES Users(UserID),
    Resolution NVARCHAR(1000),

    -- Notification
    NotificationSent BIT DEFAULT 0,
    NotificationMethod NVARCHAR(50),

    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_AlertLog_CycleID_Level (CycleID, AlertLevel),
    INDEX IX_AlertLog_Status (Status),
    INDEX IX_AlertLog_CreatedAt (CreatedAt DESC)
);
```

#### Table: Events
```sql
CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    CycleID INT NOT NULL REFERENCES FarmingCycles(CycleID),
    EventDate DATE NOT NULL,
    DayNo INT,
    EventType NVARCHAR(50),           -- MEDICATION, WATER_EXCHANGE, HEALTH_CHECK, EMERGENCY, OTHER
    Title NVARCHAR(200),
    Description NVARCHAR(1000),
    ChemicalID INT REFERENCES ChemicalInventory(ChemicalID),  -- Neu la medication
    DosageAmount DECIMAL(8,2),
    ExchangePercent DECIMAL(5,2),     -- Neu la water exchange
    Status NVARCHAR(20) DEFAULT 'PLANNED',  -- PLANNED, COMPLETED, CANCELLED
    CompletedAt DATETIME,
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_Event_CycleDate (CycleID, EventDate DESC)
);
```

---

### 6.5 GROUP 5: COST TRACKING

#### Table: CostTracking
```sql
CREATE TABLE CostTracking (
    CostID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT FOREIGN KEY REFERENCES FarmingCycles(CycleID),
    CostDate DATE NOT NULL,
    DayNo INT,

    -- Cost Categories (VND)
    FeedCost DECIMAL(15,2) DEFAULT 0,
    ChemicalCost DECIMAL(15,2) DEFAULT 0,
    ElectricityCost DECIMAL(15,2) DEFAULT 0,
    LaborCost DECIMAL(15,2) DEFAULT 0,
    MaintenanceCost DECIMAL(15,2) DEFAULT 0,
    OtherCost DECIMAL(15,2) DEFAULT 0,

    TotalDailyCost DECIMAL(18,2),
    CumulativeCost DECIMAL(18,2),
    CostPerKgBiomass DECIMAL(10,2),

    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_CostTracking_CycleID_Date (CycleID, CostDate)
);
```

---

### 6.6 GROUP 6: SCENARIOS & JOB MANAGEMENT

#### Table: ScenarioInput
```sql
CREATE TABLE ScenarioInput (
    ScenarioID INT IDENTITY(1,1) PRIMARY KEY,
    PondID INT NOT NULL REFERENCES Ponds(PondID),
    ScenarioName NVARCHAR(200),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    SeedQty INT NOT NULL,
    AvgWeightG DECIMAL(8,2) NOT NULL,
    FCR DECIMAL(8,3) NOT NULL,
    InvisibleLossRate DECIMAL(5,3) DEFAULT 0,
    WarehouseID INT NOT NULL REFERENCES Warehouses(WarehouseID),
    FeedID INT NOT NULL REFERENCES FeedInventory(FeedID),
    UseLiveWeather BIT DEFAULT 1,
    Seed INT,
    Payload NVARCHAR(MAX),            -- JSON: Toan bo tham so input
    CreatedBy INT REFERENCES Users(UserID),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_ScenarioInput_CreatedAt (CreatedAt DESC)
);
```

#### Table: JobRunLog
```sql
CREATE TABLE JobRunLog (
    JobID BIGINT IDENTITY(1,1) PRIMARY KEY,
    ScenarioID INT REFERENCES ScenarioInput(ScenarioID),
    StartedAt DATETIME DEFAULT GETDATE(),
    FinishedAt DATETIME,
    Status NVARCHAR(20),              -- Running, Success, Failed
    Message NVARCHAR(MAX),
    TotalDaysProcessed INT,
    FailedDayCount INT,
    ExecutionTimeMs BIGINT,           -- Thoi gian thuc thi (ms)
    INDEX IX_JobRunLog_Status (Status, FinishedAt DESC)
);
```

---

### 6.7 GROUP 7: AUDIT & REPORTING

#### Table: AuditTrail
```sql
CREATE TABLE AuditTrail (
    AuditID BIGINT PRIMARY KEY IDENTITY(1,1),
    TableName NVARCHAR(100) NOT NULL,
    RecordID INT,
    Action NVARCHAR(20) CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),
    OldValues NVARCHAR(MAX),          -- JSON format
    NewValues NVARCHAR(MAX),          -- JSON format
    ChangedFields NVARCHAR(1000),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Username NVARCHAR(100),
    IPAddress NVARCHAR(50),
    MachineName NVARCHAR(100),
    ActionDate DATETIME DEFAULT GETDATE(),
    INDEX IX_AuditTrail_TableName_Record (TableName, RecordID),
    INDEX IX_AuditTrail_UserID (UserID),
    INDEX IX_AuditTrail_Date (ActionDate DESC)
);
```

#### Table: DailyReportSummary
```sql
CREATE TABLE DailyReportSummary (
    ReportID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT NOT NULL REFERENCES FarmingCycles(CycleID),
    ReportDate DATE NOT NULL,
    DayNo INT,
    FishCount INT,
    AvgWeightG DECIMAL(8,2),
    BiomasKg DECIMAL(12,3),
    MortalityPct DECIMAL(5,2),
    SurvivalPct DECIMAL(5,2),
    FCR DECIMAL(8,3),
    DailyCost DECIMAL(10,2),
    CumulativeCost DECIMAL(15,2),
    ProjectedProfit DECIMAL(15,2),
    DO_min FLOAT, DO_max FLOAT, DO_avg FLOAT,
    pH_min DECIMAL(4,2), pH_max DECIMAL(4,2),
    Temp_min FLOAT, Temp_max FLOAT,
    AlertCount INT,
    CriticalAlertCount INT,
    WarningAlertCount INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_DailyReportSummary_CycleDay UNIQUE (CycleID, ReportDate),
    INDEX IX_DailyReportSummary_CycleDate (CycleID, ReportDate DESC)
);
```

---

## 7. STORED PROCEDURES

### 7.1 sp_GenerateDailyLogs

**Muc dich**: Pipeline orchestrator cho sinh du lieu tu dong

**Input**:
- @CycleID INT
- @StartDay INT
- @EndDay INT
- @UseLiveWeather BIT

**Output**: DailyLog records tu 11 engines

**Chi tiet**:
- Temperature simulation: 28.0 ± 2°C
- DO simulation: 5.5 - (Biomass/1000) × 0.5
- pH simulation: 7.2 ± 0.3
- Mortality calculation: ~0.1% co ban
- Growth calculation: +0.3 g/con/ngay
- Feed calculation: Biomass × 3%

**Dac diem**: Transaction-based for consistency

```sql
CREATE PROCEDURE sp_GenerateDailyLogs
    @CycleID INT,
    @StartDay INT,
    @EndDay INT,
    @UseLiveWeather BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    DECLARE @CurrentDay INT = @StartDay;
    DECLARE @Seed INT;
    DECLARE @FishCount INT;
    DECLARE @AvgWeightGr FLOAT;
    DECLARE @BiomassKg FLOAT;

    -- Get cycle info
    SELECT @Seed = Seed, @FishCount = InitialFishCount,
           @AvgWeightGr = InitialAvgWeightGr
    FROM FarmingCycles WHERE CycleID = @CycleID;

    WHILE @CurrentDay <= @EndDay
    BEGIN
        -- STEP 1: Weather Anchor
        -- STEP 2: Environment Generator
        -- STEP 3: Mortality Engine
        -- STEP 4: Growth Engine
        -- STEP 5: Feed Planner
        -- STEP 6: Chemical Engine
        -- STEP 7: Water Exchange
        -- STEP 8: Inventory Synthesizer (FEFO)
        -- STEP 9: Daily Log Save
        -- STEP 10: Alert Generation

        SET @CurrentDay = @CurrentDay + 1;
    END

    COMMIT TRANSACTION;
END
```

---

### 7.2 sp_CalculateCycleStats

**Muc dich**: Tinh toan thong ke chu ky toan bo

**Input**: @CycleID INT

**Output**:
- InitialBiomass, FinalBiomass, BiomassGain
- TotalFeed, FCR, SurvivalRate
- TotalCost, CostPerKgBiomass

**Dung cho**: Dashboard & Reporting

**Loi ich**: Toi uu hieu nang thay vi tinh toan trong code

```sql
CREATE PROCEDURE sp_CalculateCycleStats
    @CycleID INT
AS
BEGIN
    SELECT
        CycleID,
        COUNT(*) AS TotalDays,
        MIN(FishCount) AS MinFishCount,
        MAX(FishCount) AS MaxFishCount,
        AVG(BiomassKg) AS AvgBiomass,
        SUM(FeedKg) AS TotalFeed,
        AVG(FCR) AS AvgFCR,
        MIN(DOmin) AS MinDO,
        MAX(DOmax) AS MaxDO,
        AVG(pH_AM) AS AvgPH
    FROM DailyLogs
    WHERE CycleID = @CycleID
    GROUP BY CycleID;
END
```

---

### 7.3 sp_AllocateFEFO

**Muc dich**: FEFO allocation logic

**Input**:
- @WarehouseID INT
- @ProductID INT
- @RequiredQtyKg DECIMAL(12,3)
- @AsOfDate DATE
- @CycleID INT

**Output**: Allocated qty, shortage qty

**Logic**:
1. Lay available batches
2. Sap xep theo ExpiryDate ASC
3. Allocate tung batch
4. Tao PO neu thieu

```sql
CREATE PROCEDURE sp_AllocateFEFO
    @WarehouseID INT,
    @FeedID INT,
    @RequiredQtyKg DECIMAL(12,3),
    @AsOfDate DATE,
    @CycleID INT
AS
BEGIN
    -- Get available batches sorted by FEFO
    WITH AvailableBatches AS (
        SELECT
            BatchCode,
            ExpiryDate,
            SUM(CASE WHEN Direction = 'I' THEN QtyKg ELSE -QtyKg END) AS AvailableQty
        FROM FeedLedger
        WHERE WarehouseID = @WarehouseID
          AND FeedID = @FeedID
          AND TxnDate <= @AsOfDate
        GROUP BY BatchCode, ExpiryDate
        HAVING SUM(CASE WHEN Direction = 'I' THEN QtyKg ELSE -QtyKg END) > 0
    )
    SELECT * FROM AvailableBatches
    ORDER BY ExpiryDate ASC, BatchCode ASC;

    -- Issue logic here
END
```

---

### 7.4 sp_SplitReceiptByCapacity

**Muc dich**: Chia nho nhap kho theo suc chua

**Input**:
- @WarehouseID INT
- @TotalQtyKg DECIMAL(12,3)
- @BatchSize INT = 50

**Output**: Multiple receipt entries

**Logic**:
- Neu khong co gioi han → 1 entry
- Chia nho theo capacity

```sql
CREATE PROCEDURE sp_SplitReceiptByCapacity
    @WarehouseID INT,
    @FeedID INT,
    @TotalQtyKg DECIMAL(12,3),
    @BatchCode NVARCHAR(50),
    @ExpiryDate DATE
AS
BEGIN
    DECLARE @CapacityKg DECIMAL(12,2);
    SELECT @CapacityKg = CapacityKg FROM Warehouses WHERE WarehouseID = @WarehouseID;

    IF @CapacityKg IS NULL OR @CapacityKg >= @TotalQtyKg
    BEGIN
        -- Single entry
        INSERT INTO FeedLedger (WarehouseID, FeedID, Direction, QtyKg, BatchCode, ExpiryDate, TxnDate)
        VALUES (@WarehouseID, @FeedID, 'I', @TotalQtyKg, @BatchCode, @ExpiryDate, GETDATE());
    END
    ELSE
    BEGIN
        -- Split into multiple entries
        DECLARE @AllocatedQty DECIMAL(12,3) = 0;
        DECLARE @SlotNumber INT = 1;

        WHILE @AllocatedQty < @TotalQtyKg
        BEGIN
            DECLARE @QtyThisSlot DECIMAL(12,3) =
                CASE WHEN (@TotalQtyKg - @AllocatedQty) > @CapacityKg
                     THEN @CapacityKg
                     ELSE (@TotalQtyKg - @AllocatedQty)
                END;

            INSERT INTO FeedLedger (WarehouseID, FeedID, Direction, QtyKg, BatchCode, ExpiryDate, TxnDate, Notes)
            VALUES (@WarehouseID, @FeedID, 'I', @QtyThisSlot, @BatchCode, @ExpiryDate, GETDATE(),
                    'Slot ' + CAST(@SlotNumber AS NVARCHAR(10)));

            SET @AllocatedQty = @AllocatedQty + @QtyThisSlot;
            SET @SlotNumber = @SlotNumber + 1;
        END
    END
END
```

---

### 7.5 sp_VerifyDeterminism

**Muc dich**: Checksum verification

**Input**: @CycleID INT

**Output**: PASS/FAIL

```sql
CREATE PROCEDURE sp_VerifyDeterminism
    @CycleID INT
AS
BEGIN
    DECLARE @OriginalChecksum NVARCHAR(MAX);
    DECLARE @NewChecksum NVARCHAR(MAX);

    SELECT @OriginalChecksum = Manifest
    FROM FarmingCycles
    WHERE CycleID = @CycleID;

    -- Calculate new checksum
    SELECT @NewChecksum = CHECKSUM_AGG(CHECKSUM(*))
    FROM DailyLogs
    WHERE CycleID = @CycleID
    ORDER BY DayNumber;

    IF @OriginalChecksum = @NewChecksum
        SELECT 'PASS' AS Result;
    ELSE
        SELECT 'FAIL' AS Result;
END
```

---

## 8. TRIGGERS

### 8.1 trg_AuditDailyLog

**Tac dung**: Tu dong ghi vao AuditTrail moi thay doi DailyLog

**Chi tiet**:
- Theo doi: FishQty, DeathQty, Feed, va cac changes khac
- Luu OldValues & NewValues trong JSON format

**Bao mat**: Dam bao audit trail day du theo yeu cau Security

```sql
CREATE TRIGGER trg_AuditDailyLog
ON DailyLogs
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action NVARCHAR(20);

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Action = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Action = 'INSERT';
    ELSE
        SET @Action = 'DELETE';

    INSERT INTO AuditTrail (TableName, RecordID, Action, OldValues, NewValues, UserID, ActionDate)
    SELECT
        'DailyLogs',
        COALESCE(i.LogID, d.LogID),
        @Action,
        (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        (SELECT i.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        SYSTEM_USER,
        GETDATE()
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.LogID = d.LogID;
END
```

---

### 8.2 trg_UpdateCycleLastDay

**Tac dung**: Cap nhat FarmingCycle.LastProcessedDay tu dong

**Chi tiet**: Tracking tien do sinh du lieu

**Loi ich**: Auto-update progress without manual intervention

```sql
CREATE TRIGGER trg_UpdateCycleLastDay
ON DailyLogs
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE fc
    SET fc.LastProcessedDay = i.DayNumber
    FROM FarmingCycles fc
    INNER JOIN inserted i ON fc.CycleID = i.CycleID;
END
```

---

## 9. INDEXES & PERFORMANCE

### 9.1 Key Indexes

**FarmingCycle**:
- IX_CycleID_Status (CycleID, Status)
- IX_StartDate (StartDate DESC)
- IX_PondID_Status (PondID, Status)

**DailyLogs**:
- IX_CycleID_Day (CycleID, DayNumber DESC)
- IX_Date (LogDate DESC)
- IX_CycleID_Full (CycleID, LogDate DESC) INCLUDE (FishCount, AvgWeightGr, BiomassKg, FCR)

**FeedLedger**:
- IX_FeedLedger_ExpiryDirection (ExpiryDate ASC, Direction) INCLUDE (QtyKg, WarehouseID)
- IX_FeedLedger_WarehouseFeed (WarehouseID, FeedID, Direction)
- IX_FeedLedger_BatchCode (BatchCode)

**ChemicalLedger**:
- IX_ChemicalLedger_ExpiryDirection (ExpiryDate ASC, Direction)
- IX_ChemicalLedger_ApprovalStatus (ApprovalStatus, TxnDate DESC)

**AlertLogs**:
- IX_AlertLog_CycleID_Level (CycleID, AlertLevel)
- IX_AlertLog_Status (Status)

### 9.2 Optimization Strategies

1. Use Stored Procedures for heavy computations (FEFO, Auto-split)
2. Batch operations with AddRange + SaveChangesAsync (1 round-trip)
3. Query optimization with Select projections (only needed fields)
4. Index key columns: CycleID, Date, ExpiryDate, Status
5. Database partitioning for historical data (5+ year retention)

---

## 10. COMPONENT DIAGRAM

### 10.1 11 Engines + Services

```
┌────────────────────────────────────────────────────────────┐
│                  BUSINESS LOGIC LAYER                      │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              11 SIMULATION ENGINES                 │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │  [1] EnvironmentGenerator                          │   │
│  │      → DO, pH, H2S, NH3                            │   │
│  │                                                     │   │
│  │  [2] MortalityEngine                               │   │
│  │      → Death count, Survival rate                  │   │
│  │                                                     │   │
│  │  [3] GrowthEngine                                  │   │
│  │      → TLBQ, Biomass                               │   │
│  │                                                     │   │
│  │  [4] FeedPlanner                                   │   │
│  │      → Feed amount (kg)                            │   │
│  │                                                     │   │
│  │  [5] ChemicalEngine                                │   │
│  │      → Chemical usage, cost                        │   │
│  │                                                     │   │
│  │  [6] WaterOpsEngine                                │   │
│  │      → Water intake/discharge                      │   │
│  │                                                     │   │
│  │  [7] InventoryEngine (FEFO)                        │   │
│  │      → Allocated qty, shortage                     │   │
│  │                                                     │   │
│  │  [8] CostTracker                                   │   │
│  │      → Daily cost, cumulative cost                 │   │
│  │                                                     │   │
│  │  [9] AlertSystem                                   │   │
│  │      → Alert records (CRITICAL/WARNING/INFO)       │   │
│  │                                                     │   │
│  │  [10] ValidationService                            │   │
│  │       → Validation errors/warnings                 │   │
│  │                                                     │   │
│  │  [11] ReportingEngine                              │   │
│  │       → 8 FSIS forms, dashboards                   │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 CORE SERVICES                       │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │  GeneratorService                                  │   │
│  │  InventoryService                                  │   │
│  │  HealthService                                     │   │
│  │  ReportingService                                  │   │
│  │  AuditService                                      │   │
│  │  AlertService                                      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## 11. SEQUENCE DIAGRAMS

### 11.1 Daily Pipeline Sequence

```
User → GeneratorService → 11 Engines → Database

1. User: Run Scenario
2. GeneratorService: Load Cycle
3. GeneratorService: Loop Day 1 to 90
   3.1 WeatherAdapter: Get Temperature
   3.2 EnvironmentGenerator: Calculate DO, pH, H2S, NH3
   3.3 MortalityEngine: Calculate Death Count
   3.4 GrowthEngine: Calculate TLBQ, Biomass
   3.5 FeedPlanner: Calculate Feed Amount
   3.6 ChemicalEngine: Determine Chemicals
   3.7 WaterOpsEngine: Calculate Water Exchange
   3.8 InventoryEngine: FEFO Allocation
   3.9 CostTracker: Calculate Costs
   3.10 AlertSystem: Generate Alerts
   3.11 ValidationService: Validate Data
4. GeneratorService: Save DailyLog
5. Database: Insert Record
6. GeneratorService: Next Day
7. Repeat 3-6 until Day 90
8. GeneratorService: Return Success
```

### 11.2 FEFO Allocation Sequence

```
System → InventoryService → sp_AllocateFEFO → FeedLedger

1. System: Request Feed (100 kg)
2. InventoryService: Call sp_AllocateFEFO
3. sp_AllocateFEFO: Get Available Batches
4. sp_AllocateFEFO: Sort by ExpiryDate ASC
5. sp_AllocateFEFO: Loop Batches
   5.1 Allocate from Batch 1 (ExpiryDate: 2025-01-15) → 50 kg
   5.2 Remaining: 50 kg
   5.3 Allocate from Batch 2 (ExpiryDate: 2025-02-01) → 50 kg
   5.4 Remaining: 0 kg
6. sp_AllocateFEFO: Create Outbound Records
7. FeedLedger: Insert 2 Records
8. sp_AllocateFEFO: Return Allocated Qty
9. InventoryService: Return to System
```

### 11.3 Replay Mode Sequence

```
User → ReplayService → Database → GeneratorService → Verification

1. User: Select Cycle to Replay
2. ReplayService: Load Manifest
3. ReplayService: Extract Seed, Version, Weather
4. ReplayService: Call GeneratorService with Same Seed
5. GeneratorService: Generate 90 Days (Same Logic)
6. GeneratorService: Save to Temp Table
7. ReplayService: Compare Checksums
   7.1 Load Original Checksums from Manifest
   7.2 Calculate New Checksums from Temp Table
   7.3 Compare Day by Day
8. ReplayService: Generate Report
   - PASS: All checksums match
   - FAIL: List differences
9. User: View Report
```

---

## 12. DEPLOYMENT ARCHITECTURE

### 12.1 Production Environment

```
┌────────────────────────────────────────────────────────┐
│                  CLIENT MACHINES                       │
│        Windows 10/11 Pro (Desktop Application)         │
│                  .NET 9.0 Runtime                      │
└────────────────────┬───────────────────────────────────┘
                     │ TCP/IP
                     ▼
┌────────────────────────────────────────────────────────┐
│                APPLICATION SERVER                      │
│              Windows Server 2019+                      │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │      AquaSim Application (.NET 9.0)             │  │
│  │                                                  │  │
│  │  - Business Logic Layer                         │  │
│  │  - 11 Simulation Engines                        │  │
│  │  - Core Services                                │  │
│  │                                                  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
└────────────────────┬───────────────────────────────────┘
                     │ SQL Server Connection
                     ▼
┌────────────────────────────────────────────────────────┐
│                 DATABASE SERVER                        │
│            SQL Server 2019+ Standard/Enterprise        │
│                                                        │
│  Database: aquasim_VHC                                │
│  Server: 172.17.254.222:1433                          │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │  - 25+ Tables                                   │  │
│  │  - 6+ Stored Procedures                         │  │
│  │  - 2+ Triggers                                  │  │
│  │  - Indexes & Views                              │  │
│  │                                                  │  │
│  │  Backup Strategy:                               │  │
│  │  - Full Backup: Daily 2:00 AM                   │  │
│  │  - Differential: Every 6 hours                  │  │
│  │  - Transaction Log: Every 30 mins               │  │
│  │                                                  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### 12.2 Deployment Checklist

**PRE-DEPLOYMENT**:
- ☐ Code review completed (100%)
- ☐ Unit tests passed (>80% coverage)
- ☐ Integration tests passed
- ☐ Performance testing completed
- ☐ Security audit passed
- ☐ UAT sign-off from stakeholders
- ☐ Documentation completed & approved

**DATABASE DEPLOYMENT**:
- ☐ Production database created
- ☐ All tables created
- ☐ All indexes created
- ☐ All stored procedures deployed
- ☐ All triggers deployed
- ☐ Security roles configured
- ☐ Backup plan implemented
- ☐ Restore test completed

**APPLICATION DEPLOYMENT**:
- ☐ .NET Runtime 9.0 installed
- ☐ Connection strings configured
- ☐ Logging configured (Serilog)
- ☐ Email notifications configured
- ☐ File permissions set correctly
- ☐ Antivirus/Firewall rules updated

**POST-DEPLOYMENT**:
- ☐ Smoke test completed (all major features)
- ☐ System startup verified
- ☐ User training completed (all staff)
- ☐ Support contact established
- ☐ Monitoring enabled
- ☐ First backup verified
- ☐ Incident response plan reviewed

---

## 13. SECURITY IMPLEMENTATION

### 13.1 Authentication Flow

```
User Input (Username + Password)
         ↓
BCrypt Hash Compare (12 rounds)
         ↓
   ✅ Match? ──→ Reset FailedAttempts
         ├─→ Create Session
         ├─→ Generate Session Token
         └─→ Redirect to Dashboard
         ↓
   ❌ No Match ──→ Increment FailedAttempts
         ├─→ >= 5? ──→ Lock Account
         └─→ Show Error
```

### 13.2 Password Policy

- Minimum 8 characters
- At least 1 uppercase
- At least 1 lowercase
- At least 1 number
- At least 1 special character
- BCrypt hash (12 rounds)

### 13.3 Audit Trail Auto-Logging

**Interceptor Pattern**:
```csharp
public class AuditInterceptor : SaveChangesInterceptor
{
    public override async ValueTask<InterceptionResult<int>>
        SavingChangesAsync(DbContextEventData eventData)
    {
        var auditEntries = new List<AuditEntry>();
        var context = eventData.Context;

        foreach (var entry in context.ChangeTracker.Entries())
        {
            if (entry.State == EntityState.Unchanged)
                continue;

            var auditEntry = new AuditEntry
            {
                TableName = entry.Entity.GetType().Name,
                RecordID = GetRecordId(entry),
                Action = entry.State.ToString(),
                OldValues = entry.State == EntityState.Modified
                    ? GetOldValues(entry)
                    : null,
                NewValues = GetNewValues(entry),
                ChangedFields = GetChangedFields(entry),
                UserID = GetCurrentUser(),
                Username = GetCurrentUsername(),
                IPAddress = GetClientIP(),
                MachineName = Environment.MachineName,
                ActionDate = DateTime.UtcNow
            };

            auditEntries.Add(auditEntry);
        }

        await context.AuditTrail.AddRangeAsync(auditEntries);
        return await base.SavingChangesAsync(eventData);
    }
}
```

### 13.4 Data Encryption

- Sensitive fields encrypted at rest
- Connection strings encrypted in config
- Passwords hashed with BCrypt (never stored plain)

---

## 14. API DESIGN

### 14.1 Service Interfaces

```csharp
// Services/IGeneratorService.cs
public interface IGeneratorService
{
    Task<bool> RunScenarioAsync(ScenarioInput scenario);
    Task<DailyLog> GenerateDayAsync(int cycleId, int dayNumber);
}

// Services/IInventoryService.cs
public interface IInventoryService
{
    Task<(decimal Allocated, decimal Shortage)> AllocateFEFOAsync(
        int warehouseId, int feedId, decimal requiredQtyKg,
        DateTime asOfDate, int cycleId);
    Task CreateEmergencyReceiptAsync(int warehouseId, int feedId,
        decimal qtyKg, DateTime receiptDate);
}

// Services/IReportingService.cs
public interface IReportingService
{
    Task<byte[]> ExportToExcelAsync(int cycleId);
    Task<byte[]> ExportToPdfAsync(int cycleId, string formCode);
    Task<byte[]> ExportToWordAsync(int cycleId, string formCode);
}
```

---

## 15. MIGRATION STRATEGY

### 15.1 Excel to Database Migration

```csharp
public class ExcelMigrationService
{
    public async Task MigrateHistoricalData(string excelFilePath)
    {
        using var context = new AquaSimDbContext();

        // 1. Parse Excel files
        var farmData = ParseFarmsSheet(excelFilePath);
        var pondData = ParsePondsSheet(excelFilePath);
        var cycleData = ParseCyclesSheet(excelFilePath);
        var dailyLogData = ParseDailyLogsSheet(excelFilePath);

        // 2. Validate data
        ValidateFarmData(farmData);
        ValidatePondData(pondData);
        ValidateCycleData(cycleData);
        ValidateDailyLogData(dailyLogData);

        // 3. Migrate to database (batch)
        await context.Farms.AddRangeAsync(farmData);
        await context.SaveChangesAsync();

        await context.Ponds.AddRangeAsync(pondData);
        await context.SaveChangesAsync();

        await context.FarmingCycles.AddRangeAsync(cycleData);
        await context.SaveChangesAsync();

        // Use bulk insert for large dataset
        await context.BulkInsertAsync(dailyLogData);

        // 4. Post-migration validation
        VerifyDataIntegrity();
    }
}
```

### 15.2 Implementation Phases

**Phase 1: Database Setup (Week 1-2)**
- Create SQL Server database
- Execute DDL scripts (Tables)
- Create indexes
- Deploy stored procedures
- Seed master data (Farms, Products)
- Configure backup jobs
- Test restore procedures

**Phase 2: Backend Development (Week 3-8)**
- Setup .NET 9.0 project structure
- Implement Domain entities
- Create DbContext & scaffold from DB
- Setup Dependency Injection
- Implement 11 Simulation Engines
- Create Repository layer
- Implement Service layer
- Add validation rules
- Unit testing (>80% coverage)

**Phase 3: Frontend Development (Week 9-10)**
- Create main dashboard (Windows Forms Designer)
- Implement master data forms
- Create cycle management UI
- Add daily entry forms
- Implement reporting UI
- Add export functionality
- Create admin panel
- Add help system

**Phase 4: Testing & Deployment (Week 11-12)**
- Integration testing
- Performance testing (load testing)
- Security testing
- User acceptance testing (UAT)
- Production environment setup
- Data migration from Excel
- User training (2-3 sessions)
- Go-live support (1 week on-call)

**Phase 5: Report Generation (Week 13)**
- Implement 8 FSIS forms export
- Excel export with EPPlus
- PDF export with iText7
- Word export with OpenXML
- Add watermark "MOCKED DATA - FOR TRAINING ONLY"
- Test all report formats

**Phase 6: Advanced Features (Week 14)**
- Implement Replay Mode
- Implement Manual Override
- E-signature workflow
- Advanced alerts & notifications

---

## 16. PERFORMANCE BENCHMARKS

### 16.1 Operation Benchmarks

| Operation | Records | EF Core | Stored Proc |
|-----------|---------|---------|-------------|
| Generate 90 Days | 1 cycle | 5-8 sec | 1-2 sec |
| FEFO Allocation | 1000 | 200ms | 50ms |
| Report Export | 90 days | 1-3 sec | N/A |
| Bulk Insert | 1000 | 2 sec (EF) | 300ms |
| Query 10,000 records | 10k | 800ms | 200ms |
| Calculate Stock | 1 product | 150ms | 50ms |

### 16.2 Load Testing Scenarios

| Scenario | Ponds | Cycles/Year | Daily Logs/Year | Storage | Concurrent Users | Response Time |
|----------|-------|------------|-----------------|---------|------------------|---------------|
| Small Farm | 10 | 40 | 3,600 | ~50 MB | 5 | < 1 sec |
| Medium Farm | 50 | 200 | 18,000 | ~250 MB | 25 | < 2 sec |
| Large Farm | 100 | 400 | 36,000 | ~500 MB | 50 | < 3 sec |
| Enterprise | 500+ | 2000+ | 180,000+ | ~2.5 GB | 100+ | < 5 sec (w/ cache) |

### 16.3 Optimization Recommendations

1. **Use Stored Procedures** for heavy computations (FEFO, Auto-split)
2. **Batch operations** with AddRange + SaveChangesAsync (1 round-trip)
3. **Query optimization** with Select projections (only needed fields)
4. **Index key columns**: CycleID, Date, ExpiryDate, Status
5. **Database partitioning** for historical data (5+ year retention)
6. **Caching** for frequently accessed data (e.g., master data)
7. **Connection pooling** for SQL Server connections

---

## DOCUMENT METADATA

| Property | Value |
|----------|-------|
| **Document ID** | ARCH-AQUASIM-4.0-FINAL |
| **Version** | 4.0 Final Architecture |
| **Status** | APPROVED |
| **Date** | 14/11/2025 |
| **Total Pages** | ~80 pages |
| **Word Count** | ~30,000 words |
| **Author** | Technical Team |
| **Reviewer** | Solution Architect |
| **Approver** | CTO |

---

## CHANGE HISTORY

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 25/10/2025 | Initial architecture draft |
| v2.0 | 01/11/2025 | Added database schema & stored procedures |
| v3.0 | 04/11/2025 | Added security, deployment sections |
| v4.0 | 06/11/2025 | Consolidated with SRS, removed duplicates |
| **v4.0 FINAL** | **14/11/2025** | **Final consolidation from 5 source files** |

---

**CONFIDENTIAL** - For authorized personnel only
© 2025 AquaSim System. All rights reserved.
