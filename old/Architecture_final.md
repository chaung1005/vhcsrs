# 📐 KIẾN TRÚC & THIẾT KẾ HỆ THỐNG AQUASIM (FINAL)
## Hệ thống Quản lý Trang trại Nuôi Thủy sản Tự động

**Ngày tạo**: 06/11/2025  
**Phiên bản**: Final 4.0 (Consolidated & Complete)  
**Trạng thái**: ✅ APPROVED  
**Tác giả**: Technical Team

---

## 📋 MỤC LỤC

1. [Tổng quan Điều hành (Executive Summary)](#1-tổng-quan-điều-hành)
2. [Giới thiệu AquaSim](#2-giới-thiệu-aquasim)
3. [Kiến trúc Hệ thống](#3-kiến-trúc-hệ-thống)
4. [Thiết kế Lược đồ CSDL](#4-thiết-kế-lược-đồ-csdl)
5. [Yêu cầu Chức năng (Functional)](#5-yêu-cầu-chức-năng)
6. [Yêu cầu Phi Chức năng (Non-Functional)](#6-yêu-cầu-phi-chức-năng)
7. [Thành phần (Components) & Services](#7-thành-phần--services)
8. [Công thức Tính toán & Thuật toán](#8-công-thức-tính-toán--thuật-toán)
9. [Quy trình Nghiệp vụ](#9-quy-trình-nghiệp-vụ)
10. [Giao diện & Báo cáo](#10-giao-diện--báo-cáo)
11. [Security, Audit & Alerts](#11-security-audit--alerts)
12. [Testing & Performance](#12-testing--performance)
13. [Triển khai & Migration](#13-triển-khai--migration)
14. [Phụ lục](#14-phụ-lục)

---

## 1. TỔNG QUAN ĐIỀU HÀNH

### 1.1 Vấn đề Hiện tại

- ✗ Excel tả các quy trình → Không đồng bộ, dễ lỗi
- ✗ Theo dõi thủ công → Tốn thời gian, sai sót
- ✗ Báo cáo không chuẩn → Không đạt tiêu chuẩn FSIS

### 1.2 Giải pháp AquaSim

- ✅ **Tự động hóa 100%** chu kỳ nuôi (90 ngày)
- ✅ **Sinh dữ liệu thông minh** từ 1 form input
- ✅ **Quản lý FEFO** kho thức ăn & hóa chất
- ✅ **Xuất chuẩn FSIS** 8 biểu mẫu
- ✅ **Deterministic simulation** (cùng seed = cùng kết quả)
- ✅ **Replay mode** để xác minh tính nhất quán

### 1.3 KPIs Chính

| Chỉ số | Target | Hiện tại | Cải thiện |
|--------|--------|---------|----------|
| Ngày input | 90 ngày | 1 day | **99%** |
| FCR (Feed Conversion) | < 2.0 | 2.3 | **13%** |
| Survival Rate | > 85% | 82% | **3%** |
| Báo cáo chuẩn | 8/8 | 2/8 | **300%** |
| Compliance | 100% | 60% | **67%** |

---

## 2. GIỚI THIỆU AQUASIM

### 2.1 Định Nghĩa & Phạm Vi

**AquaSim** là hệ thống quản lý trang trại nuôi thủy sản toàn diện, được thiết kế để:

| Mục tiêu | Chi tiết |
|----------|----------|
| **Tự động hóa** | Quy trình sinh dữ liệu toàn chu kỳ 90 ngày |
| **Thay thế Excel** | Các quy trình theo dõi thủ công |
| **Chuẩn hóa báo cáo** | Theo tiêu chuẩn FSIS (8 form) |
| **Hỗ trợ** | Mô phỏng và dự báo cho mục đích đào tạo |
| **Deterministic** | Cùng seed → cùng kết quả (reproducible) |

### 2.2 Phạm Vi Toàn Diện

**Master Data Management (MDM)**
- Farms, Ponds, Warehouses
- FeedInventory, ChemicalInventory
- Users & Permissions

**Operational Management (Ops)**
- Fish Stocking (Thả giống)
- Farming Cycles (90 ngày)
- Daily Logs & Health Monitoring
- Water Quality Management
- Waste Management

**Inventory Management**
- Receipt (Nhập kho) with auto-split by capacity
- Issue (Xuất kho) with FEFO algorithm
- Real-time stock tracking
- Expiry date alerts

**Auto-Generation & Simulation**
- 11 Simulation Engines
- Daily Pipeline (10 steps)
- Deterministic output
- Manifest & Checksum verification

**Reporting & Analytics**
- Standard Reports
- 8 FSIS Forms (P301/P303/P305 series)
- Export to Excel/PDF/Word
- Dashboard & Alerts

### 2.3 Thuật ngữ & Định Nghĩa

| Thuật ngữ | Tiếng Việt | Giải thích |
|-----------|-----------|-----------|
| **Farm** | Vùng nuôi/Trang trại | Khu vực địa lý chứa nhiều ao |
| **Pond** | Ao | Đơn vị nuôi riêng lẻ |
| **Cycle** | Vụ nuôi | Từ thả giống đến thu hoạch (90 ngày) |
| **Fingerling** | Giống | Cá/tôm giống để thả nuôi |
| **TLBQ** | Trọng lượng bình quân | Average weight (g/con) |
| **Biomass** | Sinh khối | Tổng khối lượng cá/tôm (kg) |
| **FCR** | Hệ số chuyển đổi thức ăn | Feed Conversion Ratio |
| **DO** | Oxy hòa tan | Dissolved Oxygen (mg/L) |
| **FEFO** | First-Expired, First-Out | Xuất theo HSD sớm nhất |
| **MSL/Batch Code** | Mã số lô | Mã theo dõi lô sản xuất |
| **HSD** | Hạn sử dụng | Expiry Date |
| **ASC/BAP** | Chứng nhận | Aquaculture Stewardship Council / Best Aquaculture Practices |

---

## 3. KIẾN TRÚC HỆ THỐNG

### 📌 CRITICAL ARCHITECTURE DECISIONS

#### A. DATABASE-FIRST APPROACH (Bắt buộc)

**Định nghĩa**: Database schema là source of truth, models được scaffold từ database.

**Các nguyên tắc**:
1. ✅ SQL Server database được tạo và cấu hình trước
2. ✅ Models được sinh từ database bằng EF Core Scaffolding
3. ✅ Không được tạo database từ migrations (Code-First)
4. ✅ Models phải match 100% với schema thực tế
5. ✅ Thay đổi schema → Update database → Migrations sau
6. ✅ Hiện dự án đang kết nối cơ sở dữ liệu vận hành `aquasim_VHC` (SQL Server 2019+) và toàn bộ model/service phải được sync lại từ DB này.

**Quy trình regenerate model (khi schema thay đổi)**
1. Cập nhật trực tiếp schema trên SQL Server `aquasim_VHC` (DDL/stored procedure/view).
2. Tại thư mục `AquaSim.Models`, chạy scaffold EF Core ví dụ:
   ```powershell
   dotnet ef dbcontext scaffold "Server=tcp:172.17.254.222,1433;Database=aquasim_VHC;User Id=mhkpi;Password=Try@VhcQAZXCV;Encrypt=false;TrustServerCertificate=true;" Microsoft.EntityFrameworkCore.SqlServer \
       --context AquaSimDbContext \
       --output-dir . \
       --force \
       --no-pluralize
   ```
3. Soát lại các file được cập nhật, đảm bảo không ghi đè tuỳ biến ngoài Models/.
4. Build giải pháp, chạy smoke test trước khi commit.

**Lợi ích**:
- Single source of truth (database)
- Dễ maintain khi database tồn tại trước
- Tránh model-database mismatch
- Support stored procedures tốt hơn

#### B. WINDOWS FORMS DESIGNER (Bắt buộc)

**Định nghĩa**: Tất cả giao diện được tạo qua Visual Studio Designer, không hard-code UI.

**Các nguyên tắc**:
1. ✅ Mỗi form có 3 file: .cs (logic), .Designer.cs (UI), .resx (resources)
2. ✅ Chỉ sửa UI qua Designer, không sửa Designer.cs code
3. ✅ Tất cả event hook qua Properties panel → Events
4. ✅ Controls được đặt tên theo convention (txt, btn, lbl, cmb, etc.)

**Lợi ích**:
- Giao diện dễ thay đổi, maintain
- Kỹ sư code và designer tách rời
- Alignment, sizing tự động
- Form inheritance support

---

### 3.1 Mô Hình Phân Lớp (3-Tier Architecture)

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                           │
│    Windows Forms (.NET 9.0) - MUST USE DESIGNER               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Main Dashboard, Forms, Reports, Settings                │   │
│  │ ⚠️  REQUIREMENT: ALL UI must be created with           │   │
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
│  │ ➤ GeneratorService (Điều phối pipeline)                │   │
│  │ ➤ InventoryService (FEFO logic)                        │   │
│  │ ➤ HealthService (Sức khỏe cá)                          │   │
│  │ ➤ ReportingService (Xuất báo cáo)                      │   │
│  │ ➤ AuditService (Ghi chép thay đổi)                     │   │
│  │ ➤ AlertService (Phát sinh cảnh báo)                    │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │ Via Repository Pattern
┌──────────────────────────▼──────────────────────────────────────┐
│                   DATA ACCESS LAYER (DAL)                       │
│          Entity Framework Core 9.0 + Stored Procedures          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Generic Repository<T> + Specific Repositories            │   │
│  │ - IRepository<T> (CRUD chung)                           │   │
│  │ - IDailyLogRepository (Query riêng)                     │   │
│  │ - IFeedLedgerRepository (FEFO queries)                  │   │
│  │ - IAuditRepository (Audit trail)                        │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Stored Procedures (Hiệu năng cao)                       │   │
│  │ - sp_GenerateDailyLogs (Pipeline chính)                 │   │
│  │ - sp_AllocateFEFO (Xuất kho FEFO)                       │   │
│  │ - sp_SplitReceiptByCapacity (Chia nhỏ nhập kho)         │   │
│  │ - sp_CalculateCycleStats (Thống kê)                     │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                    SQL SERVER 2019+                             │
│                    📌 DATABASE-FIRST APPROACH                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ ✅ Bắt buộc: Database tồn tại trước khi tạo models      │   │
│  │ ✅ Bắt buộc: Dùng EF Core migrations sau khi model      │   │
│  │ ✅ Bắt buộc: Stored Procedures cho hiệu năng cao       │   │
│  │ ✅ Bắt buộc: Models phải match với schema thực tế       │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### 3.1.1 Database-First Implementation Requirements

**📌 BẮTBUỘC: Phải tuân thủ Database-First Approach**

1. **Database Schema Prioritized**
   - ✅ SQL Server database được tạo trước
   - ✅ Tables, columns, constraints, indexes định nghĩa rõ
   - ✅ Models C# phải match 100% với schema

2. **Entity Framework Core - Database First**
   ```bash
   # Scaffold từ database hiện tại
   dotnet ef dbcontext scaffold \
     "Server=172.17.254.222;Database=aquasim_VHC;..." \
     Microsoft.EntityFrameworkCore.SqlServer \
     -o Models
   ```

3. **Migrations cho thay đổi**
   - Thay đổi schema → Update database trước
   - Sau đó: `dotnet ef migrations add MigrationName`
   - Không được thay đổi model rồi update database

4. **Column Mapping**
   - `.ToTable("ExactTableName")` bắt buộc
   - `.HasColumnName("ExactColumnName")` khi khác
   - Tất cả Property phải map chính xác

5. **Model Cleanup**
   - Xóa properties không có trong database
   - Xóa navigation properties không cần thiết
   - Keep only what's actually used

### 3.2 Tech Stack Đầy Đủ

| Component | Technology | Version | Mục đích |
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

### 3.3 Design Patterns

#### Backend Patterns
- **Repository Pattern**: Clean Architecture + Adapter
- **Dependency Injection**: IoC Container
- **Unit of Work**: Transaction Management
- **Factory Pattern**: Object Creation
- **Strategy Pattern**: Algorithm Selection (11 engines)
- **Observer Pattern**: Event & Alert Handling
- **Interceptor Pattern**: Audit Trail auto-logging
- **Template Method**: Daily Pipeline orchestration

#### Frontend Patterns - 📌 WINDOWS FORMS DESIGNER REQUIREMENT

**BẮTBUỘC: Tất cả giao diện phải sử dụng Windows Forms Designer**

1. **3-File Structure (Bắt buộc)**
   ```
   MyForm.cs              ← User code (logic, events)
   MyForm.Designer.cs     ← Designer-generated (UI layout)
   MyForm.resx            ← Resources (images, strings, etc.)
   ```

2. **Designer Files - KHÔNG được sửa tay**
   - ✅ Auto-generated bởi Visual Studio Designer
   - ✅ Chỉ sửa qua Designer UI, không sửa code trực tiếp
   - ❌ KHÔNG được thay đổi `InitializeComponent()` manually
   - ❌ KHÔNG được thay đổi control properties trong code
   - ⚠️  Nếu sửa code → Designer sẽ bị hỏng

3. **User Code File - Có thể sửa**
   - ✅ Button click handlers: `btnSave_Click()`
   - ✅ Business logic: `LoadData()`, `ValidateInput()`
   - ✅ Event subscriptions: `cmbWarehouse.SelectedIndexChanged += ...`
   - ❌ Không được tạo controls thủ công
   - ❌ Không được gọi `InitializeComponent()` từ constructor

4. **Control Naming Convention**
   ```csharp
   // Prefix theo kiểu Windows Forms
   txt{ControlName}      // TextBox: txtFarmCode
   lbl{ControlName}      // Label: lblFarmName
   btn{ActionName}       // Button: btnSave, btnDelete
   cmb{ListName}         // ComboBox: cmbWarehouse
   dgv{ListName}         // DataGridView: dgvFarms
   chk{OptionName}       // CheckBox: chkIsActive
   pnl{SectionName}      // Panel: pnlHeader
   ```

5. **Anchor & Dock Properties**
   - ✅ Sử dụng Anchor để fixed position
   - ✅ Sử dụng Dock để fill/stretch
   - ✅ Set thông qua Designer property panel
   - ❌ KHÔNG set thủ công trong code

6. **Form Inheritance (Nếu cần theme chung)**
   ```csharp
   public class BaseForm : Form
   {
       // Common styling, buttons, etc.
       // Các form khác kế thừa từ BaseForm
   }
   
   public class ManageFarmsForm : BaseForm
   {
       // Kế thừa theme, colors, fonts từ BaseForm
   }
   ```

7. **Event Wiring - Qua Designer**
   - ✅ Double-click control tạo event handler
   - ✅ Properties panel → Events tab để hook event
   - ❌ KHÔNG ghi `+= handler` trong Designer.cs
   - Tất cả event subscription nên qua Designer UI

---

## 4. THIẾT KẾ LƯỢC ĐỒ CSDL

### 4.1 Entity Relationship Diagram (ERD) - Consolidated

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
│   ├── (1) ──────────────────< (N) MortalityEvents
│   ├── (1) ──────────────────< (N) GrowthLogs
│   ├── (1) ──────────────────< (N) CostLogs
│   ├── (1) ──────────────────< (N) AlertLogs
│   └── (1) ──────────────────< (N) StatusChanges

INVENTORY ENTITIES:
├── Warehouses (1) ──────────────────< (N) FeedLedger
│   └── (1) ──────────────────< (N) FeedInventory
│
├── Warehouses (1) ──────────────────< (N) ChemicalLedger
│   └── (1) ──────────────────< (N) ChemicalInventory

WORKFLOW & AUDIT:
├── Users (1) ──────────────────< (N) AuditTrail
├── Users (1) ──────────────────< (N) UserResponsibilities
├── Users (1) ──────────────────< (N) Approvals
└── Cycles (1) ──────────────────< (N) ProductSpecifications
```

### 4.2 Bảng Dữ Liệu Chính (Master & Operational)

#### GROUP 1: MASTER DATA

```sql
/* Farms */
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
    ASC BIT DEFAULT 0,           /* ASC Certification */
    BAP BIT DEFAULT 0,            /* BAP Certification */
    GG BIT DEFAULT 0,             /* GAA Certification */
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmCode (FarmCode),
    INDEX IX_Province (Province)
);

/* Warehouses */
CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseCode NVARCHAR(50) UNIQUE NOT NULL,
    WarehouseName NVARCHAR(100) NOT NULL,
    FarmID INT FOREIGN KEY REFERENCES Farms(FarmID),
    Location NVARCHAR(200),
    CapacityKg DECIMAL(12,2) NULL,  /* Sức chứa tối đa */
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmID (FarmID)
);

/* Ponds */
CREATE TABLE Ponds (
    PondID INT PRIMARY KEY IDENTITY(1,1),
    PondCode NVARCHAR(50) UNIQUE NOT NULL,
    PondName NVARCHAR(100) NOT NULL,
    FarmID INT FOREIGN KEY REFERENCES Farms(FarmID),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    SurfaceAreaM2 DECIMAL(10,2),    /* Diện tích (m²) */
    DepthM DECIMAL(5,2),             /* Độ sâu (m) */
    CapacityKg DECIMAL(12,2),        /* Dung tích (kg) */
    MaxIntakeWaterM3 DECIMAL(10,2),
    MaxDischargeWaterM3 DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmID (FarmID),
    INDEX IX_PondCode (PondCode)
);

/* FeedInventory */
CREATE TABLE FeedInventory (
    FeedID INT PRIMARY KEY IDENTITY(1,1),
    FeedCode NVARCHAR(50) UNIQUE NOT NULL,
    FeedName NVARCHAR(100) NOT NULL,
    ProteinPercent DECIMAL(5,2),
    FatPercent DECIMAL(5,2),
    FiberPercent DECIMAL(5,2),
    ParticleSizeMm DECIMAL(5,2),
    SizeBand NVARCHAR(50),           /* Small, Medium, Large */
    Supplier NVARCHAR(100),
    Price DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_FeedCode (FeedCode)
);

/* ChemicalInventory */
CREATE TABLE ChemicalInventory (
    ChemicalID INT PRIMARY KEY IDENTITY(1,1),
    ChemicalCode NVARCHAR(50) UNIQUE NOT NULL,
    ChemicalName NVARCHAR(100) NOT NULL,
    ChemicalType NVARCHAR(50),       /* PROBIOTIC, VITAMIN, ANTIBIOTIC, pH_ADJUSTER, SALT */
    Purpose NVARCHAR(200),
    DosageUnit NVARCHAR(50),         /* mg/L, kg, etc. */
    Supplier NVARCHAR(100),
    Price DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_ChemicalCode (ChemicalCode)
);

/* EnvRules - Tham số môi trường theo tháng */
CREATE TABLE EnvRules (
    RuleID INT PRIMARY KEY IDENTITY(1,1),
    MonthNo INT,                      /* 1=Jan, 12=Dec */
    BaseTempC DECIMAL(5,2),           /* Nhiệt độ cơ bản theo tháng */
    OptimalDOmg DECIMAL(5,2),
    OptimalPH DECIMAL(4,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_Month (MonthNo)
);

/* Users */
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100),
    PasswordHash NVARCHAR(MAX) NOT NULL,  /* bcrypt hoặc PBKDF2 */
    Role NVARCHAR(50),                    /* Admin, Manager, Staff, Viewer */
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME NULL,
    INDEX IX_Username (Username),
    INDEX IX_Role (Role)
);

/* Calendar */
CREATE TABLE Calendar (
    CalDate DATE PRIMARY KEY,
    IsHoliday BIT NOT NULL DEFAULT 0,
    Description NVARCHAR(200) NULL,
    INDEX IX_IsHoliday (IsHoliday)
);
```

#### GROUP 2: FARMING CYCLE & DAILY OPERATIONS

```sql
/* FarmingCycles */
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
    Manifest NVARCHAR(MAX) NULL,        /* JSON: seed, version, checksums */
    
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_CycleID_Status (CycleID, Status),
    INDEX IX_StartDate (StartDate DESC),
    INDEX IX_PondID_Status (PondID, Status)
);

/* DailyLogs */
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

/* EnvironmentLogs */
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

/* HealthMonitoring */
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

/* WaterManagement */
CREATE TABLE WaterManagement (
    WaterID INT PRIMARY KEY IDENTITY(1,1),
    PondID INT NOT NULL REFERENCES Ponds(PondID),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    InspectionDate DATE NOT NULL,
    IntakeVolumeM3 DECIMAL(12,2),     /* Lượng nước cấp (m³) */
    OutletVolumeM3 DECIMAL(12,2),     /* Lượng nước xả (m³) */
    DOmg DECIMAL(5,2),
    pH DECIMAL(4,2),
    Smell NVARCHAR(50),               /* No, Slight, Strong */
    Conclusion NVARCHAR(50),          /* Pass, Fail */
    Notes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_WaterManagement_PondDate (PondID, InspectionDate DESC)
);

/* WasteManagement */
CREATE TABLE WasteManagement (
    WasteID INT PRIMARY KEY IDENTITY(1,1),
    PondID INT REFERENCES Ponds(PondID),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    WasteDate DATE NOT NULL,
    WasteType NVARCHAR(50),           /* Dead_Fish, Feed_Bag, Chemical_Bag, Other */
    QuantityKg DECIMAL(12,2),
    Disposal NVARCHAR(100),           /* Burial, Incineration, Compost, Other */
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

#### GROUP 3: INVENTORY LEDGERS

```sql
/* FeedLedger */
CREATE TABLE FeedLedger (
    LedgerID BIGINT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL REFERENCES Warehouses(WarehouseID),
    FeedID INT NOT NULL REFERENCES FeedInventory(FeedID),
    TxnDate DATE NOT NULL,
    Direction CHAR(1) NOT NULL,       /* I = Nhập, O = Xuất */
    QtyKg DECIMAL(12,3) NOT NULL,
    BatchCode NVARCHAR(50),           /* Lô hàng */
    ExpiryDate DATE,                  /* Hạn sử dụng */
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

/* ChemicalLedger */
CREATE TABLE ChemicalLedger (
    LedgerID BIGINT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL REFERENCES Warehouses(WarehouseID),
    ChemicalID INT NOT NULL REFERENCES ChemicalInventory(ChemicalID),
    TxnDate DATE NOT NULL,
    Direction CHAR(1) NOT NULL,       /* I = Nhập, O = Xuất */
    Qty DECIMAL(12,3) NOT NULL,
    BatchCode NVARCHAR(50),
    ExpiryDate DATE,
    CycleID INT REFERENCES FarmingCycles(CycleID),
    ApprovalStatus NVARCHAR(20) DEFAULT 'Pending',  /* Pending, Approved, Rejected */
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

#### GROUP 4: ALERTS & EVENTS

```sql
/* AlertLogs */
CREATE TABLE AlertLogs (
    AlertID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    AlertDate DATETIME DEFAULT GETDATE(),
    DayNo INT,
    AlertLevel NVARCHAR(20) CHECK (AlertLevel IN ('INFO', 'WARNING', 'CRITICAL')),
    AlertCategory NVARCHAR(50), /* WATER_QUALITY, HEALTH, INVENTORY, COST, GROWTH */
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

/* Events */
CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    CycleID INT NOT NULL REFERENCES FarmingCycles(CycleID),
    EventDate DATE NOT NULL,
    DayNo INT,
    EventType NVARCHAR(50),           /* MEDICATION, WATER_EXCHANGE, HEALTH_CHECK, EMERGENCY, OTHER */
    Title NVARCHAR(200),
    Description NVARCHAR(1000),
    ChemicalID INT REFERENCES ChemicalInventory(ChemicalID),  /* Nếu là medication */
    DosageAmount DECIMAL(8,2),
    ExchangePercent DECIMAL(5,2),     /* Nếu là water exchange */
    Status NVARCHAR(20) DEFAULT 'PLANNED',  /* PLANNED, COMPLETED, CANCELLED */
    CompletedAt DATETIME,
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_Event_CycleDate (CycleID, EventDate DESC)
);
```

#### GROUP 5: COST TRACKING

```sql
/* CostTracking */
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

#### GROUP 6: SCENARIOS & JOB MANAGEMENT

```sql
/* ScenarioInput */
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
    Payload NVARCHAR(MAX),            /* JSON: Toàn bộ tham số input */
    CreatedBy INT REFERENCES Users(UserID),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_ScenarioInput_CreatedAt (CreatedAt DESC)
);

/* JobRunLog */
CREATE TABLE JobRunLog (
    JobID BIGINT IDENTITY(1,1) PRIMARY KEY,
    ScenarioID INT REFERENCES ScenarioInput(ScenarioID),
    StartedAt DATETIME DEFAULT GETDATE(),
    FinishedAt DATETIME,
    Status NVARCHAR(20),              /* Running, Success, Failed */
    Message NVARCHAR(MAX),
    TotalDaysProcessed INT,
    FailedDayCount INT,
    ExecutionTimeMs BIGINT,           /* Thời gian thực thi (ms) */
    INDEX IX_JobRunLog_Status (Status, FinishedAt DESC)
);
```

#### GROUP 7: AUDIT & REPORTING

```sql
/* AuditTrail */
CREATE TABLE AuditTrail (
    AuditID BIGINT PRIMARY KEY IDENTITY(1,1),
    TableName NVARCHAR(100) NOT NULL,
    RecordID INT,
    Action NVARCHAR(20) CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),
    OldValues NVARCHAR(MAX),          /* JSON format */
    NewValues NVARCHAR(MAX),          /* JSON format */
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

/* DailyReportSummary */
CREATE TABLE DailyReportSummary (
    ReportID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT NOT NULL REFERENCES FarmingCycles(CycleID),
    ReportDate DATE NOT NULL,
    DayNo INT,
    FishCount INT,
    AvgWeightG DECIMAL(8,2),
    BiomasKg DECIMAL(12,3),
    MortalityPct DECIMAL(5,2),
    DailyCost DECIMAL(10,2),
    ProjectedProfit DECIMAL(15,2),
    AlertCount INT,
    CriticalAlertCount INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_DailyReportSummary_CycleDay UNIQUE (CycleID, ReportDate),
    INDEX IX_DailyReportSummary_CycleDate (CycleID, ReportDate DESC)
);
```

---

## 5. YÊU CẦU CHỨC NĂNG

### 5.1 Master Data Management (FR-MDM)

#### FR-MDM-001: Farm Management
- CRUD Operations: Thêm, sửa, xóa thông tin farm
- Lưu trữ: Tên, địa chỉ, tòa độ, chứng nhận (ASC, BAP, GG)
- Phạm vi: Quản lý vùng/khu vực
- Cấu hình: Tham số riêng (giới hạn nước, aeration)

#### FR-MDM-002: Pond Management
- CRUD Operations: Thêm, sửa, xóa thông tin ao
- Lưu trữ: Diện tích, độ sâu, dung tích, loại ao
- Theo dõi: Ngày chuẩn bị, phương pháp chuẩn bị
- Mực nước: 5 level tùy chỉnh

#### FR-MDM-003: Warehouse Management
- CRUD Operations: Thêm, sửa, xóa kho
- Lưu trữ: Tên, mã, sức chứa tối đa
- Điều kiện: Theo dõi điều kiện lưu kho
- Real-time: Giám sát mức tồn kho

#### FR-MDM-004: Product Management
- Feed Inventory: Loại thức ăn, protein %, quy cách
- Chemical Inventory: Hóa chất, nồng độ, quy cách
- Thông tin: Nhà sản xuất, HSD, giá
- Phân loại: Feed, Chemical, Supplement, Environment

#### FR-MDM-005: User & Role Management
- Tạo/Quản lý: Tài khoản người dùng
- Roles: Admin, Manager, Staff, Viewer
- Audit Trail: Log mỗi thao tác
- Phạm vi: Trách nhiệm theo thời gian

### 5.2 Operational Management (FR-OPS)

#### FR-OPS-001: Fish Stocking
- Ghi nhận: Nguồn giống, chất lượng
- Theo dõi: Mật độ, số lượng thả
- Thông tin: Tuổi, kích cỡ fingerling
- Sản lượng: Kỳ vọng theo ao

#### FR-OPS-002: Farming Cycle (90 ngày)
- Khởi tạo: Với thông số đầu vào (StartDate, SeedQty, FCR, etc.)
- Trạng thái: PLANNING → ACTIVE → MEDICATING → HARVESTING → CLOSED
- Theo dõi: FCR, tỷ lệ chết, growth curve
- Chi tiết: 90 ngày dữ liệu

#### FR-OPS-003: Daily Logs
- Ghi nhận hàng ngày: Thức ăn, cá chết, pH, DO, nhiệt độ
- Sinh khối & TLBQ: Tính toán tự động
- Ghi chú: Sự kiện đặc biệt
- Form: Tham chiếu P301-F01

#### FR-OPS-004: Health Monitoring
- TLBQ & Bệnh: Ký sinh trùng, dấu hiệu lâm sàng
- Hao hụt: Tỷ lệ hao hụt theo ao
- Điều trị: Ghi nhận & hiệu quả
- Form: Tham chiếu P303-F07

#### FR-OPS-005: Water Management
- Cấp/Thoát: Lượng nước (m³)
- Giám sát: DO, pH, H2S, NH3
- Lịch thay: Theo chu kỳ
- Form: Tham chiếu P304-F04

#### FR-OPS-006: Waste Management
- Loại & Số lượng: Chất thải
- Xử lý: Phương pháp xử lý
- Giao nhận: Chủ kỳ
- Form: Tham chiếu P305-F37

### 5.3 Inventory Management (FR-INV)

#### FR-INV-001: Receipt (Nhập kho)
- Ghi nhận: BatchCode, ExpiryDate
- Direction: 'I' (Inbound)
- Auto-split: Nếu vượt CapacityKg
- Stored Procedure: sp_SplitReceiptByCapacity

#### FR-INV-002: Issue (Xuất kho) - FEFO
- Direction: 'O' (Outbound)
- Liên kết: Với CycleID
- Quy tắc: FEFO (First-Expired, First-Out)
- Stored Procedure: sp_AllocateFEFO

#### FR-INV-003: Stock Real-time
- Công thức: Stock = SUM(Nhập) - SUM(Xuất)
- Cảnh báo: HSD sắp hết (< 30 ngày)
- Báo cáo: Theo lô, theo HSD
- Dashboard: Tồn kho real-time

### 5.4 Auto-Generator & Simulation (FR-AUTO)

#### FR-AUTO-001: Scenario Input
Khai báo kịch bản với tham số:
- PondID, StartDate, EndDate
- SeedQty, AvgWeightG, FCR, InvisibleLossRate
- WarehouseID, FeedID
- Seed (for determinism)

#### FR-AUTO-002: Daily Pipeline (10 Steps)
Thực hiện tuần tự mỗi ngày:
1. WEATHER ANCHOR → Fetch temperature baseline
2. ENVIRONMENT GENERATOR → DO, pH, H2S, NH3
3. MORTALITY ENGINE → Cá chết, Tỷ lệ sống
4. GROWTH ENGINE → TLBQ, Sinh khối
5. FEED PLANNER → Thức ăn, làm tròn
6. CHEMICALS ENGINE → Hóa chất theo quy tắc
7. WATER EXCHANGE → Tần suất thay nước
8. INVENTORY SYNTHESIZER → FEFO xuất kho
9. DAILY LOG SAVE → Lưu vào DB
10. FORM FILLER → Chuẩn bị dữ liệu cho 8 form

#### FR-AUTO-003: Determinism
- Cùng seed → Cùng kết quả
- Lưu manifest: Với seed, version, checksum
- Verification: sp_VerifyDeterminism

#### FR-AUTO-004: Replay Mode (Tái Sinh Dữ Liệu)
- Deterministic: Cùng seed → cùng kết quả 100%
- Manifest: Lưu trữ seed, version, weather, checksums
- So sánh checksum từng ngày
- Báo cáo "Determinism: PASS ✅" hoặc "FAIL ❌"

#### FR-AUTO-005: Manual Override
- Chức năng: Cho phép sửa dữ liệu từng ngày sau khi sinh
- Audit Trail: Tự động log mọi thay đổi
- Recalculation: Tự động tính lại từ ngày sửa trở đi (FCR, cost, profit)
- Warning: Báo cáo ghi chú "Override Day X: field_name"
- Ràng buộc: 
  - Không cho sửa quá 20% tổng số ngày
  - Phải có lý do sửa đổi
  - Chỉ user có quyền Manager+ mới được sửa

### 5.5 Reporting & Analytics (FR-RP)

#### FR-RP-001: Standard Reports
- Báo cáo tổng hợp ngày/tuần/tháng
- Báo cáo tuân thủ môi trường
- Báo cáo tồn kho FEFO
- Báo cáo sức khỏe & FCR

#### FR-RP-002: 8 FSIS Forms

| Code | Tên biểu mẫu | Mục đích |
|------|------------|---------|
| P301-F01 | Nhật ký nuôi (90 dòng) | Daily log |
| P301-F06 | Biên bản giao nhận TA | Feed delivery |
| P301-F07 | Sổ theo dõi TA | Feed inventory |
| P303-F03 | Phiếu giao hàng HC | Chemical delivery |
| P303-F04 | Sổ theo dõi HC | Chemical inventory |
| P303-F06 | Phiếu chỉ định sản phẩm | Product spec |
| P303-F07 | Phiếu theo dõi sức khỏe | Health monitoring |
| P305-F37 | Sổ giao nhận chất thải | Waste transfer |

#### FR-RP-003: Export Formats
- Excel (XLSX) với EPPlus
- PDF với iText7
- Word (DOCX) với OpenXML
- CSV cho data exchange

---

## 6. YÊU CẦU PHI CHỨC NĂNG

### 6.0 Technical & Architecture Requirements (NFR-TECH)

#### NFR-TECH-001: Database-First Development Model

| Requirement | Standard | Rationale |
|-------------|----------|-----------|
| Database First | MUST | Database schema is source of truth, not models |
| EF Core Scaffolding | MUST | Models generated from database, not code-first migrations |
| Schema Validation | MUST | Models must match database 100% at all times |
| ToTable() Mapping | MUST | Explicit `.ToTable("ExactName")` for all entities |
| Column Mapping | MUST | `.HasColumnName()` when property ≠ column name |
| Property Cleanup | MUST | Remove unused properties that don't exist in database |
| Stored Procedures | MUST | Use for complex operations, not just EF LINQ |

**Compliance Check**:
```csharp
// ✅ Correct - Explicit table mapping
modelBuilder.Entity<FeedLedger>()
    .ToTable("FeedLedger");  // Must match database table name

// ❌ Wrong - Using default plural naming
// modelBuilder.Entity<FeedLedger>()  
//     (Would look for "FeedLedgers" table)
```

#### NFR-TECH-002: Windows Forms Designer Usage

| Requirement | Standard | Compliance |
|-------------|----------|-----------|
| 3-File Structure | MUST | Each form: .cs + .Designer.cs + .resx |
| Designer.cs Editing | FORBIDDEN | Never edit Designer.cs manually |
| InitializeComponent() | AUTO | Generated by Designer, must be called in ctor |
| Control Creation | DESIGNER ONLY | All controls created via Designer, not code |
| Property Setting | DESIGNER | Use Properties panel for appearance |
| Event Hooking | DESIGNER | Use Events tab in Properties panel |
| Naming Convention | MUST | txt, btn, lbl, cmb, dgv, chk, pnl prefixes |

**File Structure Example**:
```
ManageFarmsForm.cs          ← Edit here: logic, events
ManageFarmsForm.Designer.cs ← DO NOT EDIT: UI layout
ManageFarmsForm.resx        ← Resources: images, strings
```

**Valid Event Hook (Designer)**:
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

**Invalid - Hard-coded UI** (FORBIDDEN):
```csharp
// ❌ WRONG - Never do this!
public ManageFarmsForm()
{
    TextBox txtName = new TextBox();  // ❌ Create controls in code
    txtName.Location = new Point(10, 20);  // ❌ Set properties in code
    this.Controls.Add(txtName);  // ❌ Add to form in code
}
```

### 6.1 Hiệu năng (NFR-PERF)

| ID | Yêu cầu | Tiêu chuẩn |
|----|---------|-----------|
| NFR-PERF-001 | CRUD response | ≤ 2 giây |
| NFR-PERF-002 | Query 10,000 records | ≤ 1 giây |
| NFR-PERF-003 | Auto-Generate 365 ngày × 1000 ao | < 30 giây |
| NFR-PERF-004 | Export báo cáo | ≤ 10 giây |
| NFR-PERF-005 | Concurrent users | 50 users |

### 6.2 Bảo mật (NFR-SEC)

| ID | Yêu cầu | Chi tiết |
|----|---------|---------|
| NFR-SEC-001 | Authentication | Username/Password with BCrypt hash |
| NFR-SEC-002 | Authorization | Role-Based Access Control (RBAC) |
| NFR-SEC-003 | Audit Trail | Log mỗi thay đổi dữ liệu |
| NFR-SEC-004 | Data Encryption | Encrypt sensitive data at rest |
| NFR-SEC-005 | Password Policy | Min 8 chars, complexity rules |
| NFR-SEC-006 | Login Protection | Max 5 failed attempts → Lock account |
| NFR-SEC-007 | Session Timeout | Auto-logout after 30 mins |

### 6.3 Độ tin cậy (NFR-REL)

| ID | Yêu cầu | Tiêu chuẩn |
|----|---------|-----------|
| NFR-REL-001 | System Availability | ≥ 99.5% |
| NFR-REL-002 | Data Integrity | Transaction with rollback |
| NFR-REL-003 | Backup | Daily automatic backup |
| NFR-REL-004 | Recovery | Point-in-time recovery (30 days) |
| NFR-REL-005 | Network Issues | Graceful handling |

### 6.4 Khả năng sử dụng (NFR-USAB)

| ID | Yêu cầu | Chi tiết |
|----|---------|---------|
| NFR-USAB-001 | UI Design | Trực quan, nhất quán |
| NFR-USAB-002 | Language | Tiếng Việt + Tiếng Anh |
| NFR-USAB-003 | Help System | Context-sensitive help |
| NFR-USAB-004 | Training | < 2 giờ đào tạo |
| NFR-USAB-005 | Excel-like | Giống Excel hiện tại |

### 6.5 Khả năng mở rộng (NFR-SCALE)

| ID | Yêu cầu | Capacity |
|----|---------|----------|
| NFR-SCALE-001 | Farms | Tới 100 farms |
| NFR-SCALE-002 | Ponds | Tới 1000 ponds |
| NFR-SCALE-003 | Historical Data | 5 năm |
| NFR-SCALE-004 | Database | Partitioning support |
| NFR-SCALE-005 | Modular Design | Plugin architecture |

---

## 7. THÀNH PHẦN & SERVICES

### 7.1 11 Simulation Engines

#### Engine 1: EnvironmentGenerator
- **Input**: Pond data, DayNumber, Temperature (from Weather Adapter)
- **Output**: EnvironmentLog (DO, pH, H2S, NH3)
- **Công thức**:
  - DO = 5.5 - (Biomass/1000) × 0.5 - Random(0, 1.5) [mg/L]
  - pH = 7.2 + Random(-0.3, 0.3) + Adjustment [pH unit]
  - H2S = (Biomass/1000) × 0.0005 - (WaterExchange × 0.02) [mg/L]
  - NH3 = (Biomass/100) × 0.001 - (WaterExchange × 0.1) [mg/L]

#### Engine 2: MortalityEngine
- **Input**: Age, DO, pH, Temp, InvisibleLossRate (từ Scenario)
- **Output**: DeathQty (cá chết hôm nay)
- **Base Rate theo tuổi**:
  - 0-10 ngày: 0.1-0.5%
  - 11-30 ngày: 0.05-0.2%
  - 31-60 ngày: 0.02-0.1%
  - 61+ ngày: 0.01-0.05%
- **Hệ số stress**:
  - DO < 4: ×0.5 | pH ngoài 6.5-8.5: ×0.7 | Temp < 25: ×0.7
  - Temp > 32: ×0.6 | H2S > 0.05: ×0.4 | NH3 > 0.2: ×0.5

#### Engine 3: GrowthEngine
- **Input**: TLBQ (g/con), Age, DO, pH, Temp, FeedQuality
- **Output**: NewTLBQ, BiomassKg
- **Tăng trọng theo tuổi (điều kiện tối ưu)**:
  - 0-10 ngày: +0.2 g/con/ngày
  - 11-30 ngày: +0.5 g/con/ngày
  - 31-60 ngày: +0.8 g/con/ngày
  - 61+ ngày: +0.6 g/con/ngày

#### Engine 4: FeedPlanner
- **Input**: Biomass, Age, DO, pH, Temp, FCR (target), FeedType
- **Output**: FeedGivenKg
- **%BW theo tuổi (điều kiện tối ưu)**:
  - 0-10 ngày: 5-7% sinh khối/ngày
  - 11-30 ngày: 3-5%
  - 31-60 ngày: 2-3%
  - 61+ ngày: 1.5-2%

#### Engine 5: ChemicalEngine
- **Input**: Water quality parameters, Cycle status
- **Output**: Chemical usage, cost
- **Logic**: Quy tắc sử dụng dựa trên Decisioning Matrix

#### Engine 6: WaterOpsEngine
- **Input**: DO level, Temperature, Water exchange schedule
- **Output**: Water intake/discharge, frequency
- **Logic**: Priority DO nguy hiểm vs. scheduled exchange

#### Engine 7: InventoryEngine (FEFO)
- **Input**: Feed requirement, Warehouse state
- **Output**: Allocated qty, shortage qty
- **Logic**: FEFO allocation algorithm

#### Engine 8: CostTracker
- **Input**: Feed cost, Chemical cost, Electricity, Labor, Maintenance
- **Output**: Daily cost breakdown, cumulative cost
- **Logic**: Cost calculation with stress multipliers

#### Engine 9: AlertSystem
- **Input**: All parameters from other engines
- **Output**: Alert records (CRITICAL, WARNING, INFO)
- **Logic**: Decisioning Matrix thresholds

#### Engine 10: ValidationService
- **Input**: All daily data
- **Output**: Validation errors/warnings
- **Logic**: Business rules checking

#### Engine 11: ReportingEngine
- **Input**: Daily logs, costs, alerts
- **Output**: 8 FSIS forms, dashboards
- **Logic**: Data transformation & formatting

### 7.2 Weather Adapter

```csharp
public interface IWeatherProvider
{
    Task<decimal> GetTemperatureAsync(DateTime date, decimal lat, decimal lon);
}

public class LiveWeatherProvider : IWeatherProvider
{
    // Calls api.open-meteo.com with Polly retry
}

public class RuleBasedWeatherProvider : IWeatherProvider
{
    // Fallback: Reads EnvRules table + Jitter
}
```

### 7.3 Core Services Architecture

```csharp
// Services/GeneratorService.cs
public interface IGeneratorService
{
    Task<bool> RunScenarioAsync(ScenarioInput scenario);
}

// Services/InventoryService.cs
public interface IInventoryService
{
    Task<(decimal Allocated, decimal Shortage)> AllocateFEFOAsync(
        int warehouseId, int feedId, decimal requiredQtyKg, 
        DateTime asOfDate, int cycleId);
    Task CreateEmergencyReceiptAsync(int warehouseId, int feedId, 
        decimal qtyKg, DateTime receiptDate);
}

// Services/ReportingService.cs
public interface IReportingService
{
    Task<byte[]> ExportToExcelAsync(int cycleId);
    Task<byte[]> ExportToPdfAsync(int cycleId, string formCode);
    Task<byte[]> ExportToWordAsync(int cycleId, string formCode);
}
```

---

## 8. CÔNG THỨC TÍNH TOÁN & THUẬT TOÁN

### 8.1 Công thức Sinh khối (Biomass)

```
📌 SINH KHỐI (kg)
Sinh_khối = (Số_cá × TLBQ) / 1000

Trong đó:
- Số_cá: Số lượng cá hiện tại (con)
- TLBQ: Trọng lượng bình quân (g/con)
```

### 8.2 Công thức Tăng trưởng (Growth Rate)

```
📌 TĂNG TRƯỞNG HÀNG NGÀY
Actual_growth = Base_growth × Hệ_số_điều_chỉnh

📊 Base Growth theo tuổi:
┌────────────────────┬──────────────┬─────────────────────┐
│ Tuổi (ngày)        │ Tăng/ngày    │ TLBQ cuối giai đoạn │
├────────────────────┼──────────────┼─────────────────────┤
│ 0-10               │ +0.2 g/con   │ 1.5 → 3.5           │
│ 11-30              │ +0.5 g/con   │ 3.5 → 13.5          │
│ 31-60              │ +0.8 g/con   │ 13.5 → 37.5         │
│ 61-90              │ +0.6 g/con   │ 37.5 → 52.5         │
└────────────────────┴──────────────┴─────────────────────┘

⚙️ HỆ SỐ ĐIỀU CHỈNH:
- DO < 4 mg/L: × 0.5
- pH ngoài 6.5-8.5: × 0.7
- Temp < 25°C: × 0.7
- Temp > 32°C: × 0.6
- H2S > 0.05: × 0.4
- NH3 > 0.2: × 0.5
- Có bệnh: × 0.3-0.6
```

### 8.3 Công thức Tỷ lệ chết (Mortality Rate)

```
📌 TỶ LỆ CÁ CHẾT
Base_rate = GetBaseRate(Age)
Adjusted_rate = Base_rate × Hệ_số_bệnh × Hệ_số_stress
Cá_chết = Random(Adjusted_rate × 0.8, Adjusted_rate × 1.2) × Số_cá

📊 Base Rate theo tuổi:
┌────────────────────┬──────────────┐
│ Tuổi (ngày)        │ Tỷ lệ (%)    │
├────────────────────┼──────────────┤
│ 0-10               │ 0.1-0.5%     │
│ 11-30              │ 0.05-0.2%    │
│ 31-60              │ 0.02-0.1%    │
│ 61-90              │ 0.01-0.05%   │
└────────────────────┴──────────────┘
```

### 8.4 Công thức Thức ăn (Feed Allocation)

```
📌 LƯỢNG THỨC ĂN (kg/ngày)
Base_%BW = GetBaseFeeding(TLBQ, Age)
Adjusted_%BW = Base_%BW × Hệ_số_điều_chỉnh
Thức_ăn = (Sinh_khối × Adjusted_%BW) / 100

📊 Base %BW theo kích cỡ:
┌────────────┬──────────────┬──────────────┐
│ Kích cỡ    │ Tuổi         │ %BW/ngày     │
├────────────┼──────────────┼──────────────┤
│ < 50g      │ 0-10 ngày    │ 5-7%         │
│ 50-150g    │ 11-30 ngày   │ 3-5%         │
│ 150-300g   │ 31-60 ngày   │ 2-3%         │
│ > 300g     │ 61+ ngày     │ 1.5-2%       │
└────────────┴──────────────┴──────────────┘
```

### 8.5 Công thức FCR (Feed Conversion Ratio)

```
📌 FCR
FCR = Tổng_thức_ăn_tích_lũy / Tổng_sinh_khối_tích_lũy

TIÊU CHUẨN:
- 1.5-2.0: Tốt ✅
- 2.0-2.5: Bình thường ✅
- > 2.5: Cảnh báo 🟡
- > 3.0: Nguy hiểm 🔴
```

### 8.6 Công thức Chất lượng nước

```
📌 DO (Dissolved Oxygen) - mg/L
DO = 5.5 - (Sinh_khối / 1000) × 0.5 - Random(0, 1.5)

📌 pH
pH = 7.2 + Random(-0.3, 0.3) + Chemical_adjustment

📌 H2S - mg/L
H2S = (Sinh_khối / 1000) × 0.0005 - (Vệ_sinh × 0.02)

📌 NH3 - mg/L
NH3 = (Sinh_khối / 100) × 0.001 - (Thay_nước × 0.1)

TIÊU CHUẨN AN TOÀN:
- DO: > 5.0 mg/L (tối thiểu 3.0)
- pH: 6.5-8.5
- H2S: < 0.05 mg/L
- NH3: < 0.2 mg/L
```

### 8.7 Thuật toán FEFO (First-Expired, First-Out)

1. Lấy available batches, sắp xếp theo ExpiryDate ASC
2. Duyệt qua batches:
   - Calculate available qty (Inbound - Outbound)
   - Allocate từng batch theo FIFO
   - Create outbound record
3. Nếu còn thiếu → Tạo Purchase Order

### 8.8 Thuật toán Auto-Split Receipt

1. Nếu không có giới hạn → 1 entry
2. Chia nhỏ theo capacity:
   - Entry 1: min(CapacityKg, TotalQty)
   - Entry 2: min(CapacityKg, TotalQty - Entry1)
   - ...
3. Lưu từng entry với AllocationSlot

### 8.9 Cost Calculation Logic

```csharp
// Electricity Cost
decimal aeratorCost = aeratorHours * 1.5m * 3000;  // 1.5 kW
decimal pumpCost = (waterInM3 / 100) * 2.0m * 3000;
ElectricityCost = aeratorCost + pumpCost;

// Labor Cost (with Stress Multiplier)
decimal baseLaborCost = 150000; // VND/day
if (cycle.IsMedicatingToday) 
    baseLaborCost *= 1.5m;
if (cycle.Status == "HARVESTING") 
    baseLaborCost *= 2.0m;
```

---

## 9. QUY TRÌNH NGHIỆP VỤ

### 9.1 Daily Pipeline (10 Steps)

```
START
  │
  ├─> [STEP 1] WEATHER ANCHOR
  │   └─> Fetch temperature baseline data
  │
  ├─> [STEP 2] ENVIRONMENT GENERATOR
  │   ├─> Calculate DO (Dissolved Oxygen)
  │   ├─> Calculate pH
  │   ├─> Calculate H2S
  │   └─> Calculate NH3
  │
  ├─> [STEP 3] MORTALITY ENGINE
  │   ├─> Calculate base mortality rate
  │   ├─> Apply stress & disease factors
  │   ├─> Generate random dead count
  │   └─> Update FishCount
  │
  ├─> [STEP 4] GROWTH ENGINE
  │   ├─> Calculate growth rate from age
  │   ├─> Apply environment adjustments
  │   ├─> Update AvgWeightGr (TLBQ)
  │   └─> Calculate new Biomass
  │
  ├─> [STEP 5] FEED PLANNER
  │   ├─> Calculate %BW based on size
  │   ├─> Apply condition factors
  │   ├─> Calculate total feed in kg
  │   ├─> Round to standard bag size (25kg)
  │   └─> Validate ±50% from previous day
  │
  ├─> [STEP 6] CHEMICAL ENGINE
  │   ├─> Check water quality parameters
  │   ├─> Determine chemical needs (Probiotics, etc.)
  │   ├─> Calculate quantity & cost
  │   └─> Generate chemical purchase orders
  │
  ├─> [STEP 7] WATER EXCHANGE
  │   ├─> Calculate daily water volume
  │   ├─> Schedule exchanges per month
  │   ├─> Calculate intake/discharge m³
  │   └─> Update water parameters
  │
  ├─> [STEP 8] INVENTORY SYNTHESIZER (FEFO)
  │   ├─> Issue feed by FEFO algorithm
  │   ├─> Issue chemicals by FEFO
  │   ├─> Check stock levels
  │   └─> Create PO if shortage
  │
  ├─> [STEP 9] DAILY LOG SAVE
  │   ├─> Compile all data
  │   └─> Insert into DailyLogs table
  │
  └─> [STEP 10] ALERT GENERATION
      ├─> Check all thresholds (CRITICAL/WARNING/INFO)
      ├─> Generate alert messages
      ├─> Store in AlertLogs
      └─> Send notifications if needed
      
END
```

### 9.2 Khởi tạo Chu kỳ Nuôi

```
USER INPUT:
├─ Chọn Pond
├─ Chọn StartDate & EndDate (90 ngày)
├─ Khai báo InitialFishCount
├─ Khai báo InitialAvgWeightGr
├─ Chọn Species (CATFISH/TILAPIA/SHRIMP)
├─ Chọn WarehouseID & FeedID
└─ Input Seed (optional, for reproducibility)

VALIDATION:
├─ Pond không có active cycle?
├─ Start date < End date?
└─ Fish count > 0?

DATABASE SAVE:
├─ Tạo FarmingCycle record
├─ Status = 'PLANNING'
├─ LastProcessedDay = 0
└─ Lưu Seed & Manifest

NEXT:
└─> Ready for Auto-Generation
```

### 9.3 Workflow Duyệt Sản phẩm

```
[DRAFT] ────────────────────────────────┐
   │                                    │
   ├─> User fills P303-F06             │
   └─> Status: DRAFT                   │
                                       │
        ↓ Submit for Approval          │
                                       │
[PENDING]                              │
   │                                   │
   ├─> Manager reviews                 │
   │   ├─ Check data correctness       │
   │   ├─ Verify quantities            │
   │   └─ Review justification         │
   │                                   │
   ├─> ✅ APPROVE ──> [APPROVED]       │
   │   └─> Update inventory allocation │
   │       Generate purchase order     │
   │                                   │
   └─> ❌ REJECT ──> [REJECTED] ──────┘
       └─> Add rejection reason
           Notify user
           Return to DRAFT
```

### 9.4 Replay Mode (Tái Sinh Dữ Liệu)

```
USER ACTION:
├─ Tìm Manifest của chu kỳ cũ trong database
├─ Chọn chu kỳ cần replay
└─ Nhấn nút "Replay"

SYSTEM PROCESSING:
├─ Load Manifest (Seed, Version, Weather data, Checksums)
├─ Tái sinh toàn bộ 90 ngày với:
│  ├─ Cùng seed
│  ├─ Cùng version công thức
│  ├─ Cùng weather baseline
│  └─ Cùng tham số đầu vào
├─ So sánh checksum từng ngày:
│  ├─ Original checksum vs New checksum
│  └─ Field-by-field comparison
└─ Generate Verification Report

OUTPUT:
├─ Báo cáo "Determinism: PASS ✅" (nếu 100% match)
├─ Báo cáo "Determinism: FAIL ❌" (nếu có khác biệt)
└─ Chi tiết khác biệt (nếu có):
   ├─ Ngày
   ├─ Trường
   ├─ Giá trị cũ vs mới
   └─ % sai lệch
```

### 9.5 Manual Override

```
USER ACTION:
├─ Mở chu kỳ hiện có
├─ Chọn tab "Preview Data"
├─ Tìm ngày cần sửa (VD: Day 15)
├─ Nhấn nút "Edit" trên dòng đó
└─ Sửa các trường cần thiết

EDITABLE FIELDS:
├─ mortality_count (số cá chết)
├─ avg_weight_gr (TLBQ)
├─ DO, pH, Temperature
├─ feed_amount_kg
└─ chemical usage

AUDIT TRAIL (Auto-logged):
{
  "Day": 15,
  "Field": "mortality_count",
  "OldValue": 50,
  "NewValue": 75,
  "ModifiedBy": "user@example.com",
  "ModifiedAt": "2025-01-15T14:00:00",
  "Reason": "Actual observation different from simulation"
}

SYSTEM ACTIONS:
├─ Validate new values (business rules)
├─ Save audit trail
├─ Recalculate từ Day 15 trở đi
├─ Add watermark to reports
└─ Update checksums

CONSTRAINTS:
├─ Maximum 20% days can be overridden
├─ Must provide reason for change
├─ Only Manager+ role allowed
└─ Cannot override if cycle is COMPLETED
```

---

## 10. GIAO DIỆN & BÁO CÁO

### 10.1 Main Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│  AquaSim v4.0  [Đăng xuất] [Cấu hình]   Xin chào: Nguyễn A  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │   5      │  │   50     │  │  120     │  │   890    │    │
│  │  Farms   │  │  Ponds   │  │  Cycles  │  │ Daily    │    │
│  │          │  │          │  │          │  │  Logs    │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
│                                                             │
│  📊 PERFORMANCE CHART                                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ FCR: 1.95 ✅  | Survival: 86% ✅ | Growth: +0.6g ✅ │   │
│  │                                                     │   │
│  │ [Line Chart: 90-day trend]                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ⚠️  ALERTS & NOTIFICATIONS                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 🔴 CRITICAL: Low DO in Pond A3: 2.8 mg/L          │   │
│  │ 🟡 WARNING: Feed expiring in 5 days: Batch F2024  │   │
│  │ 🔵 INFO: Daily logs completed: 45/50 ponds        │   │
│  │ ✅ Backup completed successfully                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  🔧 QUICK ACTIONS                                          │
│  [+ Cycle] [Daily Entry] [Reports] [Inventory] [Settings]  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 10.2 Menu Structure

```
FILE
├─ New Cycle          [Ctrl+N]
├─ Import Excel       [Ctrl+I]
├─ Export
│  ├─ To Excel        [Ctrl+E]
│  ├─ To PDF
│  └─ To Word
└─ Exit               [Alt+F4]

MASTER DATA
├─ Farms
├─ Ponds
├─ Warehouses
├─ Products
│  ├─ Feed
│  └─ Chemicals
└─ Users & Roles

OPERATIONS
├─ Fish Stocking
├─ Daily Logs
├─ Health Monitoring
├─ Water Management
└─ Waste Management

INVENTORY
├─ Receipt (Nhập kho)
├─ Issue (Xuất kho)
├─ Stock Report
└─ Expiry Alert

AUTO-GENERATE
├─ Create Scenario
├─ Run Simulation
├─ Preview Results
└─ Commit Data

REPORTS
├─ P301 Series (Feed)
│  ├─ P301-F01: Daily Log
│  ├─ P301-F06: Feed Delivery
│  └─ P301-F07: Feed Inventory
├─ P303 Series (Health/Chemical)
│  ├─ P303-F03: Chemical Delivery
│  ├─ P303-F04: Chemical Inventory
│  ├─ P303-F06: Product Specification
│  └─ P303-F07: Health Monitoring
└─ P305 Series (Waste)
   └─ P305-F37: Waste Transfer

SETTINGS
├─ User Management
├─ System Config
├─ Backup/Restore
└─ About
```

### 10.3 Sample Report: P301-F01 (Daily Log)

```
═══════════════════════════════════════════════════════════════════
             NHAT KY NUOI CA - DAILY FARMING LOG
                      Mã: P301-F01
═══════════════════════════════════════════════════════════════════
Vùng nuôi/Farm: Trang trại Cá Bắc   Ao/Pond: A01   Tháng: 01/2025
───────────────────────────────────────────────────────────────────
 Ngày │Tuổi│ Temp│  DO   │ pH  │Cá chết│TLBQ │ Thức│ Ghi chú
      │    │(°C) │(mg/L) │     │       │(g)  │ ăn │
───────────────────────────────────────────────────────────────────
  1   │  1  │ 28.5│  5.2  │ 7.2 │  5    │ 1.5 │ 2.5 │
  2   │  2  │ 29.0│  5.0  │ 7.3 │  3    │ 1.7 │ 2.8 │
  3   │  3  │ 28.8│  4.8  │ 7.2 │  2    │ 1.9 │ 2.9 │
 ...  │ ... │ ... │  ...  │ ... │ ...   │ ... │ ... │ ...
 90   │ 90  │ 27.5│  4.8  │ 7.5 │  2    │52.5 │45.2 │Thu hoạch
───────────────────────────────────────────────────────────────────
Bác sĩ thú y/Veterinarian: Trần Văn B     Ngày/Date: 06/11/2025
Ký tên/Signature: ______________________
═══════════════════════════════════════════════════════════════════
```

---

## 11. SECURITY, AUDIT & ALERTS

### 11.1 Authentication & Authorization

#### Login Flow
```
User Input (Username + Password)
         ↓
BCrypt Hash Compare (12 rounds)
         ↓
   ✅ Match? ──→ Reset FailedAttempts
         ├─→ Create Session
         ├─→ Generate JWT Token
         └─→ Redirect to Dashboard
         ↓
   ❌ No Match ──→ Increment FailedAttempts
         ├─→ >= 5? ──→ Lock Account
         └─→ Show Error
```

#### Role-Based Access Control (RBAC)

| Role | Permissions |
|------|-----------|
| ADMIN | ✓ All CRUD operations, User management, System config, Audit trail, Backup/Restore |
| MANAGER | ✓ View all data, Edit cycles & daily logs, Approve workflows, Generate reports |
| STAFF | ✓ View assigned ponds/cycles, Edit daily logs (own pond), Submit for approval |
| VIEWER | ✓ Read-only access (all data) |

### 11.2 Audit Trail Implementation

Auto-logging for all changes:
- TableName, RecordID, Action (INSERT/UPDATE/DELETE)
- OldValues, NewValues (JSON format)
- ChangedFields, UserID, Username
- IPAddress, MachineName
- ActionDate (TIMESTAMP)

### 11.3 Alert Thresholds - Decisioning Matrix

#### CRITICAL Alerts (🔴)

| Condition | Threshold | Action Required |
|-----------|-----------|---------|
| DO (Dissolved Oxygen) | < 3.0 mg/L | Báo sạch, báт máy sục ngay |
| Mortality Rate | > 5%/day | Liên hệ thú y |
| Temperature | <20°C or >35°C | Thay nước ngay |
| pH | <6.0 or >9.0 | Điều chỉnh pH ngay |
| H2S (Hydrogen Sulfide) | > 0.1 mg/L | Vệ sinh đáy ngay |
| NH3 (Ammonia) | > 0.5 mg/L | Giảm thức ăn 50% + thay nước |

#### WARNING Alerts (🟡)

| Condition | Threshold | Action Required |
|-----------|-----------|---------|
| DO | 3.0-4.0 mg/L | Chuẩn bị báт máy sục |
| Mortality | 2-5%/day | Theo dõi chặt |
| Temperature | 25-28 or 32-35°C | Chuẩn bị thay nước |
| pH | 6.0-6.5 or 8.5-9 | Chuẩn bị điều chỉnh pH |
| H2S | 0.05-0.1 mg/L | Vệ sinh sơ bộ |
| NH3 | 0.3-0.5 mg/L | Giảm thức ăn 30% |
| FCR | > 2.5 | Kiểm tra thức ăn |
| Stock (Feed/Chemical) | < 7 days | Đặt hàng bổ sung |

#### INFO Alerts (🔵)

- Milestone reached (Day 30, 60, 90)
- Growth rate trend update
- Harvest prediction ready
- Maintenance due reminder
- Report available
- Daily log completed

---

## 12. TESTING & PERFORMANCE

### 12.1 Testing Strategy

#### Unit Testing (NUnit)
```csharp
[TestFixture]
public class GrowthEngineTests
{
    // Test normal conditions
    // Test stress conditions
    // Verify adjustment factors
}

[TestFixture]
public class FEFOAlgorithmTests
{
    // Test multiple expiries - earliest first
    // Test shortage handling
    // Test batch allocation
}
```

#### Integration Testing
```csharp
[TestFixture]
public class DailyPipelineIntegrationTests
{
    // Test Day 1 generates all data
    // Test Day 90 all data consistent
    // Verify FCR reasonable
}
```

### 12.2 Performance Benchmarks

| Operation | Records | EF Core | Stored Proc |
|-----------|---------|--------|------------|
| Generate 90 Days | 1 cycle | 5-8 sec | 1-2 sec |
| FEFO Allocation | 1000 | 200ms | 50ms |
| Report Export | 90 days | 1-3 sec | N/A |
| Bulk Insert | 1000 | 2 sec | 300ms |
| Query 10,000 records | 10k | 800ms | 200ms |
| Calculate Stock | 1 product | 150ms | 50ms |

### 12.3 Load Testing Scenarios

| Scenario | Ponds | Cycles/Year | Daily Logs/Year | Concurrent Users | Response Time |
|----------|-------|------------|---------|-----------------|---------------|
| Small | 10 | 40 | 3,600 | 5 | < 1 sec |
| Medium | 50 | 200 | 18,000 | 25 | < 2 sec |
| Large | 100 | 400 | 36,000 | 50 | < 3 sec |
| Enterprise | 500+ | 2000+ | 180,000+ | 100+ | < 5 sec (w/ cache) |

---

## 13. TRIỂN KHAI & MIGRATION

### 13.1 Implementation Phases

#### Phase 1: Database Setup (Week 1-2)
- Create SQL Server database
- Execute DDL scripts (Tables)
- Create indexes
- Deploy stored procedures

#### Phase 2: Backend Development (Week 3-8)
- Setup .NET 9.0 project structure
- Implement Domain entities
- Create DbContext & Migrations
- Implement 11 Simulation Engines
- Unit testing (>80% coverage)

#### Phase 3: Frontend Development (Week 9-10)
- Create main dashboard
- Implement forms
- Add reporting UI
- Create admin panel

#### Phase 4: Testing & Deployment (Week 11-12)
- Integration testing
- Performance testing
- UAT
- Production environment setup

#### Phase 5: Report Generation (Week 13)
- Implement 8 FSIS forms export
- Excel export với EPPlus
- PDF export với iText7
- Word export với OpenXML

#### Phase 6: Advanced Features (Week 14)
- Replay Mode
- Manual Override
- E-signature workflow
- Advanced alerts

**Total Timeline**: 14 tuần (3.5 tháng) + Ongoing support

### 13.2 Deployment Checklist

**PRE-DEPLOYMENT:**
- ☐ Code review completed (100%)
- ☐ Unit tests passed (>80% coverage)
- ☐ Integration tests passed
- ☐ Performance testing completed
- ☐ Security audit passed
- ☐ UAT sign-off

**DATABASE DEPLOYMENT:**
- ☐ Production database created
- ☐ All tables created
- ☐ All indexes created
- ☐ All stored procedures deployed
- ☐ Security roles configured
- ☐ Backup plan implemented

**APPLICATION DEPLOYMENT:**
- ☐ .NET Runtime 9.0 installed
- ☐ Connection strings configured
- ☐ Logging configured
- ☐ Email notifications configured

**POST-DEPLOYMENT:**
- ☐ Smoke test completed
- ☐ System startup verified
- ☐ User training completed
- ☐ Support contact established
- ☐ Monitoring enabled
- ☐ First backup verified

---

## 14. PHỤ LỤC

### 14.1 Glossary - Thuật ngữ

| Tiếng Anh | Tiếng Việt | Giải thích |
|-----------|-----------|-----------|
| Fingerling | Giống | Cá/tôm giống để thả nuôi |
| Stocking | Thả giống | Qua trình đưa giống vào ao |
| Cycle | Vụ/Chu kỳ nuôi | 90 ngày từ thả giống đến thu hoạch |
| Biomass | Sinh khối | Tổng khối lượng cá/tôm hiện tại |
| TLBQ | Trọng lượng bình quân | Average weight (g/con) |
| FCR | Hệ số chuyển đổi | Feed Conversion Ratio |
| DO | Oxy hòa tan | Dissolved Oxygen (mg/L) |
| FEFO | First-Expired, First-Out | Xuất hàng theo HSD sớm nhất |
| Batch Code | Mã lô | Mã theo dõi lô sản xuất |
| HSD | Hạn sử dụng | Expiry Date |
| ASC/BAP | Chứng nhận | Aquaculture/Best Practices |
| Ledger | Sổ | Sổ ghi chép giao nhận |
| Receipt | Nhập kho | Phiếu ghi nhận hàng vào kho |
| Issue | Xuất kho | Phiếu ghi nhận hàng ra kho |

### 14.2 Data Validation Rules

**BUSINESS RULES:**
- Pond không thể có 2 cycles active cùng lúc
- FCR không thể < 1.0 (không hợp lý)
- Survival rate không thể > 100%
- Feed amount không thể > 10% body weight
- Temperature: 15-40°C (ngoài là lỗi)
- pH: 4.0-11.0
- DO: 0-20 mg/L
- Expiry date phải > Manufacturing date
- Batch code phải unique trong warehouse
- Daily log không thể có > 5% missing fields

**ERROR HANDLING:**
- Transaction rollback nếu validation fails
- Log error details vào AuditTrail
- Show user-friendly error message
- Notify admin nếu critical

### 14.3 Known Limitations

- Desktop only (Windows Forms) → Future: Web version
- Single-site deployment → Future: Multi-site with sync
- Manual input triggers auto-generation → Future: Scheduled
- No real-time sensor integration → Future: IoT sensors
- Reports in local language only → Future: Multi-language
- No mobile app → Future: Android/iOS
- Audit trail retained 1 year → Future: Cold storage

### 14.4 Contact & Support

**TECHNICAL SUPPORT:**
- Email: support@aquasim.vn
- Phone: (028) 3-XXXX-XXXX
- Hours: Mon-Fri 8:00-17:00

**TRAINING:**
- Online: training@aquasim.vn
- Duration: 2-4 hours
- Frequency: Weekly sessions

**BUG REPORTING:**
- System: bugs@aquasim.vn
- Priority: Critical (4h), High (1d), Normal (3d)

---

## DISCLAIMER & WATERMARK REQUIREMENTS

### ⚠️ Tuyên Bố Miễn Trách

**Dữ Liệu Mô Phỏng**:
- Tất cả dữ liệu được sinh **TỰ ĐỘNG** từ công thức mô phỏng
- **KHÔNG PHẢI** dữ liệu thực từ trang trại
- **Mục đích**: Đào tạo, chuẩn hóa biểu mẫu, phân tích
- **KHÔNG** sử dụng cho báo cáo chính thức

### 🔴 Watermark Bắt Buộc

```
"MOCKED DATA - FOR TRAINING ONLY"
```

**Phải có trên tất cả**:
- ✅ Biểu mẫu xuất (XLSX/DOCX/PDF)
- ✅ Header báo cáo
- ✅ File CSV/JSON export
- ✅ Dashboard preview
- ✅ Print outputs

### ❌ KHÔNG được phép
- ❌ Gửi báo cáo này cho chính quyền
- ❌ Sử dụng cho kiểm định/chứng nhận
- ❌ Xóa watermark
- ❌ Phát hành công khai
- ❌ Thay thế dữ liệu thực tế

### ✅ Được phép
- ✅ Dùng để đào tạo nhân viên
- ✅ Test tính năng hệ thống
- ✅ Demo cho khách hàng (với watermark)
- ✅ Phân tích công thức
- ✅ Kiểm tra layout biểu mẫu

---

## DOCUMENT METADATA

| Property | Value |
|----------|-------|
| **Document ID** | ARCH-AQUASIM-FINAL |
| **Version** | 4.0 Final Consolidated |
| **Status** | ✅ APPROVED |
| **Date** | 06/11/2025 |
| **Total Pages** | ~60 pages |
| **Word Count** | ~35,000+ words |
| **Author** | Technical Team |
| **Reviewer** | Project Manager |
| **Approver** | Client Representative |

---

## CHANGE HISTORY

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 15/10/2025 | Initial architecture from SRS |
| v2.0 | 25/10/2025 | Added detailed components |
| v3.0 | 01/11/2025 | Integrated all engines |
| v4.0 | 04/11/2025 | Added security, testing |
| **Final** | **06/11/2025** | **Consolidated from 6 files, complete & unified** |

---

## APPROVALS

```
SIGN-OFF:

Technical Lead: _________________________ Date: _______
  (Verify technical feasibility & architecture)

Project Manager: ________________________ Date: _______
  (Verify scope & timeline)

Client Representative: ____________________ Date: _______
  (Verify requirements & acceptance)

Quality Assurance: _______________________ Date: _______
  (Verify completeness & clarity)
```

---

**END OF DOCUMENT**

⚠️ **CONFIDENTIAL** - For authorized personnel only  
© 2025 AquaSim System. All rights reserved.

