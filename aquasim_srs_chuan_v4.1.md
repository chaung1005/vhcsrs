# TÀI LIỆU ĐẶC TÃ YÊUTẦUCÂU PHẦN MỀM (SRS FINAL)
## Hệ thống AquaSim - Quản lý Trang trại Nuôi Thủy sản Tự động
### Phiên bản: 4.0 Consolidated (Hệ thống & Loại trùng)
### Ngày: 06/11/2025

---

## MỤC LỤC

1. [TÓM TẮT ĐIỀU HÀNH (Executive Summary)](#tóm-tắt-điều-hành)
2. [PHÂN TÍCH TRÙNG LẶP & THAY ĐỔI](#phân-tích-trùng-lặp)
3. [TỔNG QUAN DỰ ÁN](#tổng-quan-dự-án)
4. [KIẾN TRÚC HỆ THỐNG](#kiến-trúc-hệ-thống)
5. [YÊUCẦU CHỨC NĂNG (FUNCTIONAL)](#yêucầu-chức-năng)
6. [YÊUCẦU PHI CHỨC NĂNG (NON-FUNCTIONAL)](#yêucầu-phi-chức-năng)
7. [MÔ HÌNH DỮ LIỆU & DATABASE](#mô-hình-dữ-liệu)
8. [CÔNG THỨC & THUẬT TOÁN (UNIFIED)](#công-thức--thuật-toán)
9. [QUY TRÌNH NGHIỆP VỤ](#quy-trình-nghiệp-vụ)
10. [GIAO DIỆN & BÁO CÁO](#giao-diện-báo-cáo)
11. [SECURITY & AUDIT](#security--audit)
12. [TESTING & PERFORMANCE](#testing--performance)
13. [TRIỂN KHAI & MIGRATION](#triển-khai--migration)
14. [PHỤ LỤC](#phụ-lục)

---

## TÓM TẮT ĐIỀU HÀNH

### Vấn đề hiện tại
- ✗ Excel tả các quy trình → Không đồng bộ, dễ lỗi
- ✗ Theo dõi thủ công → Tốn thời gian, sai sót
- ✗ Báo cáo không chuẩn → Không đạt tiêu chuẩn FSIS

### Giải pháp AquaSim
- ✅ **Tự động hóa 100%** chu kỳ nuôi (90 ngày)
- ✅ **Sinh dữ liệu thông minh** từ 1 form input
- ✅ **Quản lý FEFO** kho thức ăn & hóa chất
- ✅ **Xuất chuẩn FSIS** 8 biểu mẫu
- ✅ **Deterministic simulation** (cùng seed = cùng kết quả)

### KPIs chính
| Chỉ số | Target | Hiện tại | Cải thiện |
|--------|--------|---------|----------|
| Ngày input | 90 ngày | 1 day | **99%** |
| FCR (Feed Conversion) | < 2.0 | 2.3 | **13%** |
| Survival Rate | > 85% | 82% | **3%** |
| Báo cáo chuẩn | 8/8 | 2/8 | **300%** |
| Compliance | 100% | 60% | **67%** |

---

## PHÂN TÍCH TRÙNG LẶP

### 1. Phần lặp lại & được giữ lại

#### ✓ Giữ lại (Lần 1 xuất hiện)
- **Section 3.2 (FR-OP-001)**: Fish Stocking định nghĩa
- **Section 3.4 (FR-GEN-002)**: Daily Pipeline 10 bước (chi tiết nhất)
- **Section 5.2-5.3**: Database Schema đầy đủ
- **Section 6.1-6.7**: Công thức đầy đủ (8 công thức)
- **Section 7.2**: Quy trình Auto-Generate (flow chart)

#### ✗ Loại bỏ (Lặp lại từ Phần bổ sung)
- **Định nghĩa lại Cost Tracking** (giữ v4.0)
- **Định nghĩa lại Alert Log** (giữ v4.0)
- **Định nghĩa lại ProductSpecification** (giữ v4.0)
- **Định nghĩa lại Audit Trail** (giữ v4.0 - chi tiết hơn)

### 2. Thông tin loại bỏ (99% trùng)
- **Role definitions**: Giữ RBAC từ section 3 (Admin/Manager/Staff/Viewer)
- **Test case P301-F01**: Chỉ giữ 1 bản, xóa sample thứ 2
- **Tech Stack table**: Gộp từ cả 2 nơi
- **UI Menu structure**: 1 bản duy nhất
- **Stored Procedures list**: Gộp & sắp xếp

### 3. Cập nhật & sắp xếp logic
- **Công thức**: Sắp xếp theo dependency (Growth → Mortality → Feed)
- **Database**: Hợp nhất core + extended tables
- **Security**: Unified authentication + RBAC + Audit
- **Testing**: Unit + Integration + Performance

---

## TỔNG QUAN DỰ ÁN

### 1.1 Giới thiệu AquaSim

**AquaSim** là hệ thống quản lý trang trại nuôi thủy sản toàn diện, được thiết kế để:

| Mục tiêu | Chi tiết |
|----------|----------|
| **Tự động hóa** | Quy trình sinh dữ liệu toàn chu kỳ 90 ngày |
| **Thay thế Excel** | Các quy trình theo dõi thủ công |
| **Chuẩn hóa báo cáo** | Theo tiêu chuẩn FSIS (8 form) |
| **Hỗ trợ** | Mô phỏng và dự báo cho mục đích đào tạo |
| **Deterministic** | Cùng seed → cùng kết quả (reproducible) |

### 1.2 Phạm vi toàn diện

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
- Receipt (Nháp kho) with auto-split by capacity
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

### 1.3 Định nghĩa & Thuật ngữ

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

## KIẾN TRÚC HỆ THỐNG

### 2.1 Kiến trúc tổng thể

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                           │
│         Windows Forms (.NET 9.0) + Designer                     │
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                 BUSINESS LOGIC LAYER (BLL)                      │
│                     C# .NET 9.0                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │           11 SIMULATION ENGINES + SERVICES             │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ➤ EnvironmentGenerator    ➤ MortalityEngine             │   │
│  │ ➤ GrowthEngine           ➤ FeedPlanner                │   │
│  │ ➤ ChemicalEngine         ➤ WaterOpsEngine            │   │
│  │ ➤ InventoryEngine        ➤ CostTracker               │   │
│  │ ➤ AlertSystem            ➤ ValidationService         │   │
│  │ ➤ ReportingEngine                                      │   │
│  └─────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                   DATA ACCESS LAYER (DAL)                       │
│          Entity Framework Core 9.0 + Stored Procedures          │
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                    SQL SERVER 2019+                             │
│          (Bắt buộc dùng Stored Procedures)                      │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Chiến lược Database-First

- ✅ **Cơ sở dữ liệu SQL Server** là nguồn sự thật duy nhất; schema được quản lý trực tiếp trên DB.
- ✅ **Entity Framework Core** chỉ dùng ở chế độ Database-First (scaffold từ DB, không tạo migration để build schema).
- ✅ **Thay đổi schema** phải thực hiện trên DB trước, sau đó regenerate model/service để đồng bộ mã nguồn.
- ✅ **Stored procedures, view** và các ràng buộc được bảo toàn và ưu tiên tái sử dụng từ DB hiện hữu.
- ℹ️ Hiện tại dự án đang chạy với cơ sở dữ liệu `aquasim_VHC` (SQL Server 2019+) theo mô hình Database-First.

#### Quy trình đồng bộ model khi thay đổi schema

1. Thực hiện chỉnh sửa trực tiếp trên cơ sở dữ liệu `aquasim_VHC` (DDL, stored procedure, view...).
2. Từ thư mục `AquaSim.Models`, chạy lệnh scaffold ví dụ:
   ```powershell
   dotnet ef dbcontext scaffold "Server=tcp:172.17.254.222,1433;Database=aquasim_VHC;User Id=mhkpi;Password=Try@VhcQAZXCV;Encrypt=false;TrustServerCertificate=true;" Microsoft.EntityFrameworkCore.SqlServer \
       --context AquaSimDbContext \
       --output-dir . \
       --force \
       --no-pluralize
   ```
3. Kiểm tra và commit các file model mới, đảm bảo không ghi đè các file tùy chỉnh ngoài Models/.
4. Build lại giải pháp và chạy smoke test để chắc chắn các thay đổi hoạt động.

### 2.2 Tech Stack Đầy đủ

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

## YÊUCẦU CHỨC NĂNG

### 3.1 Master Data Management (FR-MDM)

#### FR-MDM-001: Farm Management
- **CRUD Operations**: Thêm, sửa, xóa thông tin farm
- **Lưu trữ**: Tên, địa chỉ, tòa độ, chứng nhận (ASC, BAP, GG)
- **Phạm vi**: Quản lý vùng/khu vực
- **Cấu hình**: Tham số riêng (giới hạn nước, aeration lagoon)

#### FR-MDM-002: Pond Management
- **CRUD Operations**: Thêm, sửa, xóa thông tin ao
- **Lưu trữ**: Diện tích, độ sâu, dung tích, loại ao
- **Theo dõi**: Ngày chuẩn bị, phương pháp chuẩn bị
- **Mực nước**: 5 level tùy chỉnh

#### FR-MDM-003: Warehouse Management
- **CRUD Operations**: Thêm, sửa, xóa kho
- **Lưu trữ**: Tên, mã, sức chứa tối đa (CapacityKg)
- **Điều kiện**: Theo dõi điều kiện lưu kho
- **Real-time**: Giám sát mức tồn kho

#### FR-MDM-004: Product Management
- **Feed Inventory**: Loại thức ăn, protein %, quy cách
- **Chemical Inventory**: Hóa chất, nồng độ, quy cách
- **Thông tin**: Nhà sản xuất, HSD, giá
- **Phân loại**: Feed, Chemical, Supplement, Environment

#### FR-MDM-005: User & Role Management
- **Tạo/Quản lý**: Tài khoản người dùng
- **Roles**: Admin, Manager, Staff, Viewer
- **Audit Trail**: Log mỗi thao tác
- **Phạm vi**: Trách nhiệm theo thời gian

---

### 3.2 Operational Management (FR-OPS)

#### FR-OPS-001: Fish Stocking
- **Ghi nhận**: Nguồn giống, chất lượng
- **Theo dõi**: Mật độ, số lượng thả
- **Thông tin**: Tuổi, kích cỡ fingerling
- **Sản lượng**: Kỳ vọng theo ao

#### FR-OPS-002: Farming Cycle (90 ngày)
- **Khởi tạo**: Với thông số đầu vào (StartDate, SeedQty, FCR, etc.)
- **Trạng thái**: PLANNING → ACTIVE → MEDICATING → HARVESTING → CLOSED
- **Theo dõi**: FCR, tỷ lệ chết, growth curve
- **Chi tiết**: 90 ngày dữ liệu

#### FR-OPS-003: Daily Logs
- **Ghi nhận hàng ngày**: Thức ăn, cá chết, pH, DO, nhiệt độ
- **Sinh khối & TLBQ**: Tính toán tự động
- **Ghi chú**: Sự kiện đặc biệt
- **Form**: Tham chiếu P301-F01

#### FR-OPS-004: Health Monitoring
- **TLBQ & Bệnh**: Kỳ sinh trùng, dấu hiệu lâm sàng
- **Hao hụt**: Tỷ lệ hao hụt theo ao
- **Điều trị**: Ghi nhận & hiệu quả
- **Form**: Tham chiếu P303-F07

#### FR-OPS-005: Water Management
- **Cấp/Thoát**: Lượng nước (m³)
- **Giám sát**: DO, pH, H2S, NH3
- **Lịch thay**: Theo chu kỳ
- **Form**: Tham chiếu P304-F04

#### FR-OPS-006: Waste Management
- **Loại & Số lượng**: Cháy thải
- **Xử lý**: Phương pháp xử lý
- **Giao nhận**: Chủ kỳ
- **Form**: Tham chiếu P305-F37

---

### 3.3 Inventory Management (FR-INV)

#### FR-INV-001: Receipt (Nháp kho)
- **Ghi nhận**: BatchCode, ExpiryDate
- **Direction**: 'I' (Inbound)
- **Auto-split**: Nếu vượt CapacityKg
- **Stored Procedure**: sp_SplitReceiptByCapacity

#### FR-INV-002: Issue (Xuất kho) - FEFO
- **Direction**: 'O' (Outbound)
- **Liên kết**: Với CycleID
- **Quy tắc**: FEFO (First-Expired, First-Out)
- **Stored Procedure**: sp_AllocateFEFO

#### FR-INV-003: Stock Real-time
- **Công thức**: Stock = SUM(Nháp) - SUM(Xuất)
- **Cảnh báo**: HSD sắp hết (< 30 ngày)
- **Báo cáo**: Theo lô, theo HSD
- **Dashboard**: Tồn kho real-time

---

### 3.4 Auto-Generator & Simulation (FR-AUTO)

#### FR-AUTO-001: Scenario Input
```
Khai báo kịch bản với tham số:
- PondID, StartDate, EndDate
- SeedQty, AvgWeightG, FCR, InvisibleLossRate
- WarehouseID, FeedID
- Seed (for determinism)
```

#### FR-AUTO-002: Daily Pipeline (10 Steps)
```
Thực hiện tuần tự mỗi ngày:

1️⃣  WEATHER ANCHOR
   → Nhiệt độ từ baseline data

2️⃣  GROWTH ENGINE
   → TLBQ = TLBQ_trước + Tăng trưởng (điều chỉnh)

3️⃣  ENVIRONMENT GENERATOR
   → DO, pH, H2S, NH3 theo công thức + random

4️⃣  MORTALITY ENGINE
   → Cá chết (random ±20%), Tỷ lệ sống

5️⃣  FEED PLANNER
   → Sinh khối → Thức ăn (làm tròn, check ±50%)

6️⃣  CHEMICALS ENGINE
   → Xác định hóa chất theo quy tắc

7️⃣  WATER EXCHANGE
   → Tần suất thay nước theo tháng

8️⃣  INVENTORY SYNTHESIZER
   → FEFO xuất kho TA/HC

9️⃣  DAILY LOG SAVE
   → Lưu vào DailyLogs table

🔟 FORM FILLER
   → Chuẩn bị dữ liệu cho 8 biểu mẫu
```

#### FR-AUTO-003: Determinism
- **Cùng seed** → Cùng kết quả
- **Lưu manifest**: Với seed, version, checksum
- **Verification**: sp_VerifyDeterminism

#### FR-AUTO-004: Replay Mode (Tái Sinh Dữ Liệu)
- **Deterministic**: Cùng seed → cùng kết quả 100%
- **Manifest**: Lưu trữ seed, version, weather, checksums
- **Quy trình**:
  1. Tìm Manifest của chu kỳ cũ
  2. Nhấn "Replay"
  3. Hệ thống tái sinh y hệt (cùng seed, version, weather)
  4. So sánh checksum từng ngày
  5. Báo cáo "Determinism: PASS ✅" hoặc "FAIL ❌"
- **Mục đích**: Kiểm tra tính nhất quán, tái tạo kết quả

#### FR-AUTO-005: Manual Override
- **Chức năng**: Cho phép sửa dữ liệu từng ngày sau khi sinh
- **Audit Trail**: Tự động log mọi thay đổi
  - Ngày
  - Trường (field_name)
  - Giá trị cũ → Giá trị mới
  - Người sửa (user email)
  - Timestamp
- **Recalculation**: Tự động tính lại từ ngày sửa trở đi (FCR, cost, profit)
- **Warning**: Báo cáo ghi chú "Override Day X: field_name"
- **Ràng buộc**: 
  - Không cho sửa quá 20% tổng số ngày
  - Phải có lý do sửa đổi
  - Chỉ user có quyền Manager+ mới được sửa

---

### 3.5 Workflow & Approval (FR-WF)

#### FR-WF-001: Product Specification Approval
- **Form**: P303-F06 (Phiếu chỉ định sản phẩm)
- **Quy trình**: Draft → Pending → Approved/Rejected
- **Trách nhiệm**: Người đề nghị, Quản lý duyệt

#### FR-WF-002: Waste Transfer Approval
- **Form**: P305-F37 (Sổ giao nhận chất thải)
- **Ký**: Người giao + Người nhận
- **Timestamp**: Ghi chép thời gian + audit trail

---

### 3.6 Reporting & Analytics (FR-RP)

#### FR-RP-001: Standard Reports
- Báo cáo tổng hợp ngày/tuần/tháng
- Báo cáo tuân thủ môi trường
- Báo cáo tồn kho FEFO
- Báo cáo sức khỏe & FCR

#### FR-RP-002: 8 FSIS Forms
| Code | Tên biểu mẫu | Mục đích |
|------|------------|---------|
| P301-F01 | Nhat ky nuoi (90 dong) | Daily log |
| P301-F06 | Bien ban giao nhan TA | Feed delivery |
| P301-F07 | So theo doi TA | Feed inventory |
| P303-F03 | Phieu giao hang HC | Chemical delivery |
| P303-F04 | So theo doi HC | Chemical inventory |
| P303-F06 | Phieu chi dinh san pham | Product spec |
| P303-F07 | Phieu theo doi suc khoe | Health monitoring |
| P305-F37 | So giao nhan chat thai | Waste transfer |

#### FR-RP-003: Export Formats
- Excel (XLSX) với EPPlus
- PDF với iText7
- Word (DOCX) với OpenXML
- CSV cho data exchange

---

## YÊUCẦU PHI CHỨC NĂNG

### 4.1 Hiệu năng (NFR-PERF)

| ID | Yêu cầu | Tiêu chuẩn |
|----|---------|-----------|
| NFR-PERF-001 | CRUD response | ≤ 2 giây |
| NFR-PERF-002 | Query 10,000 records | ≤ 1 giây |
| NFR-PERF-003 | Auto-Generate 365 ngày × 1000 ao | < 30 giây |
| NFR-PERF-004 | Export báo cáo | ≤ 10 giây |
| NFR-PERF-005 | Concurrent users | 50 users |

### 4.2 Bảo mật (NFR-SEC)

| ID | Yêu cầu | Chi tiết |
|----|---------|---------|
| NFR-SEC-001 | Authentication | Username/Password with BCrypt hash |
| NFR-SEC-002 | Authorization | Role-Based Access Control (RBAC) |
| NFR-SEC-003 | Audit Trail | Log mỗi thay đổi dữ liệu |
| NFR-SEC-004 | Data Encryption | Encrypt sensitive data at rest |
| NFR-SEC-005 | Password Policy | Min 8 chars, complexity rules |
| NFR-SEC-006 | Login Protection | Max 5 failed attempts → Lock account |
| NFR-SEC-007 | Session Timeout | Auto-logout after 30 mins |

### 4.3 Độ tin cậy (NFR-REL)

| ID | Yêu cầu | Tiêu chuẩn |
|----|---------|-----------|
| NFR-REL-001 | System Availability | ≥ 99.5% |
| NFR-REL-002 | Data Integrity | Transaction with rollback |
| NFR-REL-003 | Backup | Daily automatic backup |
| NFR-REL-004 | Recovery | Point-in-time recovery (30 days) |
| NFR-REL-005 | Network Issues | Graceful handling |

### 4.4 Khả năng sử dụng (NFR-USAB)

| ID | Yêu cầu | Chi tiết |
|----|---------|---------|
| NFR-USAB-001 | UI Design | Trực quan, nhất quán |
| NFR-USAB-002 | Language | Tiếng Việt + Tiếng Anh |
| NFR-USAB-003 | Help System | Context-sensitive help |
| NFR-USAB-004 | Training | < 2 giờ đào tạo |
| NFR-USAB-005 | Excel-like | Giống Excel hiện tại |

### 4.5 Khả năng mở rộng (NFR-SCALE)

| ID | Yêu cầu | Capacity |
|----|---------|----------|
| NFR-SCALE-001 | Farms | Tới 100 farms |
| NFR-SCALE-002 | Ponds | Tới 1000 ponds |
| NFR-SCALE-003 | Historical Data | 5 năm |
| NFR-SCALE-004 | Database | Partitioning support |
| NFR-SCALE-005 | Modular Design | Plugin architecture |

---

## MÔ HÌNH DỮ LIỆU

### 5.1 Entity Relationship Diagram (ERD) - Consolidated

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

### 5.2 Core Tables

#### Table: Farms
```sql
CREATE TABLE Farms (
    FarmID INT PRIMARY KEY IDENTITY(1,1),
    FarmCode NVARCHAR(50) UNIQUE NOT NULL,
    FarmName NVARCHAR(100) NOT NULL,
    ShortName NVARCHAR(50),
    Address NVARCHAR(255),
    Phone NVARCHAR(20),
    Manager NVARCHAR(100),
    ASC BIT DEFAULT 0,
    BAP BIT DEFAULT 0,
    GG BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmCode (FarmCode)
);
```

#### Table: Ponds
```sql
CREATE TABLE Ponds (
    PondID INT PRIMARY KEY IDENTITY(1,1),
    PondCode NVARCHAR(50) UNIQUE NOT NULL,
    FarmID INT FOREIGN KEY REFERENCES Farms(FarmID) ON DELETE CASCADE,
    PondName NVARCHAR(100),
    Area DECIMAL(10,2),
    WaterSurfaceArea DECIMAL(10,2),
    Depth DECIMAL(5,2),
    MaxIntakeWater DECIMAL(10,2),
    MaxDischargeWater DECIMAL(10,2),
    WaterChangeLevel1 DECIMAL(10,2),
    WaterChangeLevel2 DECIMAL(10,2),
    WaterChangeLevel3 DECIMAL(10,2),
    WaterChangeLevel4 DECIMAL(10,2),
    WaterChangeLevel5 DECIMAL(10,2),
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME DEFAULT GETDATE(),
    INDEX IX_FarmID (FarmID),
    INDEX IX_PondCode (PondCode)
);
```

#### Table: FarmingCycles
```sql
CREATE TABLE FarmingCycles (
    CycleID INT PRIMARY KEY IDENTITY(1,1),
    PondID INT FOREIGN KEY REFERENCES Ponds(PondID) ON DELETE CASCADE,
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
    Manifest NVARCHAR(MAX) NULL,
    
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_CycleID_Status (CycleID, Status),
    INDEX IX_StartDate (StartDate DESC)
);
```

#### Table: DailyLogs
```sql
CREATE TABLE DailyLogs (
    LogID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT FOREIGN KEY REFERENCES FarmingCycles(CycleID),
    DayNumber INT NOT NULL,
    Date DATETIME NOT NULL,
    
    -- Environment
    TempAM FLOAT,
    TempPM FLOAT,
    DOmin FLOAT,
    DOmax FLOAT,
    pH_AM FLOAT,
    pH_PM FLOAT,
    H2S FLOAT,
    NH3 FLOAT,
    
    -- Biology
    FishCount INT,
    AvgWeightGr FLOAT,
    BiomassKg FLOAT,
    DeadCount INT,
    SurvivalRate FLOAT,
    
    -- Feed
    FeedKg FLOAT,
    FeedType NVARCHAR(50),
    FCR FLOAT,
    
    -- Chemical
    ChemicalUsed NVARCHAR(200),
    ChemicalCost DECIMAL(10,2),
    
    -- Water
    WaterIntakeM3 FLOAT,
    WaterDischargeM3 FLOAT,
    
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_CycleID_Day (CycleID, DayNumber),
    INDEX IX_Date (Date DESC)
);
```

#### Table: EnvironmentLogs
```sql
CREATE TABLE EnvironmentLogs (
    EnvLogID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT FOREIGN KEY REFERENCES FarmingCycles(CycleID),
    DayNo INT,
    Temp_C FLOAT,
    DO_mgL FLOAT,
    pH FLOAT,
    H2S_mgL FLOAT,
    NH3_mgL FLOAT,
    Salinity_ppt FLOAT,
    Turbidity_cm INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_EnvLog_CycleID_Day (CycleID, DayNo)
);
```

#### Table: InventoryLedger (Unified)
```sql
CREATE TABLE InventoryLedger (
    LedgerID BIGINT PRIMARY KEY IDENTITY(1,1),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    ProductID INT, -- FeedID or ChemicalID
    ProductType NVARCHAR(20), -- 'FEED' or 'CHEMICAL'
    Direction CHAR(1) CHECK (Direction IN ('I', 'O')), -- Inbound/Outbound
    TransactionDate DATETIME NOT NULL,
    BatchCode NVARCHAR(50),
    ExpiryDate DATETIME,
    QuantityKg DECIMAL(12,3) NOT NULL,
    UnitPrice DECIMAL(10,2),
    TotalCost DECIMAL(15,2),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    Notes NVARCHAR(500),
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedDate DATETIME DEFAULT GETDATE(),
    INDEX IX_Ledger_Warehouse_Product (WarehouseID, ProductID),
    INDEX IX_Ledger_ExpiryDate (ExpiryDate),
    INDEX IX_Ledger_CycleID (CycleID),
    INDEX IX_Ledger_Date (TransactionDate DESC)
);
```

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

#### Table: AlertLogs
```sql
CREATE TABLE AlertLogs (
    AlertID BIGINT PRIMARY KEY IDENTITY(1,1),
    CycleID INT FOREIGN KEY REFERENCES FarmingCycles(CycleID),
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
    INDEX IX_AlertLog_Status (Status)
);
```

#### Table: AuditTrail
```sql
CREATE TABLE AuditTrail (
    AuditID BIGINT PRIMARY KEY IDENTITY(1,1),
    TableName NVARCHAR(100) NOT NULL,
    RecordID INT,
    Action NVARCHAR(20) CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),
    OldValues NVARCHAR(MAX), -- JSON format
    NewValues NVARCHAR(MAX), -- JSON format
    ChangedFields NVARCHAR(1000),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Username NVARCHAR(100),
    IPAddress NVARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE(),
    INDEX IX_AuditTrail_TableName_Record (TableName, RecordID),
    INDEX IX_AuditTrail_UserID (UserID),
    INDEX IX_AuditTrail_Date (ActionDate DESC)
);
```

---

## CÔNG THỨC & THUẬT TOÁN

### 6.1 Công thức Sinh khối (Biomass)

```
📌 SINH KHỐI (kg)
Sinh_khối = (Số_cá × TLBQ) / 1000

Trong đó:
- Số_cá: Số lượng cá hiện tại (con)
- TLBQ: Trọng lượng bình quân (g/con)
```

### 6.2 Công thức Tăng trưởng (Growth Rate)

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

### 6.3 Công thức Tỷ lệ chết (Mortality Rate)

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

⚙️ HỆ SỐ BỆNH:
- Vibrio: × 3-5
- Stress pH/DO: × 2-3
- Thiếu oxy (DO<2): × 5-10
```

### 6.4 Công thức Thức ăn (Feed Allocation)

```
📌 LƯỢNG THỨC ĂN (kg/ngày)
Base_%BW = GetBaseFeeding(TLBQ, Age)
Adjusted_%BW = Base_%BW × Hệ_số_điều_chỉnh
Thức_ăn = (Sinh_khối × Adjusted_%BW) / 100

📊 Base %BW theo kích cỡ:
┌────────────────┬──────────────┬──────────────┐
│ Kích cỡ        │ Tuổi         │ %BW/ngày     │
├────────────────┼──────────────┼──────────────┤
│ < 50g          │ 0-10 ngày    │ 5-7%         │
│ 50-150g        │ 11-30 ngày   │ 3-5%         │
│ 150-300g       │ 31-60 ngày   │ 2-3%         │
│ > 300g         │ 61+ ngày     │ 1.5-2%       │
└────────────────┴──────────────┴──────────────┘

⚙️ ĐIỀU CHỈNH:
- Đang dùng thuốc: × 0.5
- DO < 4: × 0.6
- pH ngoài range: × 0.7
- Có bệnh: × 0.5-0.8
- Rằng buộc: ±50% so với ngày trước
```

### 6.5 Công thức FCR (Feed Conversion Ratio)

```
📌 FCR
FCR = Tổng_thức_ăn_tích_lũy / Tổng_sinh_khối_tích_lũy

TIÊU CHUẨN:
- 1.5-2.0: Tốt ✅
- 2.0-2.5: Bình thường ✅
- > 2.5: Cảnh báo 🟡
- > 3.0: Nguy hiểm 🔴
```

### 6.6 Công thức Chất lượng nước

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

### 6.7 Thuật toán FEFO (First-Expired, First-Out)

```csharp
public class FEFOAlgorithm
{
    public List<InventoryIssue> AllocateByFEFO(
        int warehouseId, 
        int productId, 
        decimal requiredQtyKg,
        DateTime asOfDate)
    {
        var issues = new List<InventoryIssue>();
        var remaining = requiredQtyKg;
        
        // 1. Lấy available batches, sắp xếp theo ExpiryDate ASC
        var batches = GetAvailableBatches(warehouseId, productId, asOfDate)
            .OrderBy(b => b.ExpiryDate)      // FEFO: earliest expiry first
            .ThenBy(b => b.ReceivedDate)     // Then by received date
            .ToList();
        
        // 2. Duyệt qua batches
        foreach (var batch in batches)
        {
            if (remaining <= 0) break;
            
            var toIssue = Math.Min(batch.AvailableQty, remaining);
            
            issues.Add(new InventoryIssue
            {
                BatchCode = batch.BatchCode,
                QuantityKg = toIssue,
                ExpiryDate = batch.ExpiryDate,
                UnitPrice = batch.UnitPrice,
                TotalCost = toIssue * batch.UnitPrice
            });
            
            remaining -= toIssue;
        }
        
        // 3. Nếu còn thiếu → Tạo Purchase Order
        if (remaining > 0)
        {
            CreatePurchaseOrder(productId, remaining, 
                purchaseUrgency: "HIGH");
        }
        
        return issues;
    }
}
```

### 6.8 Thuật toán Auto-Split Receipt

```csharp
public class ReceiptSplitter
{
    public List<ReceiptEntry> SplitByCapacity(
        int warehouseId,
        decimal totalQtyKg,
        int batchSize = 50) // Mặc định 50kg/batch
    {
        var entries = new List<ReceiptEntry>();
        var warehouse = GetWarehouse(warehouseId);
        
        // Nếu không có giới hạn → 1 entry
        if (warehouse.CapacityKg == 0 || warehouse.CapacityKg >= totalQtyKg)
        {
            entries.Add(new ReceiptEntry 
            { 
                QuantityKg = totalQtyKg,
                AllocationSlot = 1 
            });
            return entries;
        }
        
        // Chia nhỏ theo capacity
        var allocatedQty = 0m;
        var slotNumber = 1;
        
        while (allocatedQty < totalQtyKg)
        {
            var qtyThisSlot = Math.Min(
                warehouse.CapacityKg,
                totalQtyKg - allocatedQty
            );
            
            entries.Add(new ReceiptEntry
            {
                QuantityKg = qtyThisSlot,
                AllocationSlot = slotNumber
            });
            
            allocatedQty += qtyThisSlot;
            slotNumber++;
        }
        
        return entries;
    }
}
```

### 6.9 Cost Calculation Logic

#### Electricity Cost
```csharp
// Aerator: 1.5 kW, 3000 VND/kWh
decimal aeratorCost = aeratorHours * 1.5m * 3000;

// Water pump: 2.0 kW
decimal pumpCost = (waterInM3 / 100) * 2.0m * 3000;

ElectricityCost = aeratorCost + pumpCost;
```

#### Labor Cost (with Stress Multiplier)
```csharp
decimal baseLaborCost = 150000; // VND/day

// Increase during medication & harvesting
if (cycle.IsMedicatingToday) 
    baseLaborCost *= 1.5m;
    
if (cycle.Status == "HARVESTING") 
    baseLaborCost *= 2.0m;

return baseLaborCost;
```

---

## QUY TRÌNH NGHIỆP VỤ

### 7.1 Quy trình Daily Pipeline (10 Steps)

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

### 7.2 Quy trình Khởi tạo Chu kỳ Nuôi

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

### 7.3 Workflow Duyệt Sản phẩm

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

### 7.4 Use Case: Replay Mode (Tái Sinh Dữ Liệu)

**Actor**: Data Officer

**Mục đích**: Kiểm tra tính deterministic của hệ thống, tái tạo kết quả

**Quy trình**:
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

### 7.5 Use Case: Manual Override

**Actor**: Data Officer/Manager

**Mục đích**: Điều chỉnh dữ liệu sinh tự động khi cần thiết

**Quy trình**:
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
├─ Recalculate từ Day 15 trở đi:
│  ├─ Fish count
│  ├─ Biomass
│  ├─ FCR cumulative
│  ├─ Cost cumulative
│  └─ Profit forecast
├─ Add watermark to reports:
│  "⚠️ Override Day 15: mortality_count"
└─ Update checksums

CONSTRAINTS:
├─ Maximum 20% days can be overridden
├─ Must provide reason for change
├─ Only Manager+ role allowed
└─ Cannot override if cycle is COMPLETED
```

---

## GIAO DIỆN & BÁO CÁO

### 8.1 Main Dashboard

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

### 8.2 Menu Structure

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
├─ Receipt (Nháp kho)
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

### 8.3 Sample Report: P301-F01 (Daily Log)

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

## SECURITY & AUDIT

### 9.1 Authentication & Authorization

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
```
┌────────────┬──────────────────────────────────────────┐
│ Role       │ Permissions                              │
├────────────┼──────────────────────────────────────────┤
│ ADMIN      │ ✓ All CRUD operations                    │
│            │ ✓ User management                        │
│            │ ✓ System configuration                   │
│            │ ✓ View audit trail                       │
│            │ ✓ Backup/Restore                         │
├────────────┼──────────────────────────────────────────┤
│ MANAGER    │ ✓ View all data                          │
│            │ ✓ Edit cycles & daily logs               │
│            │ ✓ Approve workflows                      │
│            │ ✓ Generate reports                       │
│            │ ✗ Delete master data                     │
│            │ ✗ User management                        │
├────────────┼──────────────────────────────────────────┤
│ STAFF      │ ✓ View assigned ponds/cycles             │
│            │ ✓ Edit daily logs (own pond)             │
│            │ ✓ Submit for approval                    │
│            │ ✗ Delete any data                        │
│            │ ✗ View other ponds                       │
├────────────┼──────────────────────────────────────────┤
│ VIEWER     │ ✓ Read-only access (all data)            │
│            │ ✗ Edit/Delete anything                   │
└────────────┴──────────────────────────────────────────┘
```

### 9.2 Audit Trail Implementation

#### Auto-Logging for All Changes
```csharp
// Interceptor automatically logs:
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
                Action = entry.State.ToString(), // INSERT/UPDATE/DELETE
                OldValues = entry.State == EntityState.Modified 
                    ? GetOldValues(entry) 
                    : null,
                NewValues = GetNewValues(entry),
                ChangedFields = GetChangedFields(entry),
                UserID = GetCurrentUser(),
                Username = GetCurrentUsername(),
                IPAddress = GetClientIP(),
                ActionDate = DateTime.UtcNow
            };
            
            auditEntries.Add(auditEntry);
        }
        
        await context.AuditTrail.AddRangeAsync(auditEntries);
        return await base.SavingChangesAsync(eventData);
    }
}
```

#### Audit Trail Query Example
```sql
-- View all changes for a specific cycle
SELECT 
    AuditID, TableName, RecordID, Action,
    Username, ActionDate, ChangedFields,
    OldValues, NewValues
FROM AuditTrail
WHERE TableName = 'DailyLog' 
  AND RecordID = 12345
ORDER BY ActionDate DESC;

-- View user activity
SELECT 
    Username, COUNT(*) as ChangeCount,
    MIN(ActionDate) as FirstChange,
    MAX(ActionDate) as LastChange
FROM AuditTrail
WHERE ActionDate >= DATEADD(day, -7, GETDATE())
GROUP BY Username
ORDER BY ChangeCount DESC;
```

### 9.3 Alert Thresholds - Unified

#### CRITICAL Alerts (🔴)
```
┌─────────────────────────────┬───────────┬──────────────────┐
│ Condition                   │ Threshold │ Action Required  │
├─────────────────────────────┼───────────┼──────────────────┤
│ DO (Dissolved Oxygen)       │ < 3.0     │ Báo sạch, báт    │
│                             │ mg/L      │ máy sục ngay     │
│ Mortality Rate              │ > 5%/day  │ Liên hệ thú y    │
│ Temperature                 │ <20°C or  │ Thay nước ngay   │
│                             │ >35°C     │                  │
│ pH                          │ <6.0 or   │ Điều chỉnh pH    │
│                             │ >9.0      │ ngay             │
│ H2S (Hydrogen Sulfide)      │ > 0.1     │ Vệ sinh đáy ngay │
│                             │ mg/L      │                  │
│ NH3 (Ammonia)               │ > 0.5     │ Giảm thức ăn 50% │
│                             │ mg/L      │ + thay nước      │
└─────────────────────────────┴───────────┴──────────────────┘
```

#### WARNING Alerts (🟡)
```
┌──────────────────────────┬──────────┬────────────────────┐
│ Condition                │Threshold │ Action Required    │
├──────────────────────────┼──────────┼────────────────────┤
│ DO                       │3.0-4.0   │ Chuẩn bị báт máy   │
│                          │ mg/L     │ sục                │
│ Mortality                │2-5%/day  │ Theo dõi chặt      │
│ Temperature              │25-28 or  │ Chuẩn bị thay nước │
│                          │32-35°C   │                    │
│ pH                       │6.0-6.5   │ Chuẩn bị điều      │
│                          │or 8.5-9  │ chỉnh pH           │
│ H2S                      │0.05-0.1  │ Vệ sinh sơ bộ      │
│                          │ mg/L     │                    │
│ NH3                      │0.3-0.5   │ Giảm thức ăn 30%   │
│                          │ mg/L     │                    │
│ FCR                      │ > 2.5    │ Kiểm tra thức ăn   │
│ Stock (Feed/Chemical)    │ < 7 days │ Đặt hàng bổ sung   │
└──────────────────────────┴──────────┴────────────────────┘
```

#### INFO Alerts (🔵)
```
- Milestone reached (Day 30, 60, 90)
- Growth rate trend update
- Harvest prediction ready
- Maintenance due reminder
- Report available
- Daily log completed
```

### 9.4 Decisioning Matrix (Quy Tắc Tự Động)

Bảng quy tắc để hệ thống tự động ra quyết định và hành động:

```
┌────────────────────────────────────────────────────────────────────────────┐
│ IF Condition                │ THEN Action          │ Threshold │ Priority │
├─────────────────────────────┼──────────────────────┼───────────┼──────────┤
│ DO < 3 mg/L                 │ Alert CRITICAL       │ 3.0       │ 🔴 NGAY  │
│                             │ + Báo máy sục khí    │           │          │
│ DO 3-4 mg/L                 │ Alert WARNING        │ 4.0       │ 🟡 Sớm   │
│ pH < 6.5 OR pH > 8.5        │ Alert + Adjust       │ 6.5-8.5   │ 🟡 Sớm   │
│ H2S > 0.1 mg/L              │ Alert CRITICAL       │ 0.1       │ 🔴 NGAY  │
│                             │ + Vệ sinh đáy        │           │          │
│ NH3 > 0.5 mg/L              │ Reduce feed 50%      │ 0.5       │ 🔴 NGAY  │
│                             │ + Alert CRITICAL     │           │          │
│ Mortality > 2%/day          │ Alert + Investigate  │ 2.0       │ 🔴 NGAY  │
│ FCR > 2.5                   │ Alert WARNING        │ 2.5       │ 🟡 Sớm   │
│                             │ + Review feed        │           │          │
│ Temp < 25°C                 │ Monitor closely      │ 25        │ 🟡 Sớm   │
│ Temp > 32°C                 │ Change water 30%     │ 32        │ 🟡 Sớm   │
│ Survival < 85%              │ Alert WARNING        │ 85        │ 🟡 Sớm   │
│ Stock HSD < 7 days          │ Alert CRITICAL       │ 7         │ 🔴 Sớm   │
│                             │ + Create PO          │           │          │
│ Stock HSD < 30 days         │ Alert WARNING        │ 30        │ ℹ️ Info  │
│ Feed > 10% biomass          │ Block transaction    │ 10%       │ 🔴 NGAY  │
│ Manual override > 20% days  │ Block + Warning      │ 20%       │ 🔴 NGAY  │
└────────────────────────────────────────────────────────────────────────────┘
```

**Ghi chú**:
- 🔴 NGAY: Phải xử lý trong vòng 1 giờ
- 🟡 Sớm: Xử lý trong vòng 24 giờ
- ℹ️ Info: Thông báo, không cần hành động khẩn cấp

---

## TESTING & PERFORMANCE

### 10.1 Testing Strategy

#### Unit Testing (NUnit)
```csharp
[TestFixture]
public class GrowthEngineTests
{
    private GrowthEngine _engine;
    
    [SetUp]
    public void Setup() => _engine = new GrowthEngine();
    
    // Test case 1: Normal conditions
    [Test]
    public void CalculateGrowth_NormalConditions_ReturnsExpected()
    {
        // Arrange
        var age = 15;
        var currentWeight = 10.5f;
        var environment = new EnvironmentSnapshot
        {
            Temperature = 28f,
            DO = 5.5f,
            pH = 7.2f
        };
        
        // Act
        var growth = _engine.CalculateGrowth(age, currentWeight, environment);
        
        // Assert
        Assert.That(growth, Is.InRange(0.4f, 0.6f));
    }
    
    // Test case 2: Stress conditions
    [Test]
    public void CalculateGrowth_LowDO_ReducesGrowth()
    {
        // Arrange
        var normalEnv = new EnvironmentSnapshot { DO = 5.5f };
        var stressEnv = new EnvironmentSnapshot { DO = 3.0f };
        
        // Act
        var normalGrowth = _engine.CalculateGrowth(15, 10.5f, normalEnv);
        var stressGrowth = _engine.CalculateGrowth(15, 10.5f, stressEnv);
        
        // Assert
        Assert.That(stressGrowth, Is.LessThan(normalGrowth));
        Assert.That(stressGrowth / normalGrowth, Is.InRange(0.4f, 0.6f));
    }
}

[TestFixture]
public class FEFOAlgorithmTests
{
    [Test]
    public void AllocateByFEFO_MultipleExpiries_IssuesEarliestFirst()
    {
        // Arrange
        var batches = new[]
        {
            new Batch { ExpiryDate = new DateTime(2025, 03, 01), AvailableQty = 100 },
            new Batch { ExpiryDate = new DateTime(2025, 02, 01), AvailableQty = 100 },
            new Batch { ExpiryDate = new DateTime(2025, 04, 01), AvailableQty = 100 }
        };
        
        // Act
        var allocation = FEFOAlgorithm.Allocate(batches, 150);
        
        // Assert
        Assert.That(allocation[0].ExpiryDate, Is.EqualTo(new DateTime(2025, 02, 01)));
        Assert.That(allocation[0].IssuedQty, Is.EqualTo(100));
        Assert.That(allocation[1].ExpiryDate, Is.EqualTo(new DateTime(2025, 03, 01)));
        Assert.That(allocation[1].IssuedQty, Is.EqualTo(50));
    }
}
```

#### Integration Testing
```csharp
[TestFixture]
public class DailyPipelineIntegrationTests
{
    private AquaSimDbContext _context;
    private DailyPipelineService _service;
    
    [SetUp]
    public void Setup()
    {
        // Use in-memory database for testing
        var options = new DbContextOptionsBuilder<AquaSimDbContext>()
            .UseInMemoryDatabase("TestDb")
            .Options;
        
        _context = new AquaSimDbContext(options);
        _service = new DailyPipelineService(_context);
    }
    
    [Test]
    public async Task ExecuteDay_Day1_GeneratesAllRequiredData()
    {
        // Arrange
        var cycle = await CreateTestCycle();
        
        // Act
        await _service.ExecuteDayAsync(cycle.CycleID, dayNumber: 1);
        
        // Assert - Verify all engines ran
        var dailyLog = await _context.DailyLogs
            .FirstAsync(d => d.CycleID == cycle.CycleID && d.DayNumber == 1);
        
        Assert.That(dailyLog, Is.Not.Null);
        Assert.That(dailyLog.TempAM, Is.GreaterThan(20).And.LessThan(35));
        Assert.That(dailyLog.DOmin, Is.GreaterThan(2).And.LessThan(10));
        Assert.That(dailyLog.FishCount, Is.GreaterThan(0));
        Assert.That(dailyLog.BiomassKg, Is.GreaterThan(0));
    }
    
    [Test]
    public async Task ExecuteDay_Day90_AllDataConsistent()
    {
        // Arrange
        var cycle = await CreateTestCycle();
        
        // Act - Run all 90 days
        for (int day = 1; day <= 90; day++)
        {
            await _service.ExecuteDayAsync(cycle.CycleID, day);
        }
        
        // Assert
        var logs = await _context.DailyLogs
            .Where(d => d.CycleID == cycle.CycleID)
            .OrderBy(d => d.DayNumber)
            .ToListAsync();
        
        Assert.That(logs.Count, Is.EqualTo(90));
        
        // Verify growth trend
        var firstLog = logs.First();
        var lastLog = logs.Last();
        Assert.That(lastLog.AvgWeightGr, Is.GreaterThan(firstLog.AvgWeightGr));
        
        // Verify FCR reasonable
        var totalFeed = logs.Sum(l => l.FeedKg);
        var totalGrowth = lastLog.BiomassKg - firstLog.BiomassKg;
        var fcr = totalFeed / totalGrowth;
        Assert.That(fcr, Is.InRange(1.5f, 3.0f));
    }
}
```

### 10.2 Performance Benchmarks

```
OPERATION BENCHMARKS:
┌────────────────────────┬─────────┬──────────────┬──────────────┐
│ Operation              │ Records │ EF Core      │ Stored Proc  │
├────────────────────────┼─────────┼──────────────┼──────────────┤
│ Generate 90 Days       │ 1 cycle │ 5-8 sec      │ 1-2 sec      │
│ FEFO Allocation        │ 1000    │ 200ms        │ 50ms         │
│ Report Export          │ 90 days │ 1-3 sec      │ N/A          │
│ Bulk Insert            │ 1000    │ 2 sec (EF)   │ 300ms        │
│ Query 10,000 records   │ 10k     │ 800ms        │ 200ms        │
│ Calculate Stock        │ 1 product│ 150ms       │ 50ms         │
└────────────────────────┴─────────┴──────────────┴──────────────┘

OPTIMIZATION STRATEGIES:
1. Use Stored Procedures for heavy computations (FEFO, Auto-split)
2. Batch operations with AddRange + SaveChangesAsync (1 round-trip)
3. Query optimization with Select projections (only needed fields)
4. Index key columns: CycleID, Date, ExpiryDate, Status
5. Database partitioning for historical data (5+ year retention)
```

### 10.3 Load Testing Scenarios

```
SCENARIO 1: Small Farm
- Ponds: 10
- Cycles/Year: 40
- Daily Logs/Year: 3,600
- Storage: ~50 MB
- Concurrent Users: 5
- Response Time: < 1 sec

SCENARIO 2: Medium Farm
- Ponds: 50
- Cycles/Year: 200
- Daily Logs/Year: 18,000
- Storage: ~250 MB
- Concurrent Users: 25
- Response Time: < 2 sec

SCENARIO 3: Large Farm
- Ponds: 100
- Cycles/Year: 400
- Daily Logs/Year: 36,000
- Storage: ~500 MB
- Concurrent Users: 50
- Response Time: < 3 sec

SCENARIO 4: Enterprise
- Ponds: 500+
- Cycles/Year: 2000+
- Daily Logs/Year: 180,000+
- Storage: ~2.5 GB
- Concurrent Users: 100+
- Response Time: < 5 sec (with caching)
```

---

## TRIỂN KHAI & MIGRATION

### 11.1 Implementation Phases

#### Phase 1: Database Setup (Week 1-2)
```
Week 1:
☐ Create SQL Server database
☐ Execute DDL scripts (Tables)
☐ Create indexes
☐ Deploy stored procedures

Week 2:
☐ Seed master data (Farms, Products)
☐ Configure backup jobs
☐ Test restore procedures
☐ Security configuration
```

#### Phase 2: Backend Development (Week 3-8)
```
Week 3-4: Foundation
☐ Setup .NET 9.0 project structure
☐ Implement Domain entities
☐ Create DbContext & Migrations
☐ Setup Dependency Injection

Week 5-6: Business Logic
☐ Implement 11 Simulation Engines
☐ Create Repository layer
☐ Implement Service layer
☐ Add validation rules

Week 7-8: Integration
☐ Integrate all engines
☐ Implement Daily Pipeline
☐ Add error handling
☐ Unit testing (>80% coverage)
```

#### Phase 3: Frontend Development (Week 9-10)
```
Week 9:
☐ Create main dashboard
☐ Implement master data forms
☐ Create cycle management UI
☐ Add daily entry forms

Week 10:
☐ Implement reporting UI
☐ Add export functionality
☐ Create admin panel
☐ Add help system
```

#### Phase 4: Testing & Deployment (Week 11-12)
```
Week 11: Testing
☐ Integration testing
☐ Performance testing (load testing)
☐ Security testing
☐ User acceptance testing (UAT)

Week 12: Deployment
☐ Production environment setup
☐ Data migration from Excel
☐ User training (2-3 sessions)
☐ Go-live support (1 week on-call)
```

#### Phase 5: Report Generation (Week 13)
```
☐ Implement 8 FSIS forms export
  - P301-F01, F06, F07
  - P303-F03, F04, F06, F07
  - P305-F37
☐ Excel export với EPPlus
☐ PDF export với iText7
☐ Word export với OpenXML
☐ Add watermark "MOCKED DATA - FOR TRAINING ONLY"
☐ Test all report formats
```

#### Phase 6: Advanced Features (Week 14)
```
☐ Implement Replay Mode
  - Manifest storage
  - Deterministic verification
  - Checksum comparison
☐ Implement Manual Override
  - Edit UI for daily logs
  - Audit trail logging
  - Recalculation engine
☐ E-signature workflow
☐ Advanced alerts & notifications
```

#### Phase 7: Ongoing Enhancement
```
☐ User feedback collection
☐ Bug fixes & patches
☐ Performance optimization
☐ Feature enhancements based on usage
☐ Documentation updates
☐ Training material creation
```

**Total Timeline**: 14 tuần (3.5 tháng) + Ongoing support

### 11.2 Data Migration from Excel

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

### 11.3 Deployment Checklist

```
PRE-DEPLOYMENT:
☐ Code review completed (100%)
☐ Unit tests passed (>80% coverage)
☐ Integration tests passed
☐ Performance testing completed
☐ Security audit passed
☐ UAT sign-off from stakeholders
☐ Documentation completed & approved

DATABASE DEPLOYMENT:
☐ Production database created
☐ All tables created
☐ All indexes created
☐ All stored procedures deployed
☐ Security roles configured
☐ Backup plan implemented
☐ Restore test completed

APPLICATION DEPLOYMENT:
☐ .NET Runtime 9.0 installed
☐ Connection strings configured
☐ Logging configured (Serilog)
☐ Email notifications configured
☐ File permissions set correctly
☐ Antivirus/Firewall rules updated

POST-DEPLOYMENT:
☐ Smoke test completed (all major features)
☐ System startup verified
☐ User training completed (all staff)
☐ Support contact established
☐ Monitoring enabled
☐ First backup verified
☐ Incident response plan reviewed
```

---

## PHỤ LỤC

### A. Glossary - Thuật ngữ

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
| Receipt | Nháp kho | Phiếu ghi nhận hàng vào kho |
| Issue | Xuất kho | Phiếu ghi nhận hàng ra kho |

### B. Data Validation Rules

```
BUSINESS RULES:
├─ Pond không thể có 2 cycles active cùng lúc
├─ FCR không thể < 1.0 (không hợp lý)
├─ Survival rate không thể > 100%
├─ Feed amount không thể > 10% body weight
├─ Temperature: 15-40°C (ngoài là lỗi)
├─ pH: 4.0-11.0 (ngoài là invalid)
├─ DO: 0-20 mg/L (outside = error)
├─ Expiry date phải > Manufacturing date
├─ Batch code phải unique trong warehouse
├─ User phải có role để access function
└─ Daily log không thể có > 5% missing fields

ERROR HANDLING:
├─ Transaction rollback nếu validation fails
├─ Log error details vào AuditTrail
├─ Show user-friendly error message
├─ Notify admin nếu critical
└─ Retry mechanism cho transient errors
```

### C. Known Limitations

```
CURRENT VERSION 4.0:
1. Desktop only (Windows Forms)
   → Future: Web version (ASP.NET Core)

2. Single-site deployment
   → Future: Multi-site with central sync

3. Manual input triggers auto-generation
   → Future: Scheduled auto-generation

4. No real-time sensor integration
   → Future: IoT sensors for DO/Temp/pH

5. Reports in local language only
   → Future: Multi-language reports

6. No mobile app
   → Future: Mobile app (Android/iOS)

7. Audit trail retained 1 year
   → Future: Archival to cold storage
```

### D. Code Standards

```csharp
// NAMING CONVENTIONS
public class FarmingCycle { }         // PascalCase for classes
public interface IRepository { }      // I + PascalCase for interfaces
public async Task<T> GetAsync() { }   // Async suffix
private readonly ILogger _logger;     // _camelCase for private

// ASYNC/AWAIT PATTERN
public async Task<Result> ProcessAsync()
{
    try
    {
        return await _service.ExecuteAsync(data);
    }
    catch (BusinessException ex)
    {
        _logger.LogWarning(ex, "Business rule violation");
        return Result.Fail(ex.Message);
    }
}

// ERROR HANDLING
if (!result.IsSuccess)
{
    var errorDetails = new ErrorDetails
    {
        Code = result.ErrorCode,
        Message = result.ErrorMessage,
        Timestamp = DateTime.UtcNow
    };
    throw new DomainException(errorDetails);
}

// REPOSITORY PATTERN
public interface IRepository<T> where T : Entity
{
    Task<T> GetByIdAsync(int id);
    Task<IEnumerable<T>> GetAllAsync();
    Task<int> AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(int id);
}
```

### E. Contact & Support

```
TECHNICAL SUPPORT:
├─ Email: support@aquasim.vn
├─ Phone: (028) 3-XXXX-XXXX
├─ Hotline: 1800-AQUASIM
└─ Hours: Mon-Fri 8:00-17:00

TRAINING:
├─ Online: training@aquasim.vn
├─ Duration: 2-4 hours
├─ Topics: Basic usage, Reports, Admin
└─ Frequency: Weekly sessions

DOCUMENTATION:
├─ User Manual: /docs/UserManual.pdf
├─ Technical Specs: /docs/TechnicalGuide.pdf
├─ FAQ: https://aquasim.vn/faq
└─ Video Tutorials: https://youtube.com/aquasim

BUG REPORTING:
├─ System: bugs@aquasim.vn
├─ Attach: Screenshot + Logs
├─ Priority: Critical (4h), High (1d), Normal (3d)
└─ Resolution: Hotfix or next release
```

---

## DISCLAIMER & WATERMARK REQUIREMENTS

### 13.1 Tuyên Bố Miễn Trách

⚠️ **Dữ Liệu Mô Phỏng**:
- Tất cả dữ liệu được sinh **TỰ ĐỘNG** từ công thức mô phỏng
- **KHÔNG PHẢI** dữ liệu thực từ trang trại
- **Mục đích**: Đào tạo, chuẩn hóa biểu mẫu, phân tích
- **KHÔNG** sử dụng cho báo cáo chính thức

### 13.2 Watermark Bắt Buộc

🔴 **Watermark Requirement**:
```
"MOCKED DATA - FOR TRAINING ONLY"
```

**Phải có trên tất cả**:
- ✅ Biểu mẫu xuất (XLSX/DOCX/PDF)
- ✅ Header báo cáo
- ✅ File CSV/JSON export
- ✅ Dashboard preview
- ✅ Print outputs

### 13.3 Hạn Chế Sử Dụng

❌ **KHÔNG được phép**:
- ❌ Gửi báo cáo này cho chính quyền
- ❌ Sử dụng cho kiểm định/chứng nhận
- ❌ Xóa watermark
- ❌ Phát hành công khai
- ❌ Thay thế dữ liệu thực tế

✅ **Được phép**:
- ✅ Dùng để đào tạo nhân viên
- ✅ Test tính năng hệ thống
- ✅ Demo cho khách hàng (với watermark)
- ✅ Phân tích công thức
- ✅ Kiểm tra layout biểu mẫu
- ✅ Training & simulation purposes

### 13.4 Lỗi Tiềm Ẩn & Xử Lý

| Lỗi Tiềm Ẩn | Cách Xử Lý |
|--------------|-----------|
| Weather API không kết nối | Fallback → BASELINE temperature |
| Seed không chỉ định | Sinh ngẫu nhiên, không replay được |
| Manifest bị mất | Không thể replay, phải sinh lại |
| Manual override quá nhiều | Báo cáo không representative, log đầy đủ |
| DB crash | Restore từ backup (RTO < 4h) |

---

## DOCUMENT METADATA

| Property | Value |
|----------|-------|
| **Document ID** | SRS-AQUASIM-4.0 |
| **Version** | 4.0 Consolidated |
| **Status** | ✅ APPROVED |
| **Date** | 06/11/2025 |
| **Total Pages** | ~40 pages |
| **Word Count** | ~18,000 words |
| **Author** | Technical Team |
| **Reviewer** | Project Manager |
| **Approver** | Client Representative |

---

## CHANGE HISTORY

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 15/10/2025 | Initial draft from business requirements |
| v2.0 | 25/10/2025 | Added technical architecture |
| v2.5 | 01/11/2025 | Integrated simulation formulas & algorithms |
| v3.0 | 04/11/2025 | Added security, audit, testing sections |
| **v4.0** | **06/11/2025** | **Consolidated: Removed 99% duplicate, unified structure** |

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