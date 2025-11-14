# TAI LIEU DAC TA YEU CAU PHAN MEM (SRS)
## He thong AquaSim - Quan ly Trang trai Nuoi Thuy san Tu dong
### Phien ban: 4.0 Final Consolidated
### Ngay: 14/11/2025

---

## METADATA

| Property | Value |
|----------|-------|
| **Document ID** | SRS-AQUASIM-4.0-FINAL |
| **Version** | 4.0 Final Consolidated |
| **Status** | APPROVED |
| **Date** | 14/11/2025 |
| **Author** | Technical Team |
| **Reviewer** | Project Manager |
| **Approver** | Client Representative |
| **Total Words** | ~25,000 words |

---

## MUC LUC

1. [TOM TAT DIEU HANH (Executive Summary)](#1-tom-tat-dieu-hanh)
2. [TONG QUAN DU AN](#2-tong-quan-du-an)
3. [YEU CAU CHUC NANG (FUNCTIONAL REQUIREMENTS)](#3-yeu-cau-chuc-nang)
4. [YEU CAU PHI CHUC NANG (NON-FUNCTIONAL REQUIREMENTS)](#4-yeu-cau-phi-chuc-nang)
5. [CONG THUC & THUAT TOAN](#5-cong-thuc--thuat-toan)
6. [QUY TRINH NGHIEP VU](#6-quy-trinh-nghiep-vu)
7. [11 SIMULATION ENGINES](#7-11-simulation-engines)
8. [8 FSIS FORMS](#8-8-fsis-forms)
9. [USER ROLES & PERMISSIONS](#9-user-roles--permissions)
10. [ALERT THRESHOLDS & RULES](#10-alert-thresholds--rules)
11. [TEST CASES & ACCEPTANCE CRITERIA](#11-test-cases--acceptance-criteria)
12. [USER GUIDE (FSIS FORMS)](#12-user-guide-fsis-forms)
13. [PHU LUC](#13-phu-luc)

---

## 1. TOM TAT DIEU HANH

### 1.1 Van de Hien tai

- ✗ **Excel quan ly**: Khong dong bo, de loi
- ✗ **Theo doi thu cong**: Ton thoi gian, sai sot
- ✗ **Bao cao khong chuan**: Khong dat tieu chuan FSIS

### 1.2 Giai phap AquaSim

- ✅ **Tu dong hoa 100%** chu ky nuoi (90 ngay)
- ✅ **Sinh du lieu thong minh** tu 1 form input
- ✅ **Quan ly FEFO** kho thuc an & hoa chat
- ✅ **Xuat chuan FSIS** 8 bieu mau
- ✅ **Deterministic simulation** (cung seed = cung ket qua)
- ✅ **Replay mode** de xac minh tinh nhat quan

### 1.3 KPIs Chinh

| Chi so | Target | Hien tai | Cai thien |
|--------|--------|---------|----------|
| Ngay input | 90 ngay | 1 day | **99%** |
| FCR (Feed Conversion) | < 2.0 | 2.3 | **13%** |
| Survival Rate | > 85% | 82% | **3%** |
| Bao cao chuan | 8/8 | 2/8 | **300%** |
| Compliance | 100% | 60% | **67%** |

---

## 2. TONG QUAN DU AN

### 2.1 Gioi thieu AquaSim

**AquaSim** la he thong quan ly trang trai nuoi thuy san toan dien, duoc thiet ke de:

| Muc tieu | Chi tiet |
|----------|----------|
| **Tu dong hoa** | Quy trinh sinh du lieu toan chu ky 90 ngay |
| **Thay the Excel** | Cac quy trinh theo doi thu cong |
| **Chuan hoa bao cao** | Theo tieu chuan FSIS (8 form) |
| **Ho tro** | Mo phong va du bao cho muc dich dao tao |
| **Deterministic** | Cung seed → cung ket qua (reproducible) |

### 2.2 Pham vi Toan dien

**Master Data Management (MDM)**
- Farms, Ponds, Warehouses
- FeedInventory, ChemicalInventory
- Users & Permissions

**Operational Management (Ops)**
- Fish Stocking (Tha giong)
- Farming Cycles (90 ngay)
- Daily Logs & Health Monitoring
- Water Quality Management
- Waste Management

**Inventory Management**
- Receipt (Nhap kho) with auto-split by capacity
- Issue (Xuat kho) with FEFO algorithm
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

### 2.3 Dinh nghia & Thuat ngu

| Thuat ngu | Tieng Viet | Giai thich |
|-----------|-----------|-----------|
| **Farm** | Vung nuoi/Trang trai | Khu vuc dia ly chua nhieu ao |
| **Pond** | Ao | Don vi nuoi rieng le |
| **Cycle** | Vu nuoi | Tu tha giong den thu hoach (90 ngay) |
| **Fingerling** | Giong | Ca/tom giong de tha nuoi |
| **TLBQ** | Trong luong binh quan | Average weight (g/con) |
| **Biomass** | Sinh khoi | Tong khoi luong ca/tom (kg) |
| **FCR** | He so chuyen doi thuc an | Feed Conversion Ratio |
| **DO** | Oxy hoa tan | Dissolved Oxygen (mg/L) |
| **FEFO** | First-Expired, First-Out | Xuat theo HSD som nhat |
| **MSL/Batch Code** | Ma so lo | Ma theo doi lo san xuat |
| **HSD** | Han su dung | Expiry Date |
| **ASC/BAP** | Chung nhan | Aquaculture Stewardship Council / Best Aquaculture Practices |

---

## 3. YEU CAU CHUC NANG

### 3.1 Master Data Management (FR-MDM)

#### FR-MDM-001: Farm Management
- **CRUD Operations**: Them, sua, xoa thong tin farm
- **Luu tru**: Ten, dia chi, toa do, chung nhan (ASC, BAP, GG)
- **Pham vi**: Quan ly vung/khu vuc
- **Cau hinh**: Tham so rieng (gioi han nuoc, aeration)

#### FR-MDM-002: Pond Management
- **CRUD Operations**: Them, sua, xoa thong tin ao
- **Luu tru**: Dien tich, do sau, dung tich, loai ao
- **Theo doi**: Ngay chuan bi, phuong phap chuan bi
- **Muc nuoc**: 5 level tuy chinh

#### FR-MDM-003: Warehouse Management
- **CRUD Operations**: Them, sua, xoa kho
- **Luu tru**: Ten, ma, suc chua toi da (CapacityKg)
- **Dieu kien**: Theo doi dieu kien luu kho
- **Real-time**: Giam sat muc ton kho

#### FR-MDM-004: Product Management
- **Feed Inventory**: Loai thuc an, protein %, quy cach
- **Chemical Inventory**: Hoa chat, nong do, quy cach
- **Thong tin**: Nha san xuat, HSD, gia
- **Phan loai**: Feed, Chemical, Supplement, Environment

#### FR-MDM-005: User & Role Management
- **Tao/Quan ly**: Tai khoan nguoi dung
- **Roles**: Admin, Manager, Staff, Viewer
- **Audit Trail**: Log moi thao tac
- **Pham vi**: Trach nhiem theo thoi gian

---

### 3.2 Operational Management (FR-OPS)

#### FR-OPS-001: Fish Stocking
- **Ghi nhan**: Nguon giong, chat luong
- **Theo doi**: Mat do, so luong tha
- **Thong tin**: Tuoi, kich co fingerling
- **San luong**: Ky vong theo ao

#### FR-OPS-002: Farming Cycle (90 ngay)
- **Khoi tao**: Voi thong so dau vao (StartDate, SeedQty, FCR, etc.)
- **Trang thai**: PLANNING → ACTIVE → MEDICATING → HARVESTING → CLOSED → CANCELLED
- **Theo doi**: FCR, ty le chet, growth curve
- **Chi tiet**: 90 ngay du lieu

#### FR-OPS-003: Daily Logs
- **Ghi nhan hang ngay**: Thuc an, ca chet, pH, DO, nhiet do
- **Sinh khoi & TLBQ**: Tinh toan tu dong
- **Ghi chu**: Su kien dac biet
- **Form**: Tham chieu P301-F01

#### FR-OPS-004: Health Monitoring
- **TLBQ & Benh**: Ky sinh trung, dau hieu lam san
- **Hao hut**: Ty le hao hut theo ao
- **Dieu tri**: Ghi nhan & hieu qua
- **Form**: Tham chieu P303-F07

#### FR-OPS-005: Water Management
- **Cap/Thoat**: Luong nuoc (m³)
- **Giam sat**: DO, pH, H2S, NH3
- **Lich thay**: Theo chu ky
- **Form**: Tham chieu P304-F04

#### FR-OPS-006: Waste Management
- **Loai & So luong**: Chat thai
- **Xu ly**: Phuong phap xu ly
- **Giao nhan**: Chu ky
- **Form**: Tham chieu P305-F37

---

### 3.3 Inventory Management (FR-INV)

#### FR-INV-001: Receipt (Nhap kho)
- **Ghi nhan**: BatchCode, ExpiryDate
- **Direction**: 'I' (Inbound)
- **Auto-split**: Neu vuot CapacityKg
- **Stored Procedure**: sp_SplitReceiptByCapacity

#### FR-INV-002: Issue (Xuat kho) - FEFO
- **Direction**: 'O' (Outbound)
- **Lien ket**: Voi CycleID
- **Quy tac**: FEFO (First-Expired, First-Out)
- **Stored Procedure**: sp_AllocateFEFO

#### FR-INV-003: Stock Real-time
- **Cong thuc**: Stock = SUM(Nhap) - SUM(Xuat)
- **Canh bao**: HSD sap het (< 30 ngay)
- **Bao cao**: Theo lo, theo HSD
- **Dashboard**: Ton kho real-time

---

### 3.4 Auto-Generator & Simulation (FR-AUTO)

#### FR-AUTO-001: Scenario Input
Khai bao kich ban voi tham so:
- PondID, StartDate, EndDate
- SeedQty, AvgWeightG, FCR, InvisibleLossRate
- WarehouseID, FeedID
- Seed (for determinism)

#### FR-AUTO-002: Daily Pipeline (10 Steps)
Thuc hien tuan tu moi ngay:
1. WEATHER ANCHOR → Fetch temperature baseline
2. ENVIRONMENT GENERATOR → DO, pH, H2S, NH3
3. MORTALITY ENGINE → Ca chet, Ty le song
4. GROWTH ENGINE → TLBQ, Sinh khoi
5. FEED PLANNER → Thuc an, lam tron
6. CHEMICALS ENGINE → Hoa chat theo quy tac
7. WATER EXCHANGE → Tan suat thay nuoc
8. INVENTORY SYNTHESIZER → FEFO xuat kho
9. DAILY LOG SAVE → Luu vao DB
10. ALERT GENERATION → Canh bao CRITICAL/WARNING/INFO

#### FR-AUTO-003: Determinism
- **Cung seed** → Cung ket qua
- **Luu manifest**: Voi seed, version, checksum
- **Verification**: sp_VerifyDeterminism

#### FR-AUTO-004: Replay Mode (Tai Sinh Du lieu)
- **Deterministic**: Cung seed → cung ket qua 100%
- **Manifest**: Luu tru seed, version, weather, checksums
- **Quy trinh**:
  1. Tim Manifest cua chu ky cu
  2. Nhan "Replay"
  3. He thong tai sinh y het (cung seed, version, weather)
  4. So sanh checksum tung ngay
  5. Bao cao "Determinism: PASS ✅" hoac "FAIL ❌"
- **Muc dich**: Kiem tra tinh nhat quan, tai tao ket qua

#### FR-AUTO-005: Manual Override
- **Chuc nang**: Cho phep sua du lieu tung ngay sau khi sinh
- **Audit Trail**: Tu dong log moi thay doi
  - Ngay
  - Truong (field_name)
  - Gia tri cu → Gia tri moi
  - Nguoi sua (user email)
  - Timestamp
- **Recalculation**: Tu dong tinh lai tu ngay sua tro di (FCR, cost, profit)
- **Warning**: Bao cao ghi chu "Override Day X: field_name"
- **Rang buoc**:
  - Khong cho sua qua 20% tong so ngay
  - Phai co ly do sua doi
  - Chi user co quyen Manager+ moi duoc sua

---

### 3.5 Workflow & Approval (FR-WF)

#### FR-WF-001: Product Specification Approval
- **Form**: P303-F06 (Phieu chi dinh san pham)
- **Quy trinh**: Draft → Pending → Approved/Rejected
- **Trach nhiem**: Nguoi de nghi, Quan ly duyet

#### FR-WF-002: Waste Transfer Approval
- **Form**: P305-F37 (So giao nhan chat thai)
- **Ky**: Nguoi giao + Nguoi nhan
- **Timestamp**: Ghi chep thoi gian + audit trail

---

### 3.6 Reporting & Analytics (FR-RP)

#### FR-RP-001: Standard Reports
- Bao cao tong hop ngay/tuan/thang
- Bao cao tuan thu moi truong
- Bao cao ton kho FEFO
- Bao cao suc khoe & FCR

#### FR-RP-002: 8 FSIS Forms

| Code | Ten bieu mau | Muc dich |
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
- Excel (XLSX) voi EPPlus
- PDF voi iText7
- Word (DOCX) voi OpenXML
- CSV cho data exchange

---

## 4. YEU CAU PHI CHUC NANG

### 4.1 Hieu nang (NFR-PERF)

| ID | Yeu cau | Tieu chuan |
|----|---------|-----------|
| NFR-PERF-001 | CRUD response | ≤ 2 giay |
| NFR-PERF-002 | Query 10,000 records | ≤ 1 giay |
| NFR-PERF-003 | Auto-Generate 365 ngay × 1000 ao | < 30 giay |
| NFR-PERF-004 | Export bao cao | ≤ 10 giay |
| NFR-PERF-005 | Concurrent users | 50 users |

### 4.2 Bao mat (NFR-SEC)

| ID | Yeu cau | Chi tiet |
|----|---------|---------|
| NFR-SEC-001 | Authentication | Username/Password with BCrypt hash |
| NFR-SEC-002 | Authorization | Role-Based Access Control (RBAC) |
| NFR-SEC-003 | Audit Trail | Log moi thay doi du lieu |
| NFR-SEC-004 | Data Encryption | Encrypt sensitive data at rest |
| NFR-SEC-005 | Password Policy | Min 8 chars, complexity rules |
| NFR-SEC-006 | Login Protection | Max 5 failed attempts → Lock account |
| NFR-SEC-007 | Session Timeout | Auto-logout after 30 mins |

### 4.3 Do tin cay (NFR-REL)

| ID | Yeu cau | Tieu chuan |
|----|---------|-----------|
| NFR-REL-001 | System Availability | ≥ 99.5% |
| NFR-REL-002 | Data Integrity | Transaction with rollback |
| NFR-REL-003 | Backup | Daily automatic backup |
| NFR-REL-004 | Recovery | Point-in-time recovery (30 days) |
| NFR-REL-005 | Network Issues | Graceful handling |

### 4.4 Kha nang su dung (NFR-USAB)

| ID | Yeu cau | Chi tiet |
|----|---------|---------|
| NFR-USAB-001 | UI Design | Truc quan, nhat quan |
| NFR-USAB-002 | Language | Tieng Viet + Tieng Anh |
| NFR-USAB-003 | Help System | Context-sensitive help |
| NFR-USAB-004 | Training | < 2 gio dao tao |
| NFR-USAB-005 | Excel-like | Giong Excel hien tai |

### 4.5 Kha nang mo rong (NFR-SCALE)

| ID | Yeu cau | Capacity |
|----|---------|----------|
| NFR-SCALE-001 | Farms | Toi 100 farms |
| NFR-SCALE-002 | Ponds | Toi 1000 ponds |
| NFR-SCALE-003 | Historical Data | 5 nam |
| NFR-SCALE-004 | Database | Partitioning support |
| NFR-SCALE-005 | Modular Design | Plugin architecture |

---

## 5. CONG THUC & THUAT TOAN

### 5.1 Cong thuc Sinh khoi (Biomass)

```
SINH KHOI (kg)
Sinh_khoi = (So_ca × TLBQ) / 1000

Trong do:
- So_ca: So luong ca hien tai (con)
- TLBQ: Trong luong binh quan (g/con)
```

### 5.2 Cong thuc Tang truong (Growth Rate)

```
TANG TRUONG HANG NGAY
Actual_growth = Base_growth × He_so_dieu_chinh

Base Growth theo tuoi:
┌────────────────────┬──────────────┬─────────────────────┐
│ Tuoi (ngay)        │ Tang/ngay    │ TLBQ cuoi giai doan │
├────────────────────┼──────────────┼─────────────────────┤
│ 0-10               │ +0.2 g/con   │ 1.5 → 3.5           │
│ 11-30              │ +0.5 g/con   │ 3.5 → 13.5          │
│ 31-60              │ +0.8 g/con   │ 13.5 → 37.5         │
│ 61-90              │ +0.6 g/con   │ 37.5 → 52.5         │
└────────────────────┴──────────────┴─────────────────────┘

HE SO DIEU CHINH:
- DO < 4 mg/L: × 0.5
- pH ngoai 6.5-8.5: × 0.7
- Temp < 25°C: × 0.7
- Temp > 32°C: × 0.6
- H2S > 0.05: × 0.4
- NH3 > 0.2: × 0.5
- Co benh: × 0.3-0.6
```

### 5.3 Cong thuc Ty le chet (Mortality Rate)

```
TY LE CA CHET
Base_rate = GetBaseRate(Age)
Adjusted_rate = Base_rate × He_so_benh × He_so_stress
Ca_chet = Random(Adjusted_rate × 0.8, Adjusted_rate × 1.2) × So_ca

Base Rate theo tuoi:
┌────────────────────┬──────────────┐
│ Tuoi (ngay)        │ Ty le (%)    │
├────────────────────┼──────────────┤
│ 0-10               │ 0.1-0.5%     │
│ 11-30              │ 0.05-0.2%    │
│ 31-60              │ 0.02-0.1%    │
│ 61-90              │ 0.01-0.05%   │
└────────────────────┴──────────────┘

HE SO BENH:
- Vibrio: × 3-5
- Stress pH/DO: × 2-3
- Thieu oxy (DO<2): × 5-10
```

### 5.4 Cong thuc Thuc an (Feed Allocation)

```
LUONG THUC AN (kg/ngay)
Base_%BW = GetBaseFeeding(TLBQ, Age)
Adjusted_%BW = Base_%BW × He_so_dieu_chinh
Thuc_an = (Sinh_khoi × Adjusted_%BW) / 100

Base %BW theo kich co:
┌────────────┬──────────────┬──────────────┐
│ Kich co    │ Tuoi         │ %BW/ngay     │
├────────────┼──────────────┼──────────────┤
│ < 50g      │ 0-10 ngay    │ 5-7%         │
│ 50-150g    │ 11-30 ngay   │ 3-5%         │
│ 150-300g   │ 31-60 ngay   │ 2-3%         │
│ > 300g     │ 61+ ngay     │ 1.5-2%       │
└────────────┴──────────────┴──────────────┘

DIEU CHINH:
- Dang dung thuoc: × 0.5
- DO < 4: × 0.6
- pH ngoai range: × 0.7
- Co benh: × 0.5-0.8
- Rang buoc: ±50% so voi ngay truoc
```

### 5.5 Cong thuc FCR (Feed Conversion Ratio)

```
FCR
FCR = Tong_thuc_an_tich_luy / Tong_sinh_khoi_tich_luy

TIEU CHUAN:
- 1.5-2.0: Tot ✅
- 2.0-2.5: Binh thuong ✅
- > 2.5: Canh bao
- > 3.0: Nguy hiem
```

### 5.6 Cong thuc Chat luong nuoc

```
DO (Dissolved Oxygen) - mg/L
DO = 5.5 - (Sinh_khoi / 1000) × 0.5 - Random(0, 1.5)

pH
pH = 7.2 + Random(-0.3, 0.3) + Chemical_adjustment

H2S - mg/L
H2S = (Sinh_khoi / 1000) × 0.0005 - (Ve_sinh × 0.02)

NH3 - mg/L
NH3 = (Sinh_khoi / 100) × 0.001 - (Thay_nuoc × 0.1)

TIEU CHUAN AN TOAN:
- DO: > 5.0 mg/L (toi thieu 3.0)
- pH: 6.5-8.5
- H2S: < 0.05 mg/L
- NH3: < 0.2 mg/L
```

### 5.7 Thuat toan FEFO (First-Expired, First-Out)

1. Lay available batches, sap xep theo ExpiryDate ASC
2. Duyet qua batches:
   - Calculate available qty (Inbound - Outbound)
   - Allocate tung batch theo FIFO
   - Create outbound record
3. Neu con thieu → Tao Purchase Order

---

## 6. QUY TRINH NGHIEP VU

### 6.1 Daily Pipeline (10 Steps)

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

### 6.2 Khoi tao Chu ky Nuoi

**User Input**:
- Chon Pond
- StartDate & EndDate (90 ngay)
- InitialFishCount
- InitialAvgWeightGr
- Species (CATFISH/TILAPIA/SHRIMP)
- WarehouseID & FeedID
- Seed (optional)

**Validation**:
- Pond khong co active cycle?
- Start date < End date?
- Fish count > 0?

**Database Save**:
- Tao FarmingCycle record
- Status = 'PLANNING'
- Luu Seed & Manifest

### 6.3 Replay Mode (Tai Sinh Du lieu)

**Muc dich**: Kiem tra tinh deterministic

**Quy trinh**:
1. Tim Manifest cua chu ky cu
2. Load Seed, Version, Weather data
3. Tai sinh toan bo 90 ngay
4. So sanh checksum tung ngay
5. Bao cao "PASS ✅" hoac "FAIL ❌"

### 6.4 Manual Override

**Muc dich**: Dieu chinh du lieu sinh tu dong khi can thiet

**Editable Fields**:
- mortality_count (so ca chet)
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

## 7. 11 SIMULATION ENGINES

### 7.1 Engine 1: EnvironmentGenerator

**Chuc nang**: Sinh du lieu chat luong nuoc

**Input**:
- Sinh khoi hien tai
- Ngay
- Nhiet do baseline

**Output**:
- DO (Dissolved Oxygen) - mg/L
- pH
- H2S - mg/L
- NH3 - mg/L

**Cong thuc**:
```
DO = 5.5 - (Sinh_khoi / 1000) × 0.5 - Random(0, 1.5)
pH = 7.2 + Random(-0.3, 0.3)
H2S = (Sinh_khoi / 1000) × 0.0005 - (Ve_sinh × 0.02)
NH3 = (Sinh_khoi / 100) × 0.001 - (Thay_nuoc × 0.1)
```

**Tieu chuan an toan**:
- DO: > 5.0 mg/L (toi thieu 3.0)
- pH: 6.5-8.5
- H2S: < 0.05 mg/L
- NH3: < 0.2 mg/L

---

### 7.2 Engine 2: MortalityEngine

**Chuc nang**: Tinh toan so ca chet hang ngay

**Input**:
- Tuoi ca
- DO, pH, Nhiet do
- Ty le hao hut (tu Scenario)

**Base Rate theo tuoi**:
| Tuoi | Ty le (%) |
|-----|----------|
| 0-10 ngay | 0.1-0.5% |
| 11-30 ngay | 0.05-0.2% |
| 31-60 ngay | 0.02-0.1% |
| 61+ ngay | 0.01-0.05% |

**He so stress**:
- DO < 4: ×0.5
- pH ngoai 6.5-8.5: ×0.7
- Temp < 25: ×0.7
- Temp > 32: ×0.6
- H2S > 0.05: ×0.4
- NH3 > 0.2: ×0.5

**Output**: So ca chet (±20% ngau nhien)

---

### 7.3 Engine 3: GrowthEngine

**Chuc nang**: Tinh toan tang trong ca hang ngay

**Tang trong theo tuoi (dieu kien toi uu)**:
| Tuoi | Tang/ngay | TLBQ cuoi |
|-----|----------|----------|
| 0-10 | +0.2 g/con | 1.5 → 3.5 |
| 11-30 | +0.5 g/con | 3.5 → 13.5 |
| 31-60 | +0.8 g/con | 13.5 → 37.5 |
| 61+ | +0.6 g/con | 37.5 → 52.5 |

**He so dieu chinh**:
- DO < 4: ×0.5
- pH ngoai 6.5-8.5: ×0.7
- Temp < 25: ×0.7
- Temp > 32: ×0.6
- H2S > 0.05: ×0.4
- NH3 > 0.2: ×0.5
- Co benh: ×0.3-0.6

**Output**: TLBQ moi, Sinh khoi moi

---

### 7.4 Engine 4: FeedPlanner

**Chuc nang**: Xac dinh luong thuc an hang ngay

**Base %BW theo kich co**:
| Kich co | Tuoi | %BW/ngay |
|--------|------|----------|
| < 50g | 0-10 ngay | 5-7% |
| 50-150g | 11-30 ngay | 3-5% |
| 150-300g | 31-60 ngay | 2-3% |
| > 300g | 61+ ngay | 1.5-2% |

**Dieu chinh**:
- Dang dung thuoc: ×0.5
- DO < 4: ×0.6
- pH ngoai range: ×0.7
- Co benh: ×0.5-0.8
- **Rang buoc**: ±50% so voi ngay truoc

**Output**: Thuc an (kg/ngay)

---

### 7.5 Engine 5: ChemicalEngine

**Chuc nang**: Xac dinh hoa chat can dung

**Logic**:
- Kiem tra chat luong nuoc
- Ap dung quy tac tu Decisioning Matrix
- Xac dinh loai & luong hoa chat
- Tinh toan chi phi

**Loai hoa chat**:
- PROBIOTIC
- VITAMIN
- ANTIBIOTIC
- pH_ADJUSTER
- SALT

**Output**: Chemical usage, cost

---

### 7.6 Engine 6: WaterOpsEngine

**Chuc nang**: Quan ly thay nuoc

**Logic**:
- DO nguy hiem → thay nuoc ngay
- Lich thay nuoc theo chu ky thang
- Tinh toan luong nuoc cap/thoat

**Output**:
- Water intake/discharge (m³)
- Tan suat thay nuoc

---

### 7.7 Engine 7: InventoryEngine

**Chuc nang**: FEFO allocation

**Thuat toan FEFO**:
1. Lay available batches
2. Sap xep theo ExpiryDate ASC
3. Allocate theo FIFO
4. Tao PO neu thieu

**Output**: Allocated qty, shortage qty

---

### 7.8 Engine 8: CostTracker

**Chuc nang**: Tinh toan chi phi hang ngay

**Cost Categories** (VND):
- FeedCost
- ChemicalCost
- ElectricityCost
- LaborCost
- MaintenanceCost
- OtherCost

**Labor Stress Multiplier**:
- Binh thuong: 150,000 VND/ngay
- Dung thuoc: ×1.5
- Thu hoach: ×2.0

**Output**: Daily cost, cumulative cost

---

### 7.9 Engine 9: AlertSystem

**Chuc nang**: Phat sinh canh bao

**Alert Levels**:
- CRITICAL: Phai xu ly trong 1 gio
- WARNING: Xu ly trong 24 gio
- INFO: Thong bao thong tin

**Categories**:
- WATER_QUALITY
- HEALTH
- INVENTORY
- COST
- GROWTH

**Output**: AlertLogs records

---

### 7.10 Engine 10: ValidationService

**Chuc nang**: Kiem tra hop le du lieu

**Business Rules**:
- Pond khong co 2 cycles active
- FCR >= 1.0
- Survival rate <= 100%
- Feed <= 10% body weight
- Temperature: 15-40°C
- pH: 4.0-11.0
- DO: 0-20 mg/L

**Output**: Validation errors/warnings

---

### 7.11 Engine 11: ReportingEngine

**Chuc nang**: Xuat bao cao & bieu mau

**Output**:
- 8 FSIS forms
- Excel/PDF/Word
- Dashboard data
- Cycle summary

---

## 8. 8 FSIS FORMS

### 8.1 P301-F01: Nhat ky nuoi (90 dong)

**Muc dich**: Daily log

**Noi dung**:
- Ngay, Tuoi ca
- Nhiet do (AM/PM)
- DO, pH
- Ca chet, TLBQ
- Thuc an
- Ghi chu

**Watermark**: "MOCKED DATA - FOR TRAINING ONLY"

---

### 8.2 P301-F06: Bien ban giao nhan TA

**Muc dich**: Feed delivery

**Noi dung**:
- Ngay giao
- Ten thuc an
- So luong (kg)
- Batch code
- Han su dung
- Nguoi giao, Nguoi nhan

---

### 8.3 P301-F07: So theo doi TA

**Muc dich**: Feed inventory

**Noi dung**:
- Ngay
- Ten thuc an
- Nhap (kg)
- Xuat (kg)
- Ton (kg)
- Batch code
- HSD

---

### 8.4 P303-F03: Phieu giao hang HC

**Muc dich**: Chemical delivery

**Noi dung**:
- Ngay giao
- Ten hoa chat
- So luong
- Batch code
- HSD
- Nguoi giao, Nguoi nhan

---

### 8.5 P303-F04: So theo doi HC

**Muc dich**: Chemical inventory

**Noi dung**:
- Ngay
- Ten hoa chat
- Nhap
- Xuat
- Ton
- Batch code
- HSD

---

### 8.6 P303-F06: Phieu chi dinh san pham

**Muc dich**: Product specification

**Noi dung**:
- Thong tin san pham
- Quy cach
- Chat luong
- Nguoi de nghi
- Nguoi duyet
- Trang thai: Draft/Pending/Approved/Rejected

---

### 8.7 P303-F07: Phieu theo doi suc khoe

**Muc dich**: Health monitoring

**Noi dung**:
- Ngay kiem tra
- TLBQ
- Ky sinh trung
- Dau hieu lam san
- Dieu tri
- Bac si thu y

---

### 8.8 P305-F37: So giao nhan chat thai

**Muc dich**: Waste transfer

**Noi dung**:
- Ngay
- Loai chat thai
- So luong (kg)
- Phuong phap xu ly
- Nguoi giao
- Nguoi nhan

---

## 9. USER ROLES & PERMISSIONS

### 9.1 Role-Based Access Control (RBAC)

| Role | Permissions |
|------|-----------|
| **ADMIN** | ✓ All CRUD operations<br>✓ User management<br>✓ System configuration<br>✓ View audit trail<br>✓ Backup/Restore |
| **MANAGER** | ✓ View all data<br>✓ Edit cycles & daily logs<br>✓ Approve workflows<br>✓ Generate reports<br>✗ Delete master data<br>✗ User management |
| **STAFF** | ✓ View assigned ponds/cycles<br>✓ Edit daily logs (own pond)<br>✓ Submit for approval<br>✗ Delete any data<br>✗ View other ponds |
| **VIEWER** | ✓ Read-only access (all data)<br>✗ Edit/Delete anything |

---

## 10. ALERT THRESHOLDS & RULES

### 10.1 CRITICAL Alerts

| Condition | Threshold | Action Required |
|-----------|-----------|---------|
| DO | < 3.0 mg/L | Bat may suc ngay |
| Mortality | > 5%/day | Lien he thu y |
| Temperature | <20°C or >35°C | Thay nuoc ngay |
| pH | <6.0 or >9.0 | Dieu chinh pH ngay |
| H2S | > 0.1 mg/L | Ve sinh day ngay |
| NH3 | > 0.5 mg/L | Giam thuc an 50% |
| Stock HSD | < 7 days | Dat hang bo sung |

### 10.2 WARNING Alerts

| Condition | Threshold | Action Required |
|-----------|-----------|---------|
| DO | 3.0-4.0 mg/L | Chuan bi bat may suc |
| Mortality | 2-5%/day | Theo doi chat |
| Temperature | 25-28 or 32-35°C | Chuan bi thay nuoc |
| pH | 6.0-6.5 or 8.5-9 | Chuan bi dieu chinh |
| H2S | 0.05-0.1 mg/L | Ve sinh so bo |
| NH3 | 0.3-0.5 mg/L | Giam thuc an 30% |
| FCR | > 2.5 | Kiem tra thuc an |
| Stock HSD | < 30 days | Dat hang bo sung |

### 10.3 INFO Alerts

- Milestone reached (Day 30, 60, 90)
- Growth rate trend update
- Harvest prediction ready
- Report available
- Daily log completed

---

## 11. TEST CASES & ACCEPTANCE CRITERIA

### 11.1 Test Case: Generate 90-Day Cycle

**Given**: Valid scenario input
**When**: Run auto-generation
**Then**:
- 90 DailyLog records created
- All fields populated
- FCR reasonable (1.5-3.0)
- Survival rate > 80%

### 11.2 Test Case: FEFO Allocation

**Given**: Multiple batches with different expiry dates
**When**: Allocate feed
**Then**:
- Earliest expiry batch issued first
- Quantities correct
- Stock updated

### 11.3 Test Case: Replay Mode

**Given**: Existing cycle with manifest
**When**: Replay cycle
**Then**:
- Same seed generates same data
- Checksums match 100%
- Determinism: PASS

### 11.4 Test Case: Manual Override

**Given**: Existing daily log
**When**: Edit field
**Then**:
- Audit trail logged
- Recalculation triggered
- Watermark added to reports

---

## 12. USER GUIDE (FSIS FORMS)

### 12.1 Muc Dich

Form **FSIS Reports** duoc su dung de xem va xuat bao cao tuan thu an toan thuc pham cho cac vong nuoi tom/ca.

### 12.2 Quy Trinh Su Dung

**Buoc 1**: Mo Form FSIS Reports

**Buoc 2**: Chon Loai Bao Cao (8 loai)

**Buoc 3**: Chon Ao Nuoi

**Buoc 4**: Chon Vong Nuoi

**Buoc 5**: [Tuy Chon] Loc Theo Khoang Ngay

**Buoc 6**: Bam Nut "Xem Du Lieu"

**Buoc 7**: Xem Du Lieu Trong Bang

**Buoc 8**: [Tuy Chon] Xuat Du Lieu Ra Excel

**Buoc 9**: [Tuy Chon] Xoa Du Lieu

**Buoc 10**: Dong Form

### 12.3 Vi Du Thuc Te

#### Vi Du 1: Xem Nhat Ky Nuoi

1. **Loai bao cao**: Chon `P301-F01 - Nhat ky nuoi`
2. **Ao nuoi**: Chon `P001 - Ao nuoi 1`
3. **Vong nuoi**: Chon `C202401 - Vong nuoi thang 1/2024`
4. **Loc theo ngay**: Tich, chon tu 01/01/2024 den 31/01/2024
5. **Xem du lieu** → Thay du lieu nhat ky

#### Vi Du 2: Xuat Bao Cao Thuc An

1. **Loai bao cao**: Chon `P301-F07 - So theo doi thuc an`
2. **Ao nuoi**: Chon `P002 - Ao nuoi 2`
3. **Vong nuoi**: Chon `C202312 - Vong nuoi thang 12/2023`
4. **Xem du lieu** → Thay du lieu
5. **Xuat Excel** → Luu file

### 12.4 Luu Y Quan Trong

**Khi Nao Nen Su Dung Form Nay?**
- ✅ Khi can xem bao cao FSIS
- ✅ Khi can xuat du lieu ra Excel
- ✅ Khi can kiem tra lich su
- ❌ KHONG dung de nhap du lieu moi

**Gap Loi Gi Thi Lam?**

| Loi | Cach Xu Ly |
|---|---|
| "Khong co du lieu" | Kiem tra xem ao/vong nuoi do co du lieu khong |
| Form khong load danh sach ao | Kiem tra ket noi database |
| Nut "Xuat Excel" bi tat | Bam "Xem Du Lieu" truoc |

---

## 13. PHU LUC

### 13.1 Glossary - Thuat ngu

| Tieng Anh | Tieng Viet | Giai thich |
|-----------|-----------|-----------|
| Fingerling | Giong | Ca/tom giong de tha nuoi |
| Stocking | Tha giong | Qua trinh dua giong vao ao |
| Cycle | Vu/Chu ky nuoi | 90 ngay tu tha giong den thu hoach |
| Biomass | Sinh khoi | Tong khoi luong ca/tom hien tai |
| TLBQ | Trong luong binh quan | Average weight (g/con) |
| FCR | He so chuyen doi | Feed Conversion Ratio |
| DO | Oxy hoa tan | Dissolved Oxygen (mg/L) |
| FEFO | First-Expired, First-Out | Xuat hang theo HSD som nhat |
| Batch Code | Ma lo | Ma theo doi lo san xuat |
| HSD | Han su dung | Expiry Date |

### 13.2 Data Validation Rules

**BUSINESS RULES**:
- Pond khong the co 2 cycles active cung luc
- FCR khong the < 1.0 (khong hop ly)
- Survival rate khong the > 100%
- Feed amount khong the > 10% body weight
- Temperature: 15-40°C (ngoai la loi)
- pH: 4.0-11.0 (ngoai la invalid)
- DO: 0-20 mg/L (outside = error)
- Expiry date phai > Manufacturing date
- Batch code phai unique trong warehouse
- User phai co role de access function
- Daily log khong the co > 5% missing fields

### 13.3 Known Limitations

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

### 13.4 Contact & Support

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

### TUYEN BO MIEN TRACH

**Du Lieu Mo Phong**:
- Tat ca du lieu duoc sinh **TU DONG** tu cong thuc mo phong
- **KHONG PHAI** du lieu thuc tu trang trai
- **Muc dich**: Dao tao, chuan hoa bieu mau, phan tich
- **KHONG** su dung cho bao cao chinh thuc

### WATERMARK BAT BUOC

**Watermark Requirement**:
```
"MOCKED DATA - FOR TRAINING ONLY"
```

**Phai co tren tat ca**:
- ✅ Bieu mau xuat (XLSX/DOCX/PDF)
- ✅ Header bao cao
- ✅ File CSV/JSON export
- ✅ Dashboard preview
- ✅ Print outputs

### HAN CHE SU DUNG

**KHONG duoc phep**:
- ❌ Gui bao cao nay cho chinh quyen
- ❌ Su dung cho kiem dinh/chung nhan
- ❌ Xoa watermark
- ❌ Phat hanh cong khai
- ❌ Thay the du lieu thuc te

**Duoc phep**:
- ✅ Dung de dao tao nhan vien
- ✅ Test tinh nang he thong
- ✅ Demo cho khach hang (voi watermark)
- ✅ Phan tich cong thuc
- ✅ Kiem tra layout bieu mau
- ✅ Training & simulation purposes

---

## DOCUMENT METADATA

| Property | Value |
|----------|-------|
| **Document ID** | SRS-AQUASIM-4.0-FINAL |
| **Version** | 4.0 Final Consolidated |
| **Status** | APPROVED |
| **Date** | 14/11/2025 |
| **Total Pages** | ~60 pages |
| **Word Count** | ~25,000 words |
| **Author** | Technical Team |
| **Reviewer** | Project Manager |
| **Approver** | Client Representative |

---

## CHANGE HISTORY

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 15/10/2025 | Initial draft from business requirements |
| v2.0 | 25/10/2025 | Added technical architecture |
| v3.0 | 04/11/2025 | Added security, audit, testing sections |
| v4.0 | 06/11/2025 | Consolidated: Removed duplicates, unified structure |
| **v4.0 FINAL** | **14/11/2025** | **Final consolidation from 5 source files** |

---

**CONFIDENTIAL** - For authorized personnel only
© 2025 AquaSim System. All rights reserved.
