# TÀI LIỆU ĐẶC TẢ YÊU CẦU PHẦN MỀM (SRS ENHANCED)
## Hệ thống AquaSim v4.1 - Enhanced with Operational Data
### Phiên bản: 4.1 Enhanced
### Ngày: 14/11/2025

---

## METADATA

| Property | Value |
|----------|-------|
| **Document ID** | SRS-AQUASIM-4.1-ENHANCED |
| **Version** | 4.1 Enhanced with Operational Data |
| **Status** | UPDATED |
| **Date** | 14/11/2025 |
| **Author** | Technical Team |
| **Reviewer** | Project Manager |
| **Approver** | Client Representative |
| **Total Words** | ~32,000 words |
| **Total Pages** | ~85 pages |
| **Data Source** | QLCLN_all_sheets.json |

---

## MỤC LỤC

1. [TÓM TẮT ĐIỀU HÀNH (Executive Summary)](#1-tóm-tắt-điều-hành)
2. [TỔNG QUAN DỰ ÁN](#2-tổng-quan-dự-án)
3. [KIẾN TRÚC HỆ THỐNG](#3-kiến-trúc-hệ-thống)
4. [YÊU CẦU CHỨC NĂNG (FUNCTIONAL REQUIREMENTS)](#4-yêu-cầu-chức-năng)
5. [YÊU CẦU PHI CHỨC NĂNG (NON-FUNCTIONAL REQUIREMENTS)](#5-yêu-cầu-phi-chức-năng)
6. [MÔ HÌNH DỮ LIỆU & DATABASE](#6-mô-hình-dữ-liệu--database)
7. [CÔNG THỨC & THUẬT TOÁN](#7-công-thức--thuật-toán)
8. [11 SIMULATION ENGINES](#8-11-simulation-engines)
9. [QUY TRÌNH NGHIỆP VỤ](#9-quy-trình-nghiệp-vụ)
10. [8 FSIS FORMS](#10-8-fsis-forms)
11. [USER ROLES & PERMISSIONS](#11-user-roles--permissions)
12. [ALERT THRESHOLDS & RULES](#12-alert-thresholds--rules)
13. [GIAO DIỆN & BÁO CÁO](#13-giao-diện--báo-cáo)
14. [SECURITY & AUDIT](#14-security--audit)
15. [TESTING & PERFORMANCE](#15-testing--performance)
16. [TRIỂN KHAI & MIGRATION](#16-triển-khai--migration)
17. [USER GUIDE (FSIS FORMS)](#17-user-guide-fsis-forms)
18. [PHỤ LỤC](#18-phụ-lục)

---

## 1. TÓM TẮT ĐIỀU HÀNH

### 1.1 Vấn đề Hiện tại

- ✗ **Excel quản lý**: Không đồng bộ, dễ lỗi
- ✗ **Theo dõi thủ công**: Tốn thời gian, sai sót
- ✗ **Báo cáo không chuẩn**: Không đạt tiêu chuẩn FSIS

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

## 2. TỔNG QUAN DỰ ÁN

### 2.1 Giới thiệu AquaSim

**AquaSim** là hệ thống quản lý trang trại nuôi thủy sản toàn diện, được thiết kế để:

| Mục tiêu | Chi tiết |
|----------|----------|
| **Tự động hóa** | Quy trình sinh dữ liệu toàn chu kỳ 90 ngày |
| **Thay thế Excel** | Các quy trình theo dõi thủ công |
| **Chuẩn hóa báo cáo** | Theo tiêu chuẩn FSIS (8 form) |
| **Hỗ trợ** | Mô phỏng và dự báo cho mục đích đào tạo |
| **Deterministic** | Cùng seed → cùng kết quả (reproducible) |

### 2.2 Phạm vi Toàn diện

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

### 2.3 Định nghĩa & Thuật ngữ

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

### 3.1 Kiến trúc Tổng thể

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
│                    25+ Tables, 6+ SPs, 2 Triggers               │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Chiến lược Database-First

- ✅ **Cơ sở dữ liệu SQL Server** là nguồn sự thật duy nhất; schema được quản lý trực tiếp trên DB.
- ✅ **Entity Framework Core** chỉ dùng ở chế độ Database-First (scaffold từ DB, không tạo migration để build schema).
- ✅ **Thay đổi schema** phải thực hiện trên DB trước, sau đó regenerate model/service để đồng bộ mã nguồn.
- ✅ **Stored procedures, view** và các ràng buộc được bảo toàn và ưu tiên tái sử dụng từ DB hiện hữu.
- ℹ️ Hiện tại dự án đang chạy với cơ sở dữ liệu `aquasim_VHC` (SQL Server 2019+) theo mô hình Database-First.

#### Quy trình đồng bộ model khi thay đổi schema

1. Thực hiện chỉnh sửa trực tiếp trên cơ sở dữ liệu `aquasim_VHC` (DDL, stored procedure, view...).
2. Từ thư mục `AquaSim.Models`, chạy lệnh scaffold:
   ```powershell
   dotnet ef dbcontext scaffold "Server=tcp:172.17.254.222,1433;Database=aquasim_VHC;User Id=mhkpi;Password=Try@VhcQAZXCV;Encrypt=false;TrustServerCertificate=true;" Microsoft.EntityFrameworkCore.SqlServer \
       --context AquaSimDbContext \
       --output-dir . \
       --force \
       --no-pluralize
   ```
3. Kiểm tra và commit các file model mới, đảm bảo không ghi đè các file tùy chỉnh ngoài Models/.
4. Build lại giải pháp và chạy smoke test để chắc chắn các thay đổi hoạt động.

### 3.3 Tech Stack Đầy đủ

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

### 3.4 Design Patterns

- **Repository Pattern**: Clean Architecture + Adapter
- **Dependency Injection**: IoC Container
- **Unit of Work**: Transaction Management
- **Factory Pattern**: Object Creation
- **Strategy Pattern**: Algorithm Selection (11 engines)
- **Observer Pattern**: Event & Alert Handling
- **Interceptor Pattern**: Audit Trail auto-logging

---

## 4. YÊU CẦU CHỨC NĂNG

### 4.1 Master Data Management (FR-MDM)

#### FR-MDM-001: Farm Management
- **CRUD Operations**: Thêm, sửa, xóa thông tin farm
- **Lưu trữ**: Tên, địa chỉ, tọa độ, chứng nhận (ASC, BAP, GG)
- **Phạm vi**: Quản lý vùng/khu vực
- **Cấu hình**: Tham số riêng (giới hạn nước, aeration)

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
- **Audit Trail**: Log mọi thao tác
- **Phạm vi**: Trách nhiệm theo thời gian

---

### 4.2 Operational Management (FR-OPS)

#### FR-OPS-001: Fish Stocking
- **Ghi nhận**: Nguồn giống, chất lượng
- **Theo dõi**: Mật độ, số lượng thả
- **Thông tin**: Tuổi, kích cỡ fingerling
- **Sản lượng**: Kỳ vọng theo ao

#### FR-OPS-002: Farming Cycle (90 ngày)
- **Khởi tạo**: Với thông số đầu vào (StartDate, SeedQty, FCR, etc.)
- **Trạng thái**: PLANNING → ACTIVE → MEDICATING → HARVESTING → CLOSED → CANCELLED
- **Theo dõi**: FCR, tỷ lệ chết, growth curve
- **Chi tiết**: 90 ngày dữ liệu

#### FR-OPS-003: Daily Logs
- **Ghi nhận hàng ngày**: Thức ăn, cá chết, pH, DO, nhiệt độ
- **Sinh khối & TLBQ**: Tính toán tự động
- **Ghi chú**: Sự kiện đặc biệt
- **Form**: Tham chiếu P301-F01

#### FR-OPS-004: Health Monitoring
- **TLBQ & Bệnh**: Ký sinh trùng, dấu hiệu lâm sàng
- **Hao hụt**: Tỷ lệ hao hụt theo ao
- **Điều trị**: Ghi nhận & hiệu quả
- **Form**: Tham chiếu P303-F07

#### FR-OPS-005: Water Management
- **Cấp/Thoát**: Lượng nước (m³)
- **Giám sát**: DO, pH, H2S, NH3
- **Lịch thay**: Theo chu kỳ
- **Form**: Tham chiếu P304-F04

**Quy tắc cấp thoát nước chi tiết:**

1. **Tháng 1 (từ lúc thả đến tháng thứ nhất)**:
   - Tần suất: 2 lần/tháng (theo nhịp thay nước)
   - Lượng nước: Mức 1 (lấy từ thông tin trang trại)

2. **Tháng 2**:
   - Tần suất: 3 lần/tháng (theo nhịp thay nước)
   - Lượng nước: Mức 1

3. **Tháng 3**:
   - Tần suất: 4 lần/tháng (theo nhịp thay nước)
   - Lượng nước: Mức 2

4. **Tháng 4 trở đi**:
   - Tần suất: 5-10 lần/tháng (theo nhịp thay nước)
   - Lượng nước: Mức 2 hoặc 3 hoặc bỏ nhịp
   - Điều kiện: Tùy thuộc vào tổng lượng nước cấp có vượt quy định không

5. **Thu hoạch**:
   - Lượng nước: Mức 4 vào ngày thu hoạch cuối

6. **Cấp lại cho vụ mới**:
   - Cấp lại 1m nước
   - Thời điểm: Ngay nhịp thay nước của vùng trước ngày sử dụng thuốc đầu tiên

**Ràng buộc quan trọng:**

- **Ao lắng**:
  - Vùng nuôi có 2 ao lắng → Xả thải khác ngày nhau
  - Đảm bảo trong tháng có 2 đợt thải cùng ngày
  - Tổng lượng xả không vượt **10,000 m³/ngày** (đối với vùng không có giấy phép xả thải)

- **Cấp thoát nước ao nuôi**:
  - Lượng cấp không được vượt **8,640 m³/ngày**

- **Khi sử dụng thuốc điều trị bệnh**:
  - **KHÔNG ĐƯỢC THAY NƯỚC**

#### FR-OPS-006: Waste Management
- **Loại & Số lượng**: Chất thải
- **Xử lý**: Phương pháp xử lý
- **Giao nhận**: Chu kỳ
- **Form**: Tham chiếu P305-F37

---

### 4.3 Inventory Management (FR-INV)

#### FR-INV-001: Receipt (Nhập kho)
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
- **Công thức**: Stock = SUM(Nhập) - SUM(Xuất)
- **Cảnh báo**: HSD sắp hết (< 30 ngày)
- **Báo cáo**: Theo lô, theo HSD
- **Dashboard**: Tồn kho real-time

---

### 4.4 Auto-Generator & Simulation (FR-AUTO)

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
10. ALERT GENERATION → Cảnh báo CRITICAL/WARNING/INFO

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

### 4.5 Workflow & Approval (FR-WF)

#### FR-WF-001: Product Specification Approval
- **Form**: P303-F06 (Phiếu chỉ định sản phẩm)
- **Quy trình**: Draft → Pending → Approved/Rejected
- **Trách nhiệm**: Người đề nghị, Quản lý duyệt

#### FR-WF-002: Waste Transfer Approval
- **Form**: P305-F37 (Sổ giao nhận chất thải)
- **Ký**: Người giao + Người nhận
- **Timestamp**: Ghi chép thời gian + audit trail

---

### 4.6 Reporting & Analytics (FR-RP)

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

## 5. YÊU CẦU PHI CHỨC NĂNG

### 5.1 Hiệu năng (NFR-PERF)

| ID | Yêu cầu | Tiêu chuẩn |
|----|---------|-----------|
| NFR-PERF-001 | CRUD response | ≤ 2 giây |
| NFR-PERF-002 | Query 10,000 records | ≤ 1 giây |
| NFR-PERF-003 | Auto-Generate 365 ngày × 1000 ao | < 30 giây |
| NFR-PERF-004 | Export báo cáo | ≤ 10 giây |
| NFR-PERF-005 | Concurrent users | 50 users |

### 5.2 Bảo mật (NFR-SEC)

| ID | Yêu cầu | Chi tiết |
|----|---------|---------|
| NFR-SEC-001 | Authentication | Username/Password with BCrypt hash |
| NFR-SEC-002 | Authorization | Role-Based Access Control (RBAC) |
| NFR-SEC-003 | Audit Trail | Log mọi thay đổi dữ liệu |
| NFR-SEC-004 | Data Encryption | Encrypt sensitive data at rest |
| NFR-SEC-005 | Password Policy | Min 8 chars, complexity rules |
| NFR-SEC-006 | Login Protection | Max 5 failed attempts → Lock account |
| NFR-SEC-007 | Session Timeout | Auto-logout after 30 mins |

### 5.3 Độ tin cậy (NFR-REL)

| ID | Yêu cầu | Tiêu chuẩn |
|----|---------|-----------|
| NFR-REL-001 | System Availability | ≥ 99.5% |
| NFR-REL-002 | Data Integrity | Transaction with rollback |
| NFR-REL-003 | Backup | Daily automatic backup |
| NFR-REL-004 | Recovery | Point-in-time recovery (30 days) |
| NFR-REL-005 | Network Issues | Graceful handling |

### 5.4 Khả năng sử dụng (NFR-USAB)

| ID | Yêu cầu | Chi tiết |
|----|---------|---------|
| NFR-USAB-001 | UI Design | Trực quan, nhất quán |
| NFR-USAB-002 | Language | Tiếng Việt + Tiếng Anh |
| NFR-USAB-003 | Help System | Context-sensitive help |
| NFR-USAB-004 | Training | < 2 giờ đào tạo |
| NFR-USAB-005 | Excel-like | Giống Excel hiện tại |

### 5.5 Khả năng mở rộng (NFR-SCALE)

| ID | Yêu cầu | Capacity |
|----|---------|----------|
| NFR-SCALE-001 | Farms | Tối 100 farms |
| NFR-SCALE-002 | Ponds | Tối 1000 ponds |
| NFR-SCALE-003 | Historical Data | 5 năm |
| NFR-SCALE-004 | Database | Partitioning support |
| NFR-SCALE-005 | Modular Design | Plugin architecture |

---

## 6. MÔ HÌNH DỮ LIỆU & DATABASE

### 6.1 Entity Relationship Diagram (ERD) - Consolidated

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
│   ├── (1) ──────────────────< (N) StatusChanges
│   └── (1) ──────────────────< (N) Events

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

### 6.2 Core Tables

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

#### Table: Events (NEW!)
```sql
CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    CycleID INT REFERENCES FarmingCycles(CycleID),
    EventDate DATE NOT NULL,
    DayNo INT,
    EventType NVARCHAR(50),           -- MEDICATION, WATER_EXCHANGE, HEALTH_CHECK, EMERGENCY
    ChemicalID INT REFERENCES ChemicalInventory(ChemicalID),
    DosageAmount DECIMAL(8,2),
    ExchangePercent DECIMAL(5,2),
    Status NVARCHAR(20) DEFAULT 'PLANNED', -- PLANNED, COMPLETED, CANCELLED
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX IX_Event_CycleDate (CycleID, EventDate DESC)
);
```

#### Table: DailyReportSummary (NEW!)
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

### 6.3 Stored Procedures

#### sp_GenerateDailyLogs (NEW!)
```sql
CREATE PROCEDURE sp_GenerateDailyLogs
    @CycleID INT,
    @StartDay INT = 1,
    @EndDay INT = 90,
    @UseLiveWeather BIT = 0
AS
BEGIN
    -- Pipeline orchestrator cho sinh dữ liệu tự động
    -- Input: @CycleID, @StartDay, @EndDay, @UseLiveWeather
    -- Output: DailyLog records từ 11 engines

    -- Temperature simulation: 28.0 ± 2°C
    -- DO simulation: 5.5 - (Biomass/1000) × 0.5
    -- pH simulation: 7.2 ± 0.3
    -- Mortality calculation: ~0.1% cơ bản
    -- Growth calculation: +0.3 g/con/ngày
    -- Feed calculation: Biomass × 3%

    -- Transaction-based for consistency
END
```

#### sp_CalculateCycleStats (NEW!)
```sql
CREATE PROCEDURE sp_CalculateCycleStats
    @CycleID INT
AS
BEGIN
    -- Tính toán thống kê chu kỳ toàn bộ
    -- Output:
    --   - InitialBiomass, FinalBiomass, BiomassGain
    --   - TotalFeed, FCR, SurvivalRate
    --   - TotalCost, CostPerKgBiomass
    -- Dùng cho: Dashboard & Reporting
END
```

#### sp_AllocateFEFO
```sql
CREATE PROCEDURE sp_AllocateFEFO
    @WarehouseID INT,
    @ProductID INT,
    @RequiredQtyKg DECIMAL(12,3),
    @AsOfDate DATETIME
AS
BEGIN
    -- FEFO allocation logic
    -- 1. Lấy available batches
    -- 2. Sắp xếp theo ExpiryDate ASC
    -- 3. Allocate theo FIFO
    -- 4. Tạo PO nếu thiếu
END
```

#### sp_SplitReceiptByCapacity
```sql
CREATE PROCEDURE sp_SplitReceiptByCapacity
    @WarehouseID INT,
    @TotalQtyKg DECIMAL(12,3),
    @BatchSize INT = 50
AS
BEGIN
    -- Auto-split receipt if exceeds warehouse capacity
END
```

#### sp_VerifyDeterminism
```sql
CREATE PROCEDURE sp_VerifyDeterminism
    @CycleID INT,
    @Seed INT
AS
BEGIN
    -- Verify deterministic simulation
    -- Compare checksums from manifest
END
```

### 6.4 Triggers

#### trg_AuditDailyLog (NEW!)
```sql
CREATE TRIGGER trg_AuditDailyLog
ON DailyLogs
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Tự động ghi vào AuditTrail mọi thay đổi DailyLog
    -- Theo dõi: FishQty, DeathQty, Feed, và các changes khác
    -- Lưu OldValues & NewValues trong JSON format
END
```

#### trg_UpdateCycleLastDay (NEW!)
```sql
CREATE TRIGGER trg_UpdateCycleLastDay
ON DailyLogs
AFTER INSERT
AS
BEGIN
    -- Cập nhật FarmingCycle.LastProcessedDay tự động
    -- Tracking tiến độ sinh dữ liệu
END
```

---

## 7. CÔNG THỨC & THUẬT TOÁN

### 7.1 Công thức Sinh khối (Biomass)

```
SINH KHỐI (kg)
Sinh_khối = (Số_cá × TLBQ) / 1000

Trong đó:
- Số_cá: Số lượng cá hiện tại (con)
- TLBQ: Trọng lượng bình quân (g/con)
```

### 7.2 Công thức Tăng trưởng (Growth Rate)

#### 7.2.1 Đường Chuẩn Tăng Trưởng (Standard Growth Curve)

**Dữ liệu từ thực tế trang trại:**

```
┌──────────────────┬────────────────────┬──────────────────┐
│ Thời gian nuôi   │ Tăng trọng/tháng   │ TLBQ cuối tháng  │
│ (tháng)          │ (g)                │ (g)              │
├──────────────────┼────────────────────┼──────────────────┤
│ 1                │ 40                 │ 70               │
│ 2                │ 80                 │ 150              │
│ 3                │ 100                │ 250              │
│ 4                │ 120                │ 380              │
│ 5                │ 140                │ 520              │
│ 6                │ 150                │ 670              │
│ 7                │ 180                │ 850              │
│ 8                │ 150                │ 1000             │
└──────────────────┴────────────────────┴──────────────────┘
```

**Lưu ý**:
- Đường chuẩn này dựa trên dữ liệu thực tế từ trang trại
- Sử dụng cho mô phỏng và dự báo tăng trưởng
- Điều chỉnh theo điều kiện môi trường thực tế

#### 7.2.2 Tăng Trưởng Hàng Ngày (Simplified Model)

```
TĂNG TRƯỞNG HÀNG NGÀY
Actual_growth = Base_growth × Hệ_số_điều_chỉnh

Base Growth theo tuổi (Mô hình đơn giản hóa):
┌────────────────────┬──────────────┬─────────────────────┐
│ Tuổi (ngày)        │ Tăng/ngày    │ TLBQ cuối giai đoạn │
├────────────────────┼──────────────┼─────────────────────┤
│ 0-10               │ +0.2 g/con   │ 1.5 → 3.5           │
│ 11-30              │ +0.5 g/con   │ 3.5 → 13.5          │
│ 31-60              │ +0.8 g/con   │ 13.5 → 37.5         │
│ 61-90              │ +0.6 g/con   │ 37.5 → 52.5         │
└────────────────────┴──────────────┴─────────────────────┘

HỆ SỐ ĐIỀU CHỈNH:
- DO < 4 mg/L: × 0.5
- pH ngoài 6.5-8.5: × 0.7
- Temp < 25°C: × 0.7
- Temp > 32°C: × 0.6
- H2S > 0.05: × 0.4
- NH3 > 0.2: × 0.5
- Có bệnh: × 0.3-0.6
```

### 7.3 Công thức Tỷ lệ chết (Mortality Rate)

#### 7.3.1 Quy Tắc Cá Chết Theo Thực Tế Trang Trại

**Tỷ lệ hao hụt chuẩn theo giai đoạn:**

```
┌───────────────────────────────────────┬──────────────┬────────────────────────┐
│ Giai đoạn                             │ Tỷ lệ (%)    │ Ghi chú                │
├───────────────────────────────────────┼──────────────┼────────────────────────┤
│ Ngày 1-7 (Tổng hao hụt)              │ < 0.5%       │ Giai đoạn nhạy cảm     │
│ Ngày 8-14 (Hao hụt/ngày)             │ < 0.4%/ngày  │ Giai đoạn thích nghi   │
│ Cỡ cá tới 40g (Hao hụt/ngày)         │ < 0.3%/ngày  │ Giai đoạn phát triển   │
│ Cỡ cá 40-80g (Hao hụt/ngày)          │ < 0.1%/ngày  │ Tăng trưởng ổn định    │
│ Cỡ cá 80-100g (Hao hụt/ngày)         │ < 0.03%/ngày │ Giai đoạn ổn định      │
│ Cỡ cá > 100g (Hao hụt/ngày)          │ < 0.02%/ngày │ Giai đoạn trưởng thành │
└───────────────────────────────────────┴──────────────┴────────────────────────┘

TỶ LỆ VÔ HÌNH:
- Công thức: ((Số con thả - (Số con thu hoạch + Số con chết)) / Số con thả) × 100
- Tiêu chuẩn: ≤ 10%
```

**Xử lý cá bệnh:**
- Khi cá chết vượt tỷ lệ quy định → Cá bệnh
- Đặc biệt quan trọng cho cá < 100g
- **Trước khi dùng thuốc trị bệnh**:
  - Cho cá chết vượt quy định: 2 ngày
  - Sau ngày cuối cùng dùng thuốc: 3-5 ngày
- **Trước khi dùng thuốc trị ký sinh trùng**:
  - Cho cá chết vượt quy định: 1 ngày
  - Sau ngày cuối cùng dùng thuốc: 1-2 ngày

#### 7.3.2 Công Thức Tính Toán (Simplified Model)

```
TỶ LỆ CÁ CHẾT
Base_rate = GetBaseRate(Age)
Adjusted_rate = Base_rate × Hệ_số_bệnh × Hệ_số_stress
Cá_chết = Random(Adjusted_rate × 0.8, Adjusted_rate × 1.2) × Số_cá

Base Rate theo tuổi (Mô hình đơn giản):
┌────────────────────┬──────────────┐
│ Tuổi (ngày)        │ Tỷ lệ (%)    │
├────────────────────┼──────────────┤
│ 0-10               │ 0.1-0.5%     │
│ 11-30              │ 0.05-0.2%    │
│ 31-60              │ 0.02-0.1%    │
│ 61-90              │ 0.01-0.05%   │
└────────────────────┴──────────────┘

HỆ SỐ BỆNH:
- Vibrio: × 3-5
- Stress pH/DO: × 2-3
- Thiếu oxy (DO<2): × 5-10
```

**Lưu ý**:
- Sử dụng quy tắc theo thực tế (7.3.1) cho production
- Sử dụng mô hình đơn giản (7.3.2) cho training/simulation

### 7.4 Công thức Thức ăn (Feed Allocation)

#### 7.4.1 Quy Tắc Thức Ăn Theo Thực Tế Trang Trại

**Khẩu phần thức ăn theo kích cỡ cá:**

```
┌────────────┬─────────────────┬──────────────────┬──────────────────────────────────────┐
│ Kích cỡ cá │ Kích cỡ TA (max)│ Khẩu phần        │ Công thức                            │
├────────────┼─────────────────┼──────────────────┼──────────────────────────────────────┤
│ 15-80g     │ 2-3 mm          │ Tối đa 4% BW     │ (4 × TLBQ × Số cá) / 100            │
│ 80-200g    │ 3-4 mm          │ Tối đa 3% BW     │ (3 × TLBQ × Số cá) / 100            │
│ 200-1000g  │ 4-6 mm          │ Tối đa 2% BW     │ (2 × TLBQ × Số cá) / 100            │
└────────────┴─────────────────┴──────────────────┴──────────────────────────────────────┘

BW = Body Weight (Trọng lượng thân)
```

**Quy định đóng gói & phân phối:**
- **Bao chuẩn**: 40kg/bao (từ 2mm-26 đạm đến 6mm-22 đạm)
- **Lượng cho ăn**: Phải chẵn 1 bao (làm tròn theo bao)
- **Nhiều lô cùng ngày**: Tách ra 2 dòng cho mã số lô, HSD và lượng
- **Thay thế kích cỡ**: Khi hết kích cỡ đang dùng, có thể dùng kích cỡ tiếp theo còn trong kho

**Ràng buộc quan trọng:**

1. **Khi sử dụng thuốc điều trị bệnh**:
   - Giảm thức ăn 50% so với ngày trước đó
   - Sau khi hết bệnh: Tăng dần trở lại

2. **Sau khi thu tỉa**:
   - Giảm lượng thức ăn tương đương với lượng cá còn lại trong ao

3. **Tăng/giảm thức ăn**:
   - Không được chênh lệch quá ±50% so với ngày hôm trước
   - Đảm bảo tính ổn định trong quá trình nuôi

#### 7.4.2 Công Thức Tính Toán (Simplified Model)

```
LƯỢNG THỨC ĂN (kg/ngày)
Base_%BW = GetBaseFeeding(TLBQ, Age)
Adjusted_%BW = Base_%BW × Hệ_số_điều_chỉnh
Thức_ăn = (Sinh_khối × Adjusted_%BW) / 100

Base %BW theo kích cỡ (Mô hình đơn giản):
┌────────────┬──────────────┬──────────────┐
│ Kích cỡ    │ Tuổi         │ %BW/ngày     │
├────────────┼──────────────┼──────────────┤
│ < 50g      │ 0-10 ngày    │ 5-7%         │
│ 50-150g    │ 11-30 ngày   │ 3-5%         │
│ 150-300g   │ 31-60 ngày   │ 2-3%         │
│ > 300g     │ 61+ ngày     │ 1.5-2%       │
└────────────┴──────────────┴──────────────┘

ĐIỀU CHỈNH:
- Đang dùng thuốc: × 0.5
- DO < 4: × 0.6
- pH ngoài range: × 0.7
- Có bệnh: × 0.5-0.8
- Ràng buộc: ±50% so với ngày trước
```

**Lưu ý**:
- Sử dụng quy tắc theo thực tế (7.4.1) cho production
- Sử dụng mô hình đơn giản (7.4.2) cho training/simulation

### 7.5 Công thức FCR (Feed Conversion Ratio)

```
FCR
FCR = Tổng_thức_ăn_tích_lũy / Tổng_sinh_khối_tích_lũy

TIÊU CHUẨN:
- 1.5-2.0: Tốt ✅
- 2.0-2.5: Bình thường ✅
- > 2.5: Cảnh báo
- > 3.0: Nguy hiểm
```

### 7.6 Công thức Chất lượng nước

#### 7.6.1 Quy Tắc Môi Trường Ao Nuôi Theo Thực Tế

**A. DO (Dissolved Oxygen) - mg/L**

Tần suất đo: 2 lần/ngày (sáng & chiều)
Yêu cầu: Buổi sáng thấp hơn buổi chiều, chênh lệch: min=0.2, max=1.0, bước nhảy=0.1

```
┌──────────────────────┬────────────────┬────────────────┬────────────────┬──────────────────┐
│ Giai đoạn nuôi       │ Tuần 1         │ Tuần 2 - Tháng 1│ 2 Tháng tiếp   │ Các tháng còn lại│
├──────────────────────┼────────────────┼────────────────┼────────────────┼──────────────────┤
│ DO Sáng (mg/L)       │ 3.5 - 3.9      │ 3.0 - 3.5      │ 2.9 - 3.2      │ 2.6 - 2.9        │
│ DO Chiều (mg/L)      │ 3.9 - 4.5      │ 3.5 - 3.9      │ 3.2 - 3.5      │ 2.8 - 3.4        │
└──────────────────────┴────────────────┴────────────────┴────────────────┴──────────────────┘
```

**B. Nhiệt độ (Temperature) - °C**

Tần suất đo: 2 lần/ngày (sáng & chiều)
Yêu cầu: Buổi sáng thấp hơn buổi chiều, chênh lệch: min=0.5, max=2.0, bước nhảy=0.1

**Lưu ý**: Tháng đề cập là tháng của năm (theo mùa), không phải tháng nuôi

```
┌──────────────────────┬────────────────┬────────────────┬────────────────┐
│ Thời gian trong năm  │ Tháng 2-5      │ Tháng 6-10     │ Tháng 11-1     │
├──────────────────────┼────────────────┼────────────────┼────────────────┤
│ Nhiệt độ Sáng (°C)   │ 28 đến <30     │ 27 đến <30     │ 26 đến <29     │
│ Nhiệt độ Chiều (°C)  │ 29 đến <32     │ 29 đến <31     │ 28 đến <30     │
└──────────────────────┴────────────────┴────────────────┴────────────────┘
```

**C. pH**

Tần suất đo: 2 lần/ngày (sáng & chiều)
Yêu cầu: Buổi sáng thấp hơn buổi chiều, chênh lệch không quá 0.5, bước nhảy=0.1

```
┌──────────────────────┬────────────────────────────────────────────┐
│ Tất cả giai đoạn     │ pH: 7.0 - 8.0                             │
└──────────────────────┴────────────────────────────────────────────┘
```

**D. Cảnh báo mật độ nuôi**
- Mật độ nuôi: Cảnh báo khi đạt **37 kg/m²**

#### 7.6.2 Công Thức Tính Toán (Simplified Model)

```
DO (Dissolved Oxygen) - mg/L
DO = 5.5 - (Sinh_khối / 1000) × 0.5 - Random(0, 1.5)

pH
pH = 7.2 + Random(-0.3, 0.3) + Chemical_adjustment

H2S - mg/L
H2S = (Sinh_khối / 1000) × 0.0005 - (Vệ_sinh × 0.02)

NH3 - mg/L
NH3 = (Sinh_khối / 100) × 0.001 - (Thay_nước × 0.1)

TIÊU CHUẨN AN TOÀN:
- DO: > 5.0 mg/L (tối thiểu 3.0)
- pH: 6.5-8.5
- H2S: < 0.05 mg/L
- NH3: < 0.2 mg/L
```

**Lưu ý**:
- Sử dụng quy tắc theo thực tế (7.6.1) cho production
- Sử dụng mô hình đơn giản (7.6.2) cho training/simulation

### 7.7 Thuật toán FEFO (First-Expired, First-Out)

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

### 7.8 Thuật toán Auto-Split Receipt

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

### 7.9 Cost Calculation Logic

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

## 8. 11 SIMULATION ENGINES

### 8.1 Engine 1: EnvironmentGenerator

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

### 8.2 Engine 2: MortalityEngine

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

### 8.3 Engine 3: GrowthEngine

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

### 8.4 Engine 4: FeedPlanner

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

### 8.5 Engine 5: ChemicalEngine

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

### 8.6 Engine 6: WaterOpsEngine

**Chức năng**: Quản lý thay nước

**Logic**:
- DO nguy hiểm → thay nước ngay
- Lịch thay nước theo chu kỳ tháng
- Tính toán lượng nước cấp/thoát

**Output**:
- Water intake/discharge (m³)
- Tần suất thay nước

---

### 8.7 Engine 7: InventoryEngine

**Chức năng**: FEFO allocation

**Thuật toán FEFO**:
1. Lấy available batches
2. Sắp xếp theo ExpiryDate ASC
3. Allocate theo FIFO
4. Tạo PO nếu thiếu

**Output**: Allocated qty, shortage qty

---

### 8.8 Engine 8: CostTracker

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

### 8.9 Engine 9: AlertSystem

**Chức năng**: Phát sinh cảnh báo

**Alert Levels**:
- CRITICAL: Phải xử lý trong 1 giờ
- WARNING: Xử lý trong 24 giờ
- INFO: Thông báo thông tin

**Categories**:
- WATER_QUALITY
- HEALTH
- INVENTORY
- COST
- GROWTH

**Output**: AlertLogs records

---

### 8.10 Engine 10: ValidationService

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

### 8.11 Engine 11: ReportingEngine

**Chức năng**: Xuất báo cáo & biểu mẫu

**Output**:
- 8 FSIS forms
- Excel/PDF/Word
- Dashboard data
- Cycle summary

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
  │   ├─> Determine chemical needs
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
      ├─> Check all thresholds
      ├─> Generate alert messages
      ├─> Store in AlertLogs
      └─> Send notifications if needed

END
```

### 9.2 Khởi tạo Chu kỳ Nuôi

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

### 9.3 Replay Mode (Tái Sinh Dữ Liệu)

**Mục đích**: Kiểm tra tính deterministic

**Quy trình**:
1. Tìm Manifest của chu kỳ cũ
2. Load Seed, Version, Weather data
3. Tái sinh toàn bộ 90 ngày
4. So sánh checksum từng ngày
5. Báo cáo "PASS ✅" hoặc "FAIL ❌"

### 9.4 Manual Override

**Mục đích**: Điều chỉnh dữ liệu sinh tự động khi cần thiết

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

## 10. 8 FSIS FORMS

### 10.1 P301-F01: Nhật ký nuôi (90 dòng)

**Mục đích**: Daily log

**Nội dung**:
- Ngày, Tuổi cá
- Nhiệt độ (AM/PM)
- DO, pH
- Cá chết, TLBQ
- Thức ăn
- Ghi chú

**Watermark**: "MOCKED DATA - FOR TRAINING ONLY"

---

### 10.2 P301-F06: Biên bản giao nhận TA

**Mục đích**: Feed delivery

**Nội dung**:
- Ngày giao
- Tên thức ăn
- Số lượng (kg)
- Batch code
- Hạn sử dụng
- Người giao, Người nhận

---

### 10.3 P301-F07: Sổ theo dõi TA

**Mục đích**: Feed inventory

**Nội dung**:
- Ngày
- Tên thức ăn
- Nhập (kg)
- Xuất (kg)
- Tồn (kg)
- Batch code
- HSD

---

### 10.4 P303-F03: Phiếu giao hàng HC

**Mục đích**: Chemical delivery

**Nội dung**:
- Ngày giao
- Tên hóa chất
- Số lượng
- Batch code
- HSD
- Người giao, Người nhận

---

### 10.5 P303-F04: Sổ theo dõi HC

**Mục đích**: Chemical inventory

**Nội dung**:
- Ngày
- Tên hóa chất
- Nhập
- Xuất
- Tồn
- Batch code
- HSD

---

### 10.6 P303-F06: Phiếu chỉ định sản phẩm

**Mục đích**: Product specification

**Nội dung**:
- Thông tin sản phẩm
- Quy cách
- Chất lượng
- Người đề nghị
- Người duyệt
- Trạng thái: Draft/Pending/Approved/Rejected

---

### 10.7 P303-F07: Phiếu theo dõi sức khỏe

**Mục đích**: Health monitoring

**Nội dung**:
- Ngày kiểm tra
- TLBQ
- Ký sinh trùng
- Dấu hiệu lâm sàng
- Điều trị
- Bác sĩ thú y

---

### 10.8 P305-F37: Sổ giao nhận chất thải

**Mục đích**: Waste transfer

**Nội dung**:
- Ngày
- Loại chất thải
- Số lượng (kg)
- Phương pháp xử lý
- Người giao
- Người nhận

---

## 11. USER ROLES & PERMISSIONS

### 11.1 Role-Based Access Control (RBAC)

| Role | Permissions |
|------|-----------|
| **ADMIN** | ✓ All CRUD operations<br>✓ User management<br>✓ System configuration<br>✓ View audit trail<br>✓ Backup/Restore |
| **MANAGER** | ✓ View all data<br>✓ Edit cycles & daily logs<br>✓ Approve workflows<br>✓ Generate reports<br>✗ Delete master data<br>✗ User management |
| **STAFF** | ✓ View assigned ponds/cycles<br>✓ Edit daily logs (own pond)<br>✓ Submit for approval<br>✗ Delete any data<br>✗ View other ponds |
| **VIEWER** | ✓ Read-only access (all data)<br>✗ Edit/Delete anything |

---

## 12. ALERT THRESHOLDS & RULES

### 12.1 CRITICAL Alerts

| Condition | Threshold | Action Required |
|-----------|-----------|---------|
| DO | < 3.0 mg/L | Bật máy sục ngay |
| Mortality | > 5%/day | Liên hệ thú y |
| Temperature | <20°C or >35°C | Thay nước ngay |
| pH | <6.0 or >9.0 | Điều chỉnh pH ngay |
| H2S | > 0.1 mg/L | Vệ sinh đáy ngay |
| NH3 | > 0.5 mg/L | Giảm thức ăn 50% |
| Stock HSD | < 7 days | Đặt hàng bổ sung |

### 12.2 WARNING Alerts

| Condition | Threshold | Action Required |
|-----------|-----------|---------|
| DO | 3.0-4.0 mg/L | Chuẩn bị bật máy sục |
| Mortality | 2-5%/day | Theo dõi chặt |
| Temperature | 25-28 or 32-35°C | Chuẩn bị thay nước |
| pH | 6.0-6.5 or 8.5-9 | Chuẩn bị điều chỉnh |
| H2S | 0.05-0.1 mg/L | Vệ sinh sơ bộ |
| NH3 | 0.3-0.5 mg/L | Giảm thức ăn 30% |
| FCR | > 2.5 | Kiểm tra thức ăn |
| Stock HSD | < 30 days | Đặt hàng bổ sung |

### 12.3 INFO Alerts

- Milestone reached (Day 30, 60, 90)
- Growth rate trend update
- Harvest prediction ready
- Report available
- Daily log completed

---

## 13. GIAO DIỆN & BÁO CÁO

### 13.1 Main Dashboard

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

### 13.2 Menu Structure

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

### 13.3 Sample Report: P301-F01 (Daily Log)

```
═══════════════════════════════════════════════════════════════════
             NHẬT KÝ NUÔI CÁ - DAILY FARMING LOG
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

## 14. SECURITY & AUDIT

### 14.1 Authentication & Authorization

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

### 14.2 Audit Trail Implementation

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

### 14.3 Decisioning Matrix (Quy Tắc Tự Động)

```
┌────────────────────────────────────────────────────────────────────────────┐
│ IF Condition                │ THEN Action          │ Threshold │ Priority │
├─────────────────────────────┼──────────────────────┼───────────┼──────────┤
│ DO < 3 mg/L                 │ Alert CRITICAL       │ 3.0       │ 🔴 NGAY  │
│                             │ + Bật máy sục khí    │           │          │
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

## 15. TESTING & PERFORMANCE

### 15.1 Testing Strategy

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

### 15.2 Performance Benchmarks

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

### 15.3 Load Testing Scenarios

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

## 16. TRIỂN KHAI & MIGRATION

### 16.1 Implementation Phases

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

**Total Timeline**: 14 tuần (3.5 tháng) + Ongoing support

### 16.2 Data Migration from Excel

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

### 16.3 Deployment Checklist

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

## 17. USER GUIDE (FSIS FORMS)

### 17.1 Mục Đích

Form **FSIS Reports** được sử dụng để xem và xuất báo cáo tuân thủ an toàn thực phẩm cho các vòng nuôi tôm/cá.

### 17.2 Quy Trình Sử Dụng

**Bước 1**: Mở Form FSIS Reports

**Bước 2**: Chọn Loại Báo Cáo (8 loại)

**Bước 3**: Chọn Ao Nuôi

**Bước 4**: Chọn Vòng Nuôi

**Bước 5**: [Tùy Chọn] Lọc Theo Khoảng Ngày

**Bước 6**: Bấm Nút "Xem Dữ Liệu"

**Bước 7**: Xem Dữ Liệu Trong Bảng

**Bước 8**: [Tùy Chọn] Xuất Dữ Liệu Ra Excel

**Bước 9**: [Tùy Chọn] Xóa Dữ Liệu

**Bước 10**: Đóng Form

### 17.3 Ví Dụ Thực Tế

#### Ví Dụ 1: Xem Nhật Ký Nuôi

1. **Loại báo cáo**: Chọn `P301-F01 - Nhật ký nuôi`
2. **Ao nuôi**: Chọn `P001 - Ao nuôi 1`
3. **Vòng nuôi**: Chọn `C202401 - Vòng nuôi tháng 1/2024`
4. **Lọc theo ngày**: Tích, chọn từ 01/01/2024 đến 31/01/2024
5. **Xem dữ liệu** → Thấy dữ liệu nhật ký

#### Ví Dụ 2: Xuất Báo Cáo Thức Ăn

1. **Loại báo cáo**: Chọn `P301-F07 - Sổ theo dõi thức ăn`
2. **Ao nuôi**: Chọn `P002 - Ao nuôi 2`
3. **Vòng nuôi**: Chọn `C202312 - Vòng nuôi tháng 12/2023`
4. **Xem dữ liệu** → Thấy dữ liệu
5. **Xuất Excel** → Lưu file

### 17.4 Lưu Ý Quan Trọng

**Khi Nào Nên Sử Dụng Form Này?**
- ✅ Khi cần xem báo cáo FSIS
- ✅ Khi cần xuất dữ liệu ra Excel
- ✅ Khi cần kiểm tra lịch sử
- ❌ KHÔNG dùng để nhập dữ liệu mới

**Gặp Lỗi Gì Thì Làm?**

| Lỗi | Cách Xử Lý |
|---|---|
| "Không có dữ liệu" | Kiểm tra xem ao/vòng nuôi đó có dữ liệu không |
| Form không load danh sách ao | Kiểm tra kết nối database |
| Nút "Xuất Excel" bị tắt | Bấm "Xem Dữ Liệu" trước |

---

## 18. PHỤ LỤC

### 18.1 Glossary - Thuật ngữ

| Tiếng Anh | Tiếng Việt | Giải thích |
|-----------|-----------|-----------|
| Fingerling | Giống | Cá/tôm giống để thả nuôi |
| Stocking | Thả giống | Quá trình đưa giống vào ao |
| Cycle | Vụ/Chu kỳ nuôi | 90 ngày từ thả giống đến thu hoạch |
| Biomass | Sinh khối | Tổng khối lượng cá/tôm hiện tại |
| TLBQ | Trọng lượng bình quân | Average weight (g/con) |
| FCR | Hệ số chuyển đổi | Feed Conversion Ratio |
| DO | Oxy hòa tan | Dissolved Oxygen (mg/L) |
| FEFO | First-Expired, First-Out | Xuất hàng theo HSD sớm nhất |
| Batch Code | Mã lô | Mã theo dõi lô sản xuất |
| HSD | Hạn sử dụng | Expiry Date |

### 18.2 Danh Mục Hóa Chất (Chemical Catalog)

**Danh sách hóa chất sử dụng tại trang trại:**

| STT | Tên Hóa Chất | Lượng Sử Dụng | Công Dụng | Nhà Sản Xuất | Quy Cách |
|-----|-------------|---------------|-----------|--------------|----------|
| 1 | VITALUCAN - B12 NEW | 3kg/1 tấn TA | Bổ sung dinh dưỡng | Công ty Cổ Phần UV | 1 kg/gói |
| 2 | VIMELEC CONCENTRATED | 1kg/1 tấn TA | Bổ sung dinh dưỡng | Công ty TNHH MTV Thuốc thú y & Chế phẩm sinh học Vemedim | 1 kg/gói |
| 3 | VITAMIN C ANTISTRESS | 1kg/500kg TA | Bổ sung dinh dưỡng | Công ty TNHH MTV Thuốc thú y & Chế phẩm sinh học Vemedim | 1 kg/gói |
| 4 | UV - FeB12 max | 1 lít/500kg TA | Bổ sung dinh dưỡng | Công ty Cổ Phần UV | 1 lít/chai |
| 5 | UV-ZYMLUS MAX | 1 lít/700kg TA | Bổ sung dinh dưỡng | Công ty Cổ Phần UV | 1 lít/chai |
| 6 | PZOZYME | 1kg/500kg TA | Bổ sung dinh dưỡng | Công ty Cổ Phần UV | 1 kg/gói |
| 7 | HEPAMIN super | 1 lít/300kg TA | Bổ sung dinh dưỡng | Công ty Cổ Phần UV | 1 lít/chai |
| 8 | BIO IMMUNE-100 | 1 lít/1 tấn TA | Bổ sung dinh dưỡng | CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ KHANG ANH | 1 lít/chai |
| 9 | PHYLUS | 2kg/1 tấn TA | Bổ sung dinh dưỡng | Công ty TNHH MTV Thuốc thú y & Chế phẩm sinh học Vemedim | 1 kg/gói |
| 10 | UV-BIOMAX | 1kg/500kg TA | Bổ sung dinh dưỡng | Công ty Cổ Phần UV | 1 kg/gói |
| 11 | VITALEC FISH + | 1kg/1 tấn TA | Bổ sung dinh dưỡng | Provimi | 1 kg/gói |

**Lưu ý**:
- TA = Thức ăn
- Danh mục này có thể được bổ sung thêm tùy theo nhu cầu của từng vùng nuôi
- Hóa chất dạng lỏng: Cảnh báo khi tổng lượng trong kho vượt 90% sức chứa
- Cần theo dõi HSD và MSL (Mã số lô) cho từng lô nhập kho

### 18.3 Yêu Cầu Thao Tác & Nghiệp Vụ

**Các yêu cầu chức năng bổ sung từ thực tế:**

1. **Nhật ký nuôi**:
   - Cho phép nhập liệu: Thời gian thu hoạch, Sản lượng thu hoạch, TLBQ thu hoạch và thu tỉa, FCR
   - Cảnh báo khi mật độ nuôi đạt 37kg/m²
   - Có trường nhập tên người phụ trách ao và cho phép thay đổi khi luân chuyển nhân sự
   - Báo cáo tốc độ tăng trưởng, mật độ của tất cả các ao khi chọn 1 ngày bất kỳ

2. **Sổ giao nhận chất thải (P305-F37)**:
   - Tổng hợp số lượng cá chết kg/ngày (trừ lượng cá chết vượt ngưỡng)
   - Tổng hợp lượng thức ăn theo đơn vị tính (bao/túi) để tính bao bì rỗng (40kg/bao, 600kg/túi)

3. **Phiếu sức khỏe cá nuôi (P303-F07)**:
   - Tổng hợp thông tin ngày cân mẫu: Ngày, ao, số con cá chết, TLBQ, loại + lượng hóa chất

4. **Phiếu chỉ định sản phẩm (P303-F06)**:
   - Tổng hợp thông tin ngày sử dụng hóa chất (trừ thuốc trị bệnh và ký sinh)
   - Thông tin: Ngày, Ao, tên sản phẩm, đơn vị tính, lượng, lý do sử dụng

5. **Sổ kho thức ăn (P301-F07)**:
   - Tổng hợp lượng thức ăn theo kho tương ứng
   - Phân biệt theo kích cỡ từng loại
   - Nhập tay: Ngày nhập, lượng, MSL, quy cách
   - HSD tính từ MSL: Ký tự 2-4 từ bên phải (ngày Julian) + 89 ngày
   - Cảnh báo: Ngày nhập trước ngày sản xuất hoặc hết HSD

6. **Sổ kho hóa chất (P303-F04)**:
   - Tổng hợp lượng hóa chất theo loại
   - Nhập tay: Ngày nhập, lượng, MSL, HSD
   - Lấy thông tin nhà sản xuất và quy cách từ danh mục
   - Cảnh báo hết HSD
   - Cảnh báo hóa chất lỏng khi tổng kho vượt 90% sức chứa

7. **Biên bản giao nhận thức ăn (P301-F06)**:
   - Tổng hợp từ P301-F07: Ngày, loại, lượng, quy cách, MSL, kho
   - Cho chọn: Ghe vận chuyển, người vận chuyển
   - Cho nhập: Tên người nhận
   - Cố định: 48h trước tại "Huyện Cao Lãnh - Đồng Tháp"

8. **Biên bản giao nhận hóa chất (P303-F03)**:
   - Tổng hợp từ P303-F04: Ngày, tên hàng, lượng, quy cách, MSL/HSD, nhà sản xuất
   - Cho nhập: Tên người nhận
   - Cố định: Người giao "Lê Thị Hồng Ngọc", 48h trước tại "Thành phố Cao Lãnh - Đồng Tháp"

9. **Cấp thoát nước**:
   - Cho phép chọn nhịp trao đổi nước của vùng khi bắt đầu chạy phần mềm

### 18.4 Data Validation Rules

**BUSINESS RULES**:
- Pond không thể có 2 cycles active cùng lúc
- FCR không thể < 1.0 (không hợp lý)
- Survival rate không thể > 100%
- Feed amount không thể > 10% body weight
- Temperature: 15-40°C (ngoài là lỗi)
- pH: 4.0-11.0 (ngoài là invalid)
- DO: 0-20 mg/L (outside = error)
- Expiry date phải > Manufacturing date
- Batch code phải unique trong warehouse
- User phải có role để access function
- Daily log không thể có > 5% missing fields

### 18.3 Known Limitations

**CURRENT VERSION 4.0**:
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

### 18.4 Contact & Support

**TECHNICAL SUPPORT**:
- Email: support@aquasim.vn
- Phone: (028) 3-XXXX-XXXX
- Hours: Mon-Fri 8:00-17:00

**TRAINING**:
- Email: training@aquasim.vn
- Duration: 2-4 hours
- Topics: Basic usage, Reports, Admin

---

## DISCLAIMER & WATERMARK REQUIREMENTS

### TUYÊN BỐ MIỄN TRÁCH

**Dữ Liệu Mô Phỏng**:
- Tất cả dữ liệu được sinh **TỰ ĐỘNG** từ công thức mô phỏng
- **KHÔNG PHẢI** dữ liệu thực từ trang trại
- **Mục đích**: Đào tạo, chuẩn hóa biểu mẫu, phân tích
- **KHÔNG** sử dụng cho báo cáo chính thức

### WATERMARK BẮT BUỘC

**Watermark Requirement**:
```
"MOCKED DATA - FOR TRAINING ONLY"
```

**Phải có trên tất cả**:
- ✅ Biểu mẫu xuất (XLSX/DOCX/PDF)
- ✅ Header báo cáo
- ✅ File CSV/JSON export
- ✅ Dashboard preview
- ✅ Print outputs

### HẠN CHẾ SỬ DỤNG

**KHÔNG được phép**:
- ❌ Gửi báo cáo này cho chính quyền
- ❌ Sử dụng cho kiểm định/chứng nhận
- ❌ Xóa watermark
- ❌ Phát hành công khai
- ❌ Thay thế dữ liệu thực tế

**Được phép**:
- ✅ Dùng để đào tạo nhân viên
- ✅ Test tính năng hệ thống
- ✅ Demo cho khách hàng (với watermark)
- ✅ Phân tích công thức
- ✅ Kiểm tra layout biểu mẫu
- ✅ Training & simulation purposes

---

## DOCUMENT METADATA

| Property | Value |
|----------|-------|
| **Document ID** | SRS-AQUASIM-4.1-ENHANCED |
| **Version** | 4.1 Enhanced with Operational Data |
| **Status** | UPDATED |
| **Date** | 14/11/2025 |
| **Total Pages** | ~85 pages |
| **Word Count** | ~32,000 words |
| **Author** | Technical Team |
| **Reviewer** | Project Manager |
| **Approver** | Client Representative |
| **Data Source** | QLCLN_all_sheets.json (Farm operational data) |

---

## CHANGE HISTORY

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 15/10/2025 | Initial draft from business requirements |
| v2.0 | 25/10/2025 | Added technical architecture |
| v3.0 | 04/11/2025 | Added security, audit, testing sections |
| v4.0 | 06/11/2025 | Consolidated: Removed duplicates, unified structure |
| v4.0 FINAL | 14/11/2025 | Final consolidation - Complete standalone document |
| **v4.1** | **14/11/2025** | **Integrated detailed operational data from QLCLN_all_sheets.json:**<br>- Updated growth curve with actual farm data (Section 7.2)<br>- Enhanced mortality rules with real thresholds (Section 7.3)<br>- Added detailed feed allocation rules (Section 7.4)<br>- Integrated environment monitoring rules (Section 7.6)<br>- Expanded water exchange procedures (Section 4.5)<br>- Added chemical catalog (Appendix 18.2)<br>- Added operational requirements (Appendix 18.3) |

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

**CONFIDENTIAL** - For authorized personnel only
© 2025 AquaSim System. All rights reserved.
