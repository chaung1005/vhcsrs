# 📋 CHI TIẾT CÁC CHỨC NĂNG HỆ THỐNG AQUASIM v4.0
## File tổng hợp tất cả chức năng được cập nhật từ tài liệu

**Ngày tạo**: 07/11/2025  
**Phiên bản**: 4.0 Consolidated Complete  
**Trạng thái**: ✅ APPROVED & COMPLETE  
**Tác giả**: Technical Team  
**Nguồn tài liệu**: 
- ✅ aquasim_srs_chuan_v4.1.md
- ✅ Architecture_final.md
- ✅ DATABASE_UPDATES_SUMMARY.md

---

## 📑 MỤC LỤC

1. [Tóm tắt Điều hành](#1-tóm-tắt-điều-hành)
2. [Kiến Trúc Hệ Thống](#2-kiến-trúc-hệ-thống)
3. [11 Simulation Engines](#3-11-simulation-engines)
4. [Công Thức Tính Toán](#4-công-thức-tính-toán)
5. [Quy Trình Nghiệp Vụ](#5-quy-trình-nghiệp-vụ)
6. [Quản Lý Master Data](#6-quản-lý-master-data)
7. [Quản Lý Vận Hành](#7-quản-lý-vận-hành)
8. [Quản Lý Kho](#8-quản-lý-kho)
9. [Auto-Generation & Simulation](#9-auto-generation--simulation)
10. [Báo Cáo & Phân Tích](#10-báo-cáo--phân-tích)
11. [Bảo Mật & Audit](#11-bảo-mật--audit)
12. [Cảnh Báo & Monitoring](#12-cảnh-báo--monitoring)
13. [Cơ Sở Dữ Liệu](#13-cơ-sở-dữ-liệu)

---

## 1. TÓM TẮT ĐIỀU HÀNH

### 1.1 Vấn Đề Hiện Tại
- ✗ **Excel quản lý**: Không đồng bộ, dễ lỗi
- ✗ **Theo dõi thủ công**: Tốn thời gian, sai sót
- ✗ **Báo cáo không chuẩn**: Không đạt tiêu chuẩn FSIS

### 1.2 Giải Pháp AquaSim
- ✅ **Tự động hóa 100%** chu kỳ nuôi (90 ngày)
- ✅ **Sinh dữ liệu thông minh** từ 1 form input
- ✅ **Quản lý FEFO** kho thức ăn & hóa chất
- ✅ **Xuất chuẩn FSIS** 8 biểu mẫu
- ✅ **Deterministic simulation** (cùng seed = cùng kết quả)
- ✅ **Replay mode** để xác minh tính nhất quán

### 1.3 KPIs Chính

| Chỉ số | Target | Hiện tại | Cải thiện |
|--------|--------|---------|----------|
| Ngày input | 90 ngày | 1 ngày | **99%** |
| FCR | < 2.0 | 2.3 | **13%** |
| Survival Rate | > 85% | 82% | **3%** |
| Báo cáo chuẩn | 8/8 | 2/8 | **300%** |
| Compliance | 100% | 60% | **67%** |

---

## 2. KIẾN TRÚC HỆ THỐNG

### 2.1 Mô Hình 3-Tier

```
┌─────────────────────────────────────┐
│   PRESENTATION LAYER (UI)           │
│   Windows Forms (.NET 9.0)          │
├─────────────────────────────────────┤
│   BUSINESS LOGIC LAYER              │
│   11 Simulation Engines + Services  │
├─────────────────────────────────────┤
│   DATA ACCESS LAYER                 │
│   Entity Framework Core + Stored Proc│
├─────────────────────────────────────┤
│   DATABASE (SQL SERVER 2019+)       │
│   55+ Tables, Views, SPs, Triggers  │
└─────────────────────────────────────┘
```

### 2.2 Tech Stack Đầy Đủ

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

### 2.3 Design Patterns
- **Repository Pattern**: Clean Architecture + Adapter
- **Dependency Injection**: IoC Container
- **Unit of Work**: Transaction Management
- **Factory Pattern**: Object Creation
- **Strategy Pattern**: Algorithm Selection (11 engines)
- **Observer Pattern**: Event & Alert Handling
- **Interceptor Pattern**: Audit Trail auto-logging

---

## 3. 11 SIMULATION ENGINES

### 3.1 Engine 1: EnvironmentGenerator ⚙️
**Chức năng**: Sinh dữ liệu chất lượng nước

**Input**:
- Sinh khối hiện tại
- Ngày
- Nhiệt độ baseline

**Output**:
- DO (Dissolved Oxygen) - mg/L
- pH
- H2S - mg/L
- NH3 - mg/L

**Công thức**:
```
DO = 5.5 - (Sinh_khối / 1000) × 0.5 - Random(0, 1.5)
pH = 7.2 + Random(-0.3, 0.3)
H2S = (Sinh_khối / 1000) × 0.0005 - (Vệ_sinh × 0.02)
NH3 = (Sinh_khối / 100) × 0.001 - (Thay_nước × 0.1)
```

**Tiêu chuẩn an toàn**:
- DO: > 5.0 mg/L (tối thiểu 3.0)
- pH: 6.5-8.5
- H2S: < 0.05 mg/L
- NH3: < 0.2 mg/L

---

### 3.2 Engine 2: MortalityEngine ⚠️
**Chức năng**: Tính toán số cá chết hàng ngày

**Input**:
- Tuổi cá
- DO, pH, Nhiệt độ
- Tỷ lệ hao hụt (từ Scenario)

**Base Rate theo tuổi**:
| Tuổi | Tỷ lệ (%) |
|-----|----------|
| 0-10 ngày | 0.1-0.5% |
| 11-30 ngày | 0.05-0.2% |
| 31-60 ngày | 0.02-0.1% |
| 61+ ngày | 0.01-0.05% |

**Hệ số stress**:
- DO < 4: ×0.5
- pH ngoài 6.5-8.5: ×0.7
- Temp < 25: ×0.7
- Temp > 32: ×0.6
- H2S > 0.05: ×0.4
- NH3 > 0.2: ×0.5

**Output**: Số cá chết (±20% ngẫu nhiên)

---

### 3.3 Engine 3: GrowthEngine 📈
**Chức năng**: Tính toán tăng trọng cá hàng ngày

**Tăng trọng theo tuổi (điều kiện tối ưu)**:
| Tuổi | Tăng/ngày | TLBQ cuối |
|-----|----------|----------|
| 0-10 | +0.2 g/con | 1.5 → 3.5 |
| 11-30 | +0.5 g/con | 3.5 → 13.5 |
| 31-60 | +0.8 g/con | 13.5 → 37.5 |
| 61+ | +0.6 g/con | 37.5 → 52.5 |

**Hệ số điều chỉnh**:
- DO < 4: ×0.5
- pH ngoài 6.5-8.5: ×0.7
- Temp < 25: ×0.7
- Temp > 32: ×0.6
- H2S > 0.05: ×0.4
- NH3 > 0.2: ×0.5
- Có bệnh: ×0.3-0.6

**Output**: TLBQ mới, Sinh khối mới

---

### 3.4 Engine 4: FeedPlanner 🍖
**Chức năng**: Xác định lượng thức ăn hàng ngày

**Base %BW theo kích cỡ**:
| Kích cỡ | Tuổi | %BW/ngày |
|--------|------|----------|
| < 50g | 0-10 ngày | 5-7% |
| 50-150g | 11-30 ngày | 3-5% |
| 150-300g | 31-60 ngày | 2-3% |
| > 300g | 61+ ngày | 1.5-2% |

**Điều chỉnh**:
- Đang dùng thuốc: ×0.5
- DO < 4: ×0.6
- pH ngoài range: ×0.7
- Có bệnh: ×0.5-0.8
- **Ràng buộc**: ±50% so với ngày trước

**Output**: Thức ăn (kg/ngày)

---

### 3.5 Engine 5: ChemicalEngine 💊
**Chức năng**: Xác định hóa chất cần dùng

**Logic**:
- Kiểm tra chất lượng nước
- Áp dụng quy tắc từ Decisioning Matrix
- Xác định loại & lượng hóa chất
- Tính toán chi phí

**Loại hóa chất**:
- PROBIOTIC
- VITAMIN
- ANTIBIOTIC
- pH_ADJUSTER
- SALT

**Output**: Chemical usage, cost

---

### 3.6 Engine 6: WaterOpsEngine 💧
**Chức năng**: Quản lý thay nước

**Logic**:
- DO nguy hiểm → thay nước ngay
- Lịch thay nước theo chu kỳ tháng
- Tính toán lượng nước cấp/thoát

**Output**: 
- Water intake/discharge (m³)
- Tần suất thay nước

---

### 3.7 Engine 7: InventoryEngine 📦
**Chức năng**: FEFO allocation

**Thuật toán FEFO**:
1. Lấy available batches
2. Sắp xếp theo ExpiryDate ASC
3. Allocate theo FIFO
4. Tạo PO nếu thiếu

**Output**: Allocated qty, shortage qty

---

### 3.8 Engine 8: CostTracker 💰
**Chức năng**: Tính toán chi phí hàng ngày

**Cost Categories** (VND):
- FeedCost
- ChemicalCost
- ElectricityCost
- LaborCost
- MaintenanceCost
- OtherCost

**Labor Stress Multiplier**:
- Bình thường: 150,000 VND/ngày
- Dùng thuốc: ×1.5
- Thu hoạch: ×2.0

**Output**: Daily cost, cumulative cost

---

### 3.9 Engine 9: AlertSystem 🔔
**Chức năng**: Phát sinh cảnh báo

**Alert Levels**:
- 🔴 **CRITICAL**: Phải xử lý trong 1 giờ
- 🟡 **WARNING**: Xử lý trong 24 giờ
- 🔵 **INFO**: Thông báo thông tin

**Categories**:
- WATER_QUALITY
- HEALTH
- INVENTORY
- COST
- GROWTH

**Output**: AlertLogs records

---

### 3.10 Engine 10: ValidationService ✓
**Chức năng**: Kiểm tra hợp lệ dữ liệu

**Business Rules**:
- Pond không có 2 cycles active
- FCR >= 1.0
- Survival rate <= 100%
- Feed <= 10% body weight
- Temperature: 15-40°C
- pH: 4.0-11.0
- DO: 0-20 mg/L

**Output**: Validation errors/warnings

---

### 3.11 Engine 11: ReportingEngine 📊
**Chức năng**: Xuất báo cáo & biểu mẫu

**Output**:
- 8 FSIS forms
- Excel/PDF/Word
- Dashboard data
- Cycle summary

---

## 4. CÔNG THỨC TÍNH TOÁN

### 4.1 Sinh Khối (Biomass)
```
Sinh_khối = (Số_cá × TLBQ) / 1000

Trong đó:
- Số_cá: Số lượng cá hiện tại (con)
- TLBQ: Trọng lượng bình quân (g/con)
```

### 4.2 FCR (Feed Conversion Ratio)
```
FCR = Tổng_thức_ăn_tích_lũy / Tổng_sinh_khối_tích_lũy

Tiêu chuẩn:
- 1.5-2.0: Tốt ✅
- 2.0-2.5: Bình thường ✅
- > 2.5: Cảnh báo 🟡
- > 3.0: Nguy hiểm 🔴
```

### 4.3 Tỷ lệ Sống (Survival Rate)
```
Survival_rate = (FishRemain / InitialFishCount) × 100%

Tiêu chuẩn:
- > 85%: Tốt ✅
- 80-85%: Bình thường ✅
- < 80%: Cảnh báo 🟡
```

### 4.4 Daily Growth
```
DailyGrowth = TLBQ_hôm_nay - TLBQ_hôm_qua

Hệ số điều chỉnh:
- Normal: Base growth × 1.0
- Stress: Base growth × 0.3-0.8
```

---

## 5. QUY TRÌNH NGHIỆP VỤ

### 5.1 Daily Pipeline (10 Steps)

```
🔄 DAILY GENERATION FLOW

START
  │
  ├─→ [STEP 1] WEATHER ANCHOR
  │   └─ Fetch temperature baseline data
  │
  ├─→ [STEP 2] ENVIRONMENT GENERATOR
  │   ├─ Calculate DO (Dissolved Oxygen)
  │   ├─ Calculate pH
  │   ├─ Calculate H2S
  │   └─ Calculate NH3
  │
  ├─→ [STEP 3] MORTALITY ENGINE
  │   ├─ Calculate base mortality rate
  │   ├─ Apply stress & disease factors
  │   ├─ Generate random dead count
  │   └─ Update FishCount
  │
  ├─→ [STEP 4] GROWTH ENGINE
  │   ├─ Calculate growth rate from age
  │   ├─ Apply environment adjustments
  │   ├─ Update AvgWeightGr (TLBQ)
  │   └─ Calculate new Biomass
  │
  ├─→ [STEP 5] FEED PLANNER
  │   ├─ Calculate %BW based on size
  │   ├─ Apply condition factors
  │   ├─ Calculate total feed in kg
  │   ├─ Round to standard bag size (25kg)
  │   └─ Validate ±50% from previous day
  │
  ├─→ [STEP 6] CHEMICAL ENGINE
  │   ├─ Check water quality parameters
  │   ├─ Determine chemical needs
  │   ├─ Calculate quantity & cost
  │   └─ Generate chemical purchase orders
  │
  ├─→ [STEP 7] WATER EXCHANGE
  │   ├─ Calculate daily water volume
  │   ├─ Schedule exchanges per month
  │   ├─ Calculate intake/discharge m³
  │   └─ Update water parameters
  │
  ├─→ [STEP 8] INVENTORY SYNTHESIZER (FEFO)
  │   ├─ Issue feed by FEFO algorithm
  │   ├─ Issue chemicals by FEFO
  │   ├─ Check stock levels
  │   └─ Create PO if shortage
  │
  ├─→ [STEP 9] DAILY LOG SAVE
  │   ├─ Compile all data
  │   └─ Insert into DailyLogs table
  │
  └─→ [STEP 10] ALERT GENERATION
      ├─ Check all thresholds
      ├─ Generate alert messages
      ├─ Store in AlertLogs
      └─ Send notifications if needed
      
END
```

### 5.2 Khởi Tạo Chu Kỳ Nuôi

**User Input**:
- Chọn Pond
- StartDate & EndDate (90 ngày)
- InitialFishCount
- InitialAvgWeightGr
- Species (CATFISH/TILAPIA/SHRIMP)
- WarehouseID & FeedID
- Seed (optional)

**Validation**:
- Pond không có active cycle?
- Start date < End date?
- Fish count > 0?

**Database Save**:
- Tạo FarmingCycle record
- Status = 'PLANNING'
- Lưu Seed & Manifest

### 5.3 Replay Mode (Tái Sinh Dữ Liệu)

**Mục đích**: Kiểm tra tính deterministic

**Quy trình**:
1. Tìm Manifest của chu kỳ cũ
2. Load Seed, Version, Weather data
3. Tái sinh toàn bộ 90 ngày
4. So sánh checksum từng ngày
5. Báo cáo "PASS ✅" hoặc "FAIL ❌"

### 5.4 Manual Override

**Mục đích**: Điều chỉnh dữ liệu sinh tự động

**Editable Fields**:
- mortality_count (số cá chết)
- avg_weight_gr (TLBQ)
- DO, pH, Temperature
- feed_amount_kg
- chemical usage

**Audit Trail** (Auto-logged):
```json
{
  "Day": 15,
  "Field": "mortality_count",
  "OldValue": 50,
  "NewValue": 75,
  "ModifiedBy": "user@example.com",
  "ModifiedAt": "2025-01-15T14:00:00",
  "Reason": "Actual observation"
}
```

**Constraints**:
- Maximum 20% days can be overridden
- Must provide reason for change
- Only Manager+ role allowed
- Cannot override if cycle is COMPLETED

---

## 6. QUẢN LÝ MASTER DATA

### 6.1 Farm Management (FR-MDM-001)
**Chức năng**:
- ✓ CRUD Operations: Thêm, sửa, xóa thông tin farm
- ✓ Lưu trữ: Tên, địa chỉ, tòa độ, chứng nhận (ASC, BAP, GG)
- ✓ Phạm vi: Quản lý vùng/khu vực
- ✓ Cấu hình: Tham số riêng (giới hạn nước, aeration)

**Master Table**: Farms

### 6.2 Pond Management (FR-MDM-002)
**Chức năng**:
- ✓ CRUD Operations: Thêm, sửa, xóa thông tin ao
- ✓ Lưu trữ: Diện tích, độ sâu, dung tích, loại ao
- ✓ Theo dõi: Ngày chuẩn bị, phương pháp chuẩn bị
- ✓ Mực nước: 5 level tùy chỉnh

**Master Table**: Ponds

### 6.3 Warehouse Management (FR-MDM-003)
**Chức năng**:
- ✓ CRUD Operations: Thêm, sửa, xóa kho
- ✓ Lưu trữ: Tên, mã, sức chứa tối đa (CapacityKg)
- ✓ Điều kiện: Theo dõi điều kiện lưu kho
- ✓ Real-time: Giám sát mức tồn kho

**Master Table**: Warehouses

### 6.4 Product Management (FR-MDM-004)
**Feed Inventory**:
- Loại thức ăn, protein %, quy cách
- Nhà sản xuất, HSD, giá

**Chemical Inventory**:
- Hóa chất, nồng độ, quy cách
- Phân loại: PROBIOTIC, VITAMIN, ANTIBIOTIC, pH_ADJUSTER, SALT

**Master Tables**: FeedInventory, ChemicalInventory

### 6.5 User & Role Management (FR-MDM-005)
**Roles & Permissions**:

| Role | Permissions |
|------|-----------|
| **ADMIN** | ✓ All CRUD, User mgmt, System config, Audit trail, Backup/Restore |
| **MANAGER** | ✓ View all, Edit cycles, Approve workflows, Generate reports |
| **STAFF** | ✓ View assigned ponds, Edit daily logs (own), Submit for approval |
| **VIEWER** | ✓ Read-only access (all data) |

**Master Table**: Users

---

## 7. QUẢN LÝ VẬN HÀNH

### 7.1 Fish Stocking (FR-OPS-001)
**Chức năng**:
- ✓ Ghi nhận: Nguồn giống, chất lượng
- ✓ Theo dõi: Mật độ, số lượng thả
- ✓ Thông tin: Tuổi, kích cỡ fingerling
- ✓ Sản lượng: Kỳ vọng theo ao

### 7.2 Farming Cycle Management (FR-OPS-002)
**Trạng thái**: PLANNING → ACTIVE → MEDICATING → HARVESTING → CLOSED → CANCELLED

**Thông tin**:
- ✓ StartDate & EndDate (90 ngày)
- ✓ Species: CATFISH, TILAPIA, SHRIMP
- ✓ InitialFishCount & InitialAvgWeightGr
- ✓ FCR (Feed Conversion Ratio)
- ✓ Seed (for determinism)
- ✓ Manifest (JSON: seed, version, checksums)

**Master Table**: FarmingCycles

### 7.3 Daily Logs (FR-OPS-003)
**Ghi nhận hàng ngày**:
- Thức ăn (kg)
- Cá chết (con)
- Nhiệt độ (°C)
- DO (mg/L), pH
- Ghi chú sự kiện đặc biệt

**Tính toán tự động**:
- Sinh khối (kg)
- TLBQ (g/con)
- FCR tích lũy

**Master Table**: DailyLogs

### 7.4 Health Monitoring (FR-OPS-004)
**Theo dõi**:
- ✓ TLBQ & Bệnh
- ✓ Ký sinh trùng
- ✓ Dấu hiệu lâm sàn
- ✓ Hao hụt tỷ lệ
- ✓ Ghi nhận & hiệu quả điều trị

**Master Tables**: HealthMonitoring, Events

### 7.5 Water Management (FR-OPS-005)
**Quản lý chất lượng nước**:
- ✓ Lượng nước cấp/thoát (m³)
- ✓ Giám sát: DO, pH, H2S, NH3
- ✓ Lịch thay nước theo chu kỳ
- ✓ Thay đổi mực nước

**Master Table**: WaterManagement

### 7.6 Waste Management (FR-OPS-006)
**Quản lý chất thải**:
- ✓ Loại & Số lượng
- ✓ Phương pháp xử lý
- ✓ Giao nhận
- ✓ Chủ kỳ

**Master Table**: WasteManagement

---

## 8. QUẢN LÝ KHO

### 8.1 Receipt (Nhập kho) - FR-INV-001
**Chức năng**:
- ✓ Ghi nhận BatchCode, ExpiryDate
- ✓ Direction: 'I' (Inbound)
- ✓ Auto-split: Nếu vượt CapacityKg
- ✓ Stored Procedure: sp_SplitReceiptByCapacity

**Master Table**: FeedLedger, ChemicalLedger

### 8.2 Issue (Xuất kho) - FR-INV-002
**Chức năng**:
- ✓ Direction: 'O' (Outbound)
- ✓ Liên kết: Với CycleID
- ✓ Quy tắc: **FEFO** (First-Expired, First-Out)
- ✓ Stored Procedure: sp_AllocateFEFO

**Thuật toán FEFO**:
1. Lấy available batches
2. Sắp xếp theo ExpiryDate ASC
3. Allocate từng batch theo FIFO
4. Nếu thiếu → Tạo Purchase Order

### 8.3 Stock Real-time - FR-INV-003
**Công thức**:
```
Stock = SUM(Nháp) - SUM(Xuất)
```

**Cảnh báo**:
- HSD sắp hết (< 30 ngày) → WARNING
- HSD < 7 ngày → CRITICAL

**Dashboard**: Tồn kho real-time theo lô

---

## 9. AUTO-GENERATION & SIMULATION

### 9.1 Scenario Input (FR-AUTO-001)
**Khai báo kịch bản**:
- PondID, StartDate, EndDate
- SeedQty, AvgWeightG, FCR
- InvisibleLossRate
- WarehouseID, FeedID
- Seed (for determinism)

**Master Table**: ScenarioInput

### 9.2 Daily Pipeline (FR-AUTO-002)
**10 Steps**: (Đã mô tả ở phần 5.1)

### 9.3 Determinism (FR-AUTO-003)
**Cùng seed → Cùng kết quả**:
- ✓ Lưu manifest: Với seed, version, weather, checksums
- ✓ Verification: sp_VerifyDeterminism
- ✓ 100% reproducible

### 9.4 Replay Mode (FR-AUTO-004)
**Deterministic Replay**:
- ✓ Cùng seed → cùng kết quả 100%
- ✓ Manifest lưu trữ seed, version, weather, checksums
- ✓ So sánh checksum từng ngày
- ✓ Báo cáo "Determinism: PASS ✅" hoặc "FAIL ❌"

**Mục đích**: Kiểm tra tính nhất quán, tái tạo kết quả

### 9.5 Manual Override (FR-AUTO-005)
**Cho phép sửa dữ liệu**:
- ✓ Audit Trail: Tự động log mọi thay đổi
- ✓ Recalculation: Tính lại từ ngày sửa trở đi (FCR, cost, profit)
- ✓ Warning: Báo cáo ghi chú "Override Day X: field_name"
- ✓ Constraints: Max 20% days, Manager+ only

---

## 10. BÁO CÁO & PHÂN TÍCH

### 10.1 Standard Reports (FR-RP-001)
**Báo cáo**:
- Báo cáo tổng hợp ngày/tuần/tháng
- Báo cáo tuân thủ môi trường
- Báo cáo tồn kho FEFO
- Báo cáo sức khỏe & FCR

### 10.2 8 FSIS Forms (FR-RP-002)

| Code | Tên biểu mẫu | Mục đích |
|------|------------|---------|
| **P301-F01** | Nhật ký nuôi (90 dòng) | Daily log |
| **P301-F06** | Biên bản giao nhận TA | Feed delivery |
| **P301-F07** | Sổ theo dõi TA | Feed inventory |
| **P303-F03** | Phiếu giao hàng HC | Chemical delivery |
| **P303-F04** | Sổ theo dõi HC | Chemical inventory |
| **P303-F06** | Phiếu chỉ định sản phẩm | Product spec |
| **P303-F07** | Phiếu theo dõi sức khỏe | Health monitoring |
| **P305-F37** | Sổ giao nhận chất thải | Waste transfer |

### 10.3 Export Formats (FR-RP-003)
- ✓ Excel (XLSX) với EPPlus
- ✓ PDF với iText7
- ✓ Word (DOCX) với OpenXML
- ✓ CSV cho data exchange

**Watermark**: "MOCKED DATA - FOR TRAINING ONLY" (bắt buộc)

---

## 11. BẢO MẬT & AUDIT

### 11.1 Authentication & Authorization
**Login Flow**:
1. Input Username + Password
2. BCrypt Hash Compare (12 rounds)
3. ✅ Match? → Reset FailedAttempts → Create Session
4. ❌ No Match? → Increment FailedAttempts → >= 5? → Lock Account

**RBAC**: Admin, Manager, Staff, Viewer

### 11.2 Audit Trail Implementation
**Auto-logging**:
- TableName, RecordID, Action (INSERT/UPDATE/DELETE)
- OldValues, NewValues (JSON format)
- ChangedFields, UserID, Username
- IPAddress, MachineName
- ActionDate (TIMESTAMP)

**Master Table**: AuditTrail (đặc biệt với DailyLog)

### 11.3 Data Encryption & Password Policy
- ✓ Encrypt sensitive data at rest
- ✓ Min 8 chars, complexity rules
- ✓ Max 5 failed attempts → Lock account
- ✓ Session Timeout: Auto-logout after 30 mins

---

## 12. CẢNH BÁO & MONITORING

### 12.1 Alert Thresholds

#### 🔴 CRITICAL (Phải xử lý trong 1 giờ)

| Condition | Threshold | Action |
|-----------|-----------|--------|
| DO | < 3.0 mg/L | Báo sạch, báт máy sục ngay |
| Mortality | > 5%/day | Liên hệ thú y |
| Temperature | <20°C or >35°C | Thay nước ngay |
| pH | <6.0 or >9.0 | Điều chỉnh pH ngay |
| H2S | > 0.1 mg/L | Vệ sinh đáy ngay |
| NH3 | > 0.5 mg/L | Giảm thức ăn 50% |
| Stock HSD | < 7 days | Đặt hàng bổ sung |

#### 🟡 WARNING (Xử lý trong 24 giờ)

| Condition | Threshold | Action |
|-----------|-----------|--------|
| DO | 3.0-4.0 mg/L | Chuẩn bị báт máy sục |
| Mortality | 2-5%/day | Theo dõi chặt |
| Temperature | 25-28 or 32-35°C | Chuẩn bị thay nước |
| pH | 6.0-6.5 or 8.5-9 | Chuẩn bị điều chỉnh |
| H2S | 0.05-0.1 mg/L | Vệ sinh sơ bộ |
| NH3 | 0.3-0.5 mg/L | Giảm thức ăn 30% |
| FCR | > 2.5 | Kiểm tra thức ăn |
| Stock HSD | < 30 days | Đặt hàng bổ sung |

#### 🔵 INFO (Thông báo thông tin)
- Milestone reached (Day 30, 60, 90)
- Growth rate trend update
- Harvest prediction ready
- Report available
- Daily log completed

### 12.2 Dashboard & KPI Monitoring
**Main Dashboard**:
- 4 KPI cards: Farms, Ponds, Cycles, Daily Logs
- Performance chart: FCR, Survival, Growth
- Alerts & Notifications panel
- Quick Actions menu

---

## 13. CƠ SỞ DỮ LIỆU

### 13.1 Database Schema Overview

#### Master Data Tables (7)
- **Farms**: FarmID, FarmCode, FarmName, Certifications
- **Warehouses**: WarehouseID, CapacityKg, Location
- **Ponds**: PondID, FarmID, Surface area, Depth
- **FeedInventory**: FeedID, Protein%, Supplier
- **ChemicalInventory**: ChemicalID, Type, Purpose
- **EnvRules**: MonthNo, BaseTemp, OptimalDO
- **Users**: UserID, Role (Admin/Manager/Staff/Viewer)

#### Farming Operations Tables (7)
- **FarmingCycles**: CycleID, Status, Seed, Manifest
- **DailyLogs**: LogID, CycleID, Full daily data
- **EnvironmentLogs**: DO, pH, H2S, NH3
- **HealthMonitoring**: Inspection, Parasites, Treatment
- **WaterManagement**: Intake, Outlet, Quality
- **WasteManagement**: Type, Quantity, Disposal
- **Events**: EventType, Status, Chemical usage

#### Inventory Ledgers (3)
- **FeedLedger**: Direction I/O, BatchCode, ExpiryDate
- **ChemicalLedger**: Direction I/O, BatchCode, ExpiryDate
- **ProductSpecification**: Approval workflow

#### Support Tables (6)
- **ScenarioInput**: ScenarioID, Payload JSON
- **JobRunLog**: Status, ExecutionTime
- **AlertLogs**: Level, Category, Message
- **CostTracking**: Daily & Cumulative costs
- **AuditTrail**: Full audit trail
- **DailyReportSummary**: Daily summaries (NEW!)

#### Calendar (1)
- **Calendar**: Holidays, Weekends (full 2025)

### 13.2 Indexes & Performance
**Key Indexes**:
- FarmingCycle: IX_CycleID_Status, IX_StartDate
- DailyLogs: IX_CycleID_Day, IX_Date
- FeedLedger: IX_FeedLedger_ExpiryDirection (INCLUDE)
- ChemicalLedger: IX_ChemicalLedger_ApprovalStatus
- AlertLogs: IX_AlertLog_CycleID_Level, IX_AlertLog_Status

### 13.3 Stored Procedures (6)
1. **sp_GenerateDailyLogs** (NEW!): Pipeline orchestrator
2. **sp_CalculateCycleStats** (NEW!): Statistics calculation
3. **sp_AllocateFEFO**: FEFO logic
4. **sp_SplitReceiptByCapacity**: Warehouse capacity
5. **sp_VerifyDeterminism**: Checksum verification
6. (Additional performance-critical procedures)

### 13.4 Triggers (2)
1. **trg_AuditDailyLog** (NEW!): Auto audit trail on DailyLog changes
2. **trg_UpdateCycleLastDay** (NEW!): Track progress

---

## 📊 PERFORMANCE BENCHMARKS

| Operation | Records | Time Target |
|-----------|---------|-------------|
| Generate 90 Days | 1 cycle | 5-8 sec (EF) / 1-2 sec (SP) |
| FEFO Allocation | 1000 | 200ms (EF) / 50ms (SP) |
| Report Export | 90 days | 1-3 sec |
| Query 10,000 records | 10k | 800ms (EF) / 200ms (SP) |
| Calculate Stock | 1 product | 150ms (EF) / 50ms (SP) |

---

## 🎯 KEY FEATURES SUMMARY

| Chức năng | Mô tả | Status |
|---------|-------|--------|
| **Master Data Management** | Farms, Ponds, Warehouses, Products | ✅ Complete |
| **Farming Cycle Management** | 90-day automated cycles | ✅ Complete |
| **11 Simulation Engines** | Growth, Mortality, Feed, etc. | ✅ Complete |
| **Daily Pipeline (10 Steps)** | Automated daily data generation | ✅ Complete |
| **FEFO Inventory** | First-Expired, First-Out algorithm | ✅ Complete |
| **Deterministic Simulation** | Same seed = same result | ✅ Complete |
| **Replay Mode** | Verify simulation consistency | ✅ Complete |
| **Manual Override** | Edit generated data with audit | ✅ Complete |
| **8 FSIS Forms** | Standard compliance forms | ✅ Complete |
| **Export Formats** | Excel, PDF, Word, CSV | ✅ Complete |
| **Audit Trail** | Full change tracking | ✅ Complete |
| **Alert System** | CRITICAL, WARNING, INFO levels | ✅ Complete |
| **Cost Tracking** | Daily & cumulative costs | ✅ Complete |
| **Role-Based Access** | Admin, Manager, Staff, Viewer | ✅ Complete |
| **Dashboard & KPIs** | Real-time monitoring | ✅ Complete |
| **Water Quality Tracking** | DO, pH, H2S, NH3 monitoring | ✅ Complete |
| **Health Monitoring** | Disease & parasite tracking | ✅ Complete |
| **Waste Management** | Disposal tracking & compliance | ✅ Complete |

---

## 🚀 TRIỂN KHAI

### Timeline (14 tuần = 3.5 tháng)
- **Phase 1**: Database Setup (Week 1-2)
- **Phase 2**: Backend Development (Week 3-8)
- **Phase 3**: Frontend Development (Week 9-10)
- **Phase 4**: Testing & Deployment (Week 11-12)
- **Phase 5**: Report Generation (Week 13)
- **Phase 6**: Advanced Features (Week 14)

### Tech Stack
- Frontend: Windows Forms (.NET 9.0)
- Backend: C# 13
- Database: SQL Server 2019+
- ORM: Entity Framework Core 9.0
- Export: EPPlus, iText7, OpenXML
- Logging: Serilog
- Authentication: BCrypt

---

## ⚠️ WATERMARK REQUIREMENT

**TẤT CẢ BÁO CÁO PHẢI CÓ**:
```
"MOCKED DATA - FOR TRAINING ONLY"
```

**Được sử dụng cho**:
- ✅ Đào tạo nhân viên
- ✅ Test tính năng hệ thống
- ✅ Demo cho khách hàng (với watermark)

**KHÔNG được sử dụng cho**:
- ❌ Báo cáo chính thức
- ❌ Kiểm định/chứng nhận
- ❌ Xóa watermark
- ❌ Thay thế dữ liệu thực tế

---

## 📝 DOCUMENT METADATA

| Property | Value |
|----------|-------|
| **Document ID** | CHUC_NANG_CHI_TIET_v4.0 |
| **Version** | 4.0 Consolidated Complete |
| **Date** | 07/11/2025 |
| **Status** | ✅ APPROVED |
| **Total Functions** | 50+ |
| **Total Tables** | 25+ |
| **Total Stored Procedures** | 6+ |
| **Total Triggers** | 2+ |

---

## 📞 CONTACT & SUPPORT

**Technical Support**:
- Email: support@aquasim.vn
- Phone: (028) 3-XXXX-XXXX
- Hours: Mon-Fri 8:00-17:00

**Training**:
- Email: training@aquasim.vn
- Duration: 2-4 hours
- Topics: Basic usage, Reports, Admin

---

**🎉 END OF DOCUMENT**

⚠️ **CONFIDENTIAL** - For authorized personnel only  
© 2025 AquaSim System. All rights reserved.

---

*Tài liệu này là tóm tắt toàn diện của tất cả chức năng trong hệ thống AquaSim v4.0*  
*Dựa trên 3 tài liệu chính: SRS, Architecture, và Database Updates*

