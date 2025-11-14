# Phát Triển Window Form - Quản Lý Chất Lượng Lâm Nghiệp (QLCLN)

**Ngày tạo**: 14/11/2025  
**Phiên bản**: 1.0  
**Trạng thái**: Thiết kế

---

## I. TỔNG QUAN HỆ THỐNG

### 1.1 Mục đích
Xây dựng hệ thống quản lý chất lượng lâm nghiệp toàn diện, tự động hóa quy trình ghi nhận dữ liệu nuôi cá, quản lý hóa chất, thức ăn, và theo dõi chất lượng nước.

### 1.2 Phạm vi
- **Người dùng**: Bác sĩ ngư y, quản lý ao, nhân viên kho
- **Dữ liệu**: Nhật ký nuôi, hóa chất, thức ăn, chất lượng nước, chất thải
- **Thời gian**: Từ ngày chuẩn bị ao đến ngày thu hoạch (90 ngày)
- **Vùng**: Đồng Tháp (Cao Lãnh, Tân Hưng, Mỹ Xương, ...)

---

## II. LUỒNG QUY TRÌNH CHÍNH

### 2.1 Chu Kỳ Nuôi (90 ngày)

```
NGÀY 1-2 (Chuẩn Bị Ao)
├─ Vét bùn
├─ Xử lý nước (Vôi, EM-F1)
├─ Cân mẫu chất lượng nước
└─ Ghi nhận hóa chất sử dụng

NGÀY 3-90 (Nuôi Bình Thường)
├─ Thả cá (Ngày 3)
├─ Ghi nhận hàng ngày:
│  ├─ Môi trường (DO, Nhiệt độ, pH)
│  ├─ Cá & Thức ăn
│  ├─ Hóa chất sử dụng
│  └─ Cảnh báo & Xử lý
├─ Cân mẫu định kỳ (Hàng tháng)
└─ Theo dõi chất lượng nước

NGÀY 90+ (Thu Hoạch)
├─ Cắt mồi (Ngày 89)
├─ Thu hoạch (Ngày 90)
├─ Ghi nhận cuối cùng
└─ Tính toán FCR & Báo cáo
```

### 2.2 Quy Trình Ghi Nhận Hàng Ngày

```
1. Chọn Ao & Ngày
   └─ Validate: Ao có hoạt động? Ngày hợp lệ?

2. Ghi Nhận Môi Trường
   ├─ DO (Sáng/Chiều)
   ├─ Nhiệt độ (Sáng/Chiều)
   ├─ pH (Sáng/Chiều)
   └─ Validate: Trong ngưỡng quy định?

3. Ghi Nhận Cá & Thức Ăn
   ├─ Số lượng cá (Tính tự động)
   ├─ Cá chết (Nhập & Tính khối lượng)
   ├─ Thức ăn (Chọn loại & Lượng)
   └─ Validate: HSD? Mật độ?

4. Ghi Nhận Hóa Chất
   ├─ Loại hóa chất
   ├─ Lượng sử dụng
   ├─ Lý do sử dụng
   └─ Validate: MSL & HSD?

5. Kiểm Tra Cảnh Báo
   ├─ Mật độ > 37 kg/m²?
   ├─ Cá chết vượt ngưỡng?
   ├─ HSD hết hạn?
   └─ Hiển thị cảnh báo

6. Lưu & Báo Cáo
   ├─ Lưu Database
   ├─ Cập nhật tồn kho
   ├─ Tạo Daily Log
   └─ In phiếu nếu cần
```

---

## III. CÁC FORM CHÍNH & CÔNG THỨC

### 3.1 Form Nhật Ký Nuôi (frmNhatKyNuoi)

**Công Thức Tính Số Lượng Cá**:
```
IF NgàyNuôi = 1 THEN
    SốLượngCá = SốConThả
ELSE
    SốLượngCá = SốLượngCáNgàyTrước - CáChếtNgàyTrước
END IF
```

**Công Thức Tính Khối Lượng Cá Chết**:
```
KhốiLượngCáChết = (SốConCáChết × TLBQ) × 0.8 đến 0.85
KhốiLượngCáChết = ROUND(KhốiLượngCáChết, 0.5)
```

**Công Thức Tính Mật Độ Nuôi**:
```
MậtĐộ = (SốLượngCá × TLBQ) / DiệnTíchMặtNước
IF MậtĐộ > 37 THEN
    CảnhBáo = "Mật độ vượt 37 kg/m²"
END IF
```

**Validation DO theo Giai Đoạn**:
```
IF GiaiĐoạn = "Tuần 1" THEN
    Sáng: [3.5, 3.9]  |  Chiều: [3.9, 4.5]
ELSE IF GiaiĐoạn = "Tuần 2-Tháng 1" THEN
    Sáng: [3.0, 3.5]  |  Chiều: [3.5, 3.9]
ELSE IF GiaiĐoạn = "2 tháng tiếp theo" THEN
    Sáng: [2.9, 3.2]  |  Chiều: [3.2, 3.5]
ELSE
    Sáng: [2.6, 2.9]  |  Chiều: [2.8, 3.4]
END IF
```

---

### 3.2 Form Sổ Kho Thức Ăn (frmSoKhoThucAn)

**Công Thức Tính HSD từ MSL**:
```
MSL = "0125-32201914"
NgàyJulian = MID(MSL, 3, 3)  // "322"
HSD = NgàyJulian + 89
HSD = ConvertJulianToDate(HSD)
```

**Validation HSD**:
```
IF NgàyNhập > NgàyHSD THEN
    CảnhBáo = "Ngày nhập sau ngày sản xuất"
    AllowSave = FALSE
END IF

IF TODAY() > NgàyHSD THEN
    CảnhBáo = "Thức ăn đã hết hạn"
    AllowUse = FALSE
END IF
```

**Công Thức Tồn Kho**:
```
TồnCuối = TồnĐầu + LượngNhập - LượngXuất
```

---

### 3.3 Form Sổ Kho Hóa Chất (frmSoKhoHoaChat)

**Validation Sức Chứa Kho**:
```
IF LoạiHóaChất = "Lỏng" THEN
    TổngLượngKho = SUM(LượngHóaChấtLỏng)
    IF TổngLượngKho > SứcChứaKho × 0.9 THEN
        CảnhBáo = "Sức chứa kho vượt 90%"
        AllowNhập = FALSE
    END IF
END IF
```

**Tiêu Chí Đạt**:
```
IF Nguyên vẹn = TRUE AND Khô ráo = TRUE AND Sạch sẽ = TRUE THEN
    TrạngThái = "Đạt"
ELSE
    TrạngThái = "Không đạt"
END IF
```

---

### 3.4 Form Phiếu Chỉ Định Sử Dụng (frmPhieuChiDinh)

**Lấy Danh Sách Sản Phẩm**:
```
IF LýDo = "Xử lý nước" THEN
    DanhSáchSảnPhẩm = GetSảnPhẩm(Nhóm = "Xử lý nước")
ELSE IF LýDo = "Bổ sung dinh dưỡng" THEN
    DanhSáchSảnPhẩm = GetSảnPhẩm(Nhóm = "Dinh dưỡng")
ELSE IF LýDo = "Trị bệnh" THEN
    DanhSáchSảnPhẩm = GetSảnPhẩm(Nhóm = "Trị bệnh")
END IF
```

---

### 3.5 Form Theo Dõi Chất Lượng Nước (frmChatLuongNuoc)

**Validation Lượng Nước Cấp**:
```
TổngLượngNướcCấp = SUM(LượngNướcCấpTừngAo)
IF TổngLượngNướcCấp > 8640 THEN
    CảnhBáo = "Lượng nước cấp vượt 8.640 m³/ngày"
    AllowSave = FALSE
END IF
```

---

## IV. DATABASE SCHEMA

### 4.1 Bảng Chính

```sql
-- Bảng Ao Nuôi
CREATE TABLE Ponds (
    PondID INT PRIMARY KEY,
    PondName VARCHAR(50),
    FarmID INT,
    SurfaceArea DECIMAL(10,2),
    WaterSurfaceArea DECIMAL(10,2),
    Depth DECIMAL(5,2),
    CreatedDate DATE
);

-- Bảng Nhật Ký Hàng Ngày
CREATE TABLE DailyLogs (
    LogID INT PRIMARY KEY,
    PondID INT,
    LogDate DATE,
    FishCount INT,
    DeadCount INT,
    DeadWeightKg DECIMAL(10,2),
    DO_Morning DECIMAL(5,2),
    DO_Evening DECIMAL(5,2),
    Temperature_Morning DECIMAL(5,2),
    Temperature_Evening DECIMAL(5,2),
    pH_Morning DECIMAL(5,2),
    pH_Evening DECIMAL(5,2),
    FeedKg DECIMAL(10,2),
    FeedBatchCode VARCHAR(50),
    Notes TEXT,
    CreatedDate DATETIME
);

-- Bảng Hóa Chất Sử Dụng
CREATE TABLE ChemicalUsage (
    UsageID INT PRIMARY KEY,
    PondID INT,
    UsageDate DATE,
    ChemicalID INT,
    QuantityUsed DECIMAL(10,2),
    Unit VARCHAR(10),
    Reason VARCHAR(100),
    CreatedDate DATETIME
);

-- Bảng Tồn Kho Thức Ăn
CREATE TABLE FeedInventory (
    InventoryID INT PRIMARY KEY,
    FeedID INT,
    InputDate DATE,
    QuantityInput DECIMAL(10,2),
    BatchCode VARCHAR(50),
    ExpiryDate DATE,
    QuantityOutput DECIMAL(10,2),
    RemainingQty DECIMAL(10,2),
    Status VARCHAR(20)
);

-- Bảng Tồn Kho Hóa Chất
CREATE TABLE ChemicalInventory (
    InventoryID INT PRIMARY KEY,
    ChemicalID INT,
    InputDate DATE,
    QuantityInput DECIMAL(10,2),
    BatchCode VARCHAR(50),
    ExpiryDate DATE,
    QuantityOutput DECIMAL(10,2),
    RemainingQty DECIMAL(10,2),
    Status VARCHAR(20)
);
```

## I. CÁC CÔNG THỨC TÍNH TOÁN CHI TIẾT

### 1.1 Tính FCR (Feed Conversion Ratio)

**Định nghĩa**: Tỷ lệ chuyển đổi thức ăn = Lượng thức ăn / Tăng trưởng sinh khối

```
FCR = TổngLượngThứcĂn / (BiomassKuối - BiomassĐầu)

Hoặc:

FCR = TổngLượngThứcĂn / (SốLượngCáCuối × TLBQ_Cuối - SốLượngCáĐầu × TLBQ_Đầu)

Ví dụ:
- Tổng thức ăn: 45,000 kg
- Sinh khối đầu: 451,600 × 0.02 = 9,032 kg
- Sinh khối cuối: 448,036 × 1.2 = 537,643 kg
- Tăng trưởng: 537,643 - 9,032 = 528,611 kg
- FCR = 45,000 / 528,611 = 0.85
```

### 1.2 Tính Tốc Độ Tăng Trưởng Hàng Ngày (SGR)

```
SGR (%) = [(LN(TLBQ_Cuối) - LN(TLBQ_Đầu)) / Số ngày] × 100

Ví dụ:
- TLBQ đầu: 0.02 kg
- TLBQ cuối: 1.2 kg
- Số ngày: 200
- SGR = [(LN(1.2) - LN(0.02)) / 200] × 100
- SGR = [(0.1823 - (-3.912)) / 200] × 100 = 2.05%/ngày
```

### 1.3 Tính Tỷ Lệ Sống (Survival Rate)

```
SR (%) = (SốCáCuối / SốCáThả) × 100

Ví dụ:
- Số cá thả: 451,600 con
- Số cá cuối: 448,036 con
- SR = (448,036 / 451,600) × 100 = 99.21%
```

### 1.4 Tính Tỷ Lệ Chết Tích Lũy

```
Cumulative Mortality (%) = [(SốCáThả - SốCáCuối) / SốCáThả] × 100

Ví dụ:
- Tỷ lệ chết = [(451,600 - 448,036) / 451,600] × 100 = 0.79%
```

### 1.5 Tính Mật Độ Nuôi Theo Thời Gian

```
Density(t) = (FishCount(t) × TLBQ(t)) / WaterSurfaceArea

Ngày 1: (451,600 × 0.02) / 13,500 = 0.67 kg/m²
Ngày 30: (450,000 × 0.15) / 13,500 = 5.0 kg/m²
Ngày 60: (449,000 × 0.4) / 13,500 = 13.3 kg/m²
Ngày 90: (448,036 × 1.2) / 13,500 = 39.8 kg/m² (⚠ Vượt 37!)
```

---

## II. CÔNG THỨC TÍNH LƯỢNG THỨC ĂN

### 2.1 Lượng Thức Ăn Tối Đa Theo Giai Đoạn

```
Giai đoạn 1 (15-80g):
MaxFeed = (4% × TLBQ × FishCount) / 100

Giai đoạn 2 (80-200g):
MaxFeed = (3% × TLBQ × FishCount) / 100

Giai đoạn 3 (200-1000g):
MaxFeed = (2% × TLBQ × FishCount) / 100

Ví dụ Ngày 30:
- TLBQ: 0.15 kg
- FishCount: 450,000 con
- MaxFeed = (3 × 0.15 × 450,000) / 100 = 2,025 kg
```

### 2.2 Điều Chỉnh Lượng Thức Ăn Khi Sử Dụng Thuốc

```
IF SửDụngThuốcTrịBệnh THEN
    LượngThứcĂn_Hôm Nay = LượngThứcĂn_HômQua × 0.5  // Giảm 50%
    
    // Sau khi hết bệnh (3-5 ngày)
    LượngThứcĂn_Hôm Nay = LượngThứcĂn_HômQua × 1.1  // Tăng dần 10%/ngày
END IF
```

### 2.3 Điều Chỉnh Lượng Thức Ăn Sau Thu Tỉa

```
LượngThứcĂn_SauThuTỉa = LượngThứcĂn_Trước × (SốCáCòn / SốCáTrước)

Ví dụ:
- Lượng ăn trước: 2,000 kg
- Số cá trước: 450,000 con
- Thu tỉa: 75,000 con
- Số cá còn: 375,000 con
- Lượng ăn sau: 2,000 × (375,000 / 450,000) = 1,667 kg
```

### 2.4 Quy Tắc Tăng/Giảm Lượng Thức Ăn

```
IF LượngThứcĂn_Hôm Nay > LượngThứcĂn_HômQua × 1.5 THEN
    Alert = "Tăng thức ăn vượt 50%"
    AllowFeed = FALSE
END IF

IF LượngThứcĂn_Hôm Nay < LượngThứcĂn_HômQua × 0.5 THEN
    Alert = "Giảm thức ăn vượt 50%"
    AllowFeed = FALSE
END IF
```

---

## III. CÔNG THỨC TÍNH TOÁN HÓA CHẤT

### 3.1 Lượng Vôi Cần Sử Dụng

```
Trước thả cá:
LượngVôi = (DiệnTíchAo / 10,000) × 500  // kg/10,000m²

Ví dụ: Ao 2 hectare (20,000m²)
LượngVôi = (20,000 / 10,000) × 500 = 1,000 kg

Trong quá trình nuôi:
LượngVôi = (DiệnTíchAo / 10,000) × 20  // kg/10,000m³
```

### 3.2 Lượng EM-F1 (Vi Sinh)

```
Trước thả cá:
LượngEM = (ThểTíchNước / 2,500) × 1  // lít/2,500m³

Trong quá trình nuôi:
LượngEM = (ThểTíchNước / 2,000) × 1  // lít/2,000m³

Ví dụ: Ao 2 hectare, sâu 1.5m
ThểTíchNước = 20,000 × 1.5 = 30,000 m³
LượngEM = (30,000 / 2,000) × 1 = 15 lít
```

### 3.3 Lượng Hóa Chất Bổ Sung Dinh Dưỡng

```
VITALUCAN - B12 NEW:
Lượng = (TổngLượngThứcĂn / 1,000) × 3  // kg/1 tấn TA

Ví dụ: 45,000 kg thức ăn
Lượng = (45,000 / 1,000) × 3 = 135 kg

UV-BIOLAC (Phụ thuộc kích cỡ cá):
Cá < 100g: (ThểTíchNước / 300,000) × 1  // lít/300kg TA
Cá > 100g: (ThểTíchNước / 700,000) × 1  // lít/700kg TA
```

---

## IV. CÔNG THỨC TÍNH TOÁN CHẤT LƯỢNG NƯỚC

### 4.1 Kiểm Tra Ngưỡng DO

```
IF GiaiĐoạn = "Tuần 1" THEN
    ValidRange_Sáng = [3.5, 3.9]
    ValidRange_Chiều = [3.9, 4.5]
    ChênhLệch = Chiều - Sáng
    IF ChênhLệch < 0.2 OR ChênhLệch > 1 THEN
        Alert = "Chênh lệch DO không hợp lệ"
    END IF
END IF
```

### 4.2 Kiểm Tra Ngưỡng Nhiệt Độ

```
IF Tháng IN [2, 3, 4, 5] THEN
    ValidRange_Sáng = [28, 30)
    ValidRange_Chiều = [29, 32)
ELSE IF Tháng IN [6, 7, 8, 9, 10] THEN
    ValidRange_Sáng = [27, 30)
    ValidRange_Chiều = [29, 31)
ELSE
    ValidRange_Sáng = [26, 29)
    ValidRange_Chiều = [28, 30)
END IF

ChênhLệch = Chiều - Sáng
IF ChênhLệch < 0.5 OR ChênhLệch > 2 THEN
    Alert = "Chênh lệch nhiệt độ không hợp lệ"
END IF
```

---

## V. CÔNG THỨC TÍNH TOÁN NƯỚC THẢI

### 5.1 Tính Lượng Nước Cấp Hàng Ngày

```
LượngNướcCấp_Ngày = (DiệnTíchAo / 10,000) × MứcNước

Mức 1: 100 m³/10,000m² (Tháng 1-2)
Mức 2: 150 m³/10,000m² (Tháng 3-4)
Mức 3: 200 m³/10,000m² (Tháng 5+)
Mức 4: 250 m³/10,000m² (Thu hoạch)

Ví dụ: Ao 2 hectare, Tháng 1
LượngNướcCấp = (20,000 / 10,000) × 100 = 200 m³
```

### 5.2 Kiểm Tra Giới Hạn Nước Cấp Vùng

```
TổngLượngNướcCấp_Vùng = SUM(LượngNướcCấp_TừngAo)

IF TổngLượngNướcCấp_Vùng > 8,640 THEN
    Alert = "Lượng nước cấp vượt 8.640 m³/ngày"
    AllowCap = FALSE
END IF
```

### 5.3 Kiểm Tra Giới Hạn Nước Xả Thải

```
// Vùng không có giấy phép xả thải
TổngLượngXảThải_Vùng = SUM(LượngXảThải_TừngAoLắng)

IF TổngLượngXảThải_Vùng > 10,000 THEN
    Alert = "Lượng xả thải vượt 10.000 m³/ngày"
    AllowDrain = FALSE
END IF

// Quy tắc ao lắng
IF VùngCó2AoLắng THEN
    AoLắng_1: XảThải_Ngày_Lẻ
    AoLắng_2: XảThải_Ngày_Chẵn
    // Đảm bảo 2 đợt thải cùng ngày trong tháng
END IF
```

---

## VI. CÔNG THỨC TÍNH TOÁN CÁ CHẾT

### 6.1 Tỷ Lệ Chết Theo Giai Đoạn

```
Giai đoạn 1 (Ngày 1-7): < 0.5% tổng
Giai đoạn 2 (Ngày 8-14): < 0.4%/ngày
Giai đoạn 3 (Cỡ 15-40g): < 0.3%/ngày
Giai đoạn 4 (Cỡ 40-80g): < 0.1%/ngày
Giai đoạn 5 (Cỡ 80-100g): < 0.03%/ngày
Giai đoạn 6 (Cỡ > 100g): < 0.02%/ngày
```

### 6.2 Kiểm Tra Cá Chết Vượt Ngưỡng

```
IF CáChết_Ngày > Ngưỡng_GiaiĐoạn THEN
    CảnhBáo = "Cá chết vượt ngưỡng"
    
    // Đề xuất sử dụng thuốc
    IF CáChết_Vượt_1Ngày THEN
        ĐềXuất = "Sử dụng thuốc trị ký sinh trùng (1-2 ngày)"
    ELSE IF CáChết_Vượt_2Ngày THEN
        ĐềXuất = "Sử dụng thuốc trị bệnh (5-7 ngày)"
    END IF
END IF
```

### 6.3 Tính Tỷ Lệ Vô Hình

```
TỷLệVôHình (%) = [(SốCáThả - SốCáCuối - TổngCáChết) / SốCáThả] × 100

IF TỷLệVôHình > 10% THEN
    Alert = "Tỷ lệ vô hình vượt 10%"
END IF

// Tỷ lệ tổng chết không được vượt 15%
TỷLệTổngChết = (TổngCáChết / SốCáThả) × 100
IF TỷLệTổngChết > 15% THEN
    Alert = "Tỷ lệ chết tổng vượt 15%"
END IF
```

---

## VII. CÔNG THỨC TÍNH TOÁN KHOẢNG THỜI GIAN

### 7.1 Tính Ngày Ao Trống

```
NgàyAoTrống = (NgàyThả - NgàyThuHoạchVụTrước) + 1

Ví dụ:
- Ngày thu hoạch vụ trước: 24/07/2024
- Ngày thả: 27/07/2024
- Ngày ao trống = (27/07 - 24/07) + 1 = 4 ngày
```

### 7.2 Tính Ngày Cải Tạo Ao

```
NgàyCảiTạoAo = Từ ngày hóa chất đầu tiên đến (Ngày thả - 1)

Ví dụ:
- Ngày sử dụng vôi: 25/07/2024
- Ngày thả: 27/07/2024
- Ngày cải tạo = 25/07 đến 26/07 (2 ngày)
```

### 7.3 Tính Ngày Cân Mẫu Định Kỳ

```
// Bác sĩ ngư y cân mẫu hàng tháng
NgàyCânMẫu = Ngày cuối tháng - X ngày (tùy bác sĩ)

Ví dụ:
- Dư Hữu Trọng (Bình Thạnh): Ngày 28 (cuối tháng - 2 ngày)
- Hồ Thanh Vinh (Mỹ Hiệp): Ngày 30 (cuối tháng)
```

### 7.4 Tính Thời Gian Cấm Thay Nước Khi Sử Dụng Thuốc

```
NgàyBắtĐầuThuốc = Ngày cá chết vượt ngưỡng + 2 ngày

NgàyKếtThúcCấmThayNước = NgàyKếtThúcThuốc + 3 đến 5 ngày

Ví dụ:
- Cá chết vượt ngưỡng: 10/08
- Bắt đầu thuốc: 12/08
- Kết thúc thuốc: 18/08 (6 ngày)
- Kết thúc cấm thay nước: 21/08 (3 ngày sau)
```

---

## VIII. CÔNG THỨC TÍNH TOÁN KHO

### 8.1 Tính Tồn Kho Thức Ăn

```
TồnCuối = TồnĐầu + LượngNhập - LượngXuất

Ví dụ:
- Tồn đầu: 500 kg
- Nhập: 1,000 kg
- Xuất: 160 kg
- Tồn cuối: 500 + 1,000 - 160 = 1,340 kg
```

### 8.2 Tính Tồn Kho Hóa Chất

```
TồnCuối = TồnĐầu + LượngNhập - LượngXuất

Kiểm tra sức chứa:
IF LoạiHóaChất = "Lỏng" THEN
    TổngLượng = SUM(TồnCuối_HóaChấtLỏng)
    PercentUsed = (TổngLượng / SứcChứaKho) × 100
    
    IF PercentUsed > 90 THEN
        Alert = "Sức chứa kho vượt 90%"
    END IF
END IF
```

### 8.3 Tính Số Bao Bì Rỗng

```
// Thức ăn
SốBao_40kg = CEILING(LượngXuất / 40)
SốBao_600kg = CEILING(LượngXuất / 600)

Ví dụ: Xuất 160 kg
- Bao 40kg: CEILING(160 / 40) = 4 bao
- Bao 600kg: CEILING(160 / 600) = 1 bao
```

---

## IX. BẢNG THAM CHIẾU NHANH

### 9.1 Ngưỡng Cảnh Báo

| Chỉ tiêu | Ngưỡng | Hành động |
|----------|--------|----------|
| Mật độ | > 37 kg/m² | Cảnh báo đỏ |
| Cá chết | > Ngưỡng giai đoạn | Đề xuất thuốc |
| HSD | TODAY() > HSD | Cấm sử dụng |
| HSD sắp hết | < 7 ngày | Cảnh báo vàng |
| Sức chứa kho | > 90% | Cảnh báo vàng |
| Nước cấp | > 8.640 m³/ngày | Cảnh báo đỏ |
| Nước xả | > 10.000 m³/ngày | Cảnh báo đỏ |
| Tỷ lệ chết | > 15% | Cảnh báo đỏ |
| Tỷ lệ vô hình | > 10% | Cảnh báo vàng |

### 9.2 Danh Sách Kiểm Tra Hàng Ngày

- [ ] Ghi nhận DO (Sáng/Chiều)
- [ ] Ghi nhận Nhiệt độ (Sáng/Chiều)
- [ ] Ghi nhận pH (Sáng/Chiều)
- [ ] Ghi nhận Cá chết & Khối lượng
- [ ] Ghi nhận Thức ăn sử dụng
- [ ] Ghi nhận Hóa chất sử dụng
- [ ] Kiểm tra Cảnh báo
- [ ] Lưu Dữ liệu
- [ ] In Phiếu (nếu cần)

---
---

## V. QUYẾT ĐỊNH THIẾT KẾ

### 5.1 Validation Rules

| Trường | Rule | Thông Báo |
|--------|------|-----------|
| DO | Trong ngưỡng giai đoạn | "DO không trong ngưỡng quy định" |
| Nhiệt độ | Trong ngưỡng giai đoạn | "Nhiệt độ không trong ngưỡng" |
| pH | 7-8 | "pH phải trong khoảng 7-8" |
| Mật độ | ≤ 37 kg/m² | "Mật độ vượt 37 kg/m²" |
| Cá chết | ≤ Ngưỡng giai đoạn | "Cá chết vượt ngưỡng" |
| HSD | ≥ TODAY() | "Sản phẩm đã hết hạn" |
| Nước cấp | ≤ 8.640 m³/ngày | "Lượng nước cấp vượt giới hạn" |

### 5.2 Cảnh Báo Tự Động

| Sự kiện | Điều kiện | Hành động |
|---------|-----------|----------|
| Mật độ cao | > 37 kg/m² | Hiển thị cảnh báo đỏ |
| Cá chết vượt | > Ngưỡng | Đề xuất sử dụng thuốc |
| HSD sắp hết | < 7 ngày | Hiển thị cảnh báo vàng |
| Sức chứa kho | > 90% | Cảnh báo không nhập thêm |

---

## I. FORM NHẬT KÝ NUÔI (P301-F01)

### 1.1 Luồng Xử Lý

```
START
  │
  ├─ Chọn Ao & Ngày
  │  ├─ Validate: Ao đang hoạt động?
  │  ├─ Validate: Ngày trong chu kỳ nuôi?
  │  └─ Load dữ liệu ngày trước
  │
  ├─ Ghi Nhận Môi Trường
  │  ├─ DO Sáng/Chiều
  │  │  └─ Validate: Trong ngưỡng giai đoạn?
  │  ├─ Nhiệt độ Sáng/Chiều
  │  │  └─ Validate: Chênh lệch 0.5-2°C?
  │  └─ pH Sáng/Chiều
  │     └─ Validate: 7-8, chênh lệch ≤ 0.5?
  │
  ├─ Ghi Nhận Cá
  │  ├─ Số lượng cá
  │  │  └─ Tính: SốLượngNgàyTrước - CáChếtNgàyTrước
  │  ├─ Cá chết
  │  │  ├─ Nhập số con
  │  │  └─ Tính khối lượng: (Số con × TLBQ) × 0.8-0.85
  │  └─ Validate: Cá chết vượt ngưỡng?
  │
  ├─ Ghi Nhận Thức Ăn
  │  ├─ Chọn loại thức ăn
  │  ├─ Nhập lượng (kg)
  │  ├─ Nhập MSL & HSD
  │  └─ Validate: HSD hợp lệ?
  │
  ├─ Ghi Nhận Hóa Chất
  │  ├─ Chọn loại hóa chất
  │  ├─ Nhập lượng
  │  ├─ Chọn lý do sử dụng
  │  └─ Validate: MSL & HSD?
  │
  ├─ Kiểm Tra Cảnh Báo
  │  ├─ Mật độ > 37 kg/m²? → Cảnh báo
  │  ├─ Cá chết vượt ngưỡng? → Đề xuất thuốc
  │  ├─ HSD sắp hết? → Cảnh báo
  │  └─ Hiển thị tất cả cảnh báo
  │
  ├─ Lưu Dữ Liệu
  │  ├─ Lưu vào DailyLogs
  │  ├─ Cập nhật FishCount
  │  ├─ Cập nhật tồn kho thức ăn
  │  ├─ Cập nhật tồn kho hóa chất
  │  └─ Tạo bản ghi audit
  │
  └─ END
```

### 1.2 Công Thức Tính Toán

**Số lượng cá**:
```
IF NgàyNuôi = 1 THEN
    FishCount = InitialFishCount
ELSE IF NgàyNuôi = 2 THEN
    FishCount = InitialFishCount - DeadCount[Ngày 1]
ELSE
    FishCount = FishCount[Ngày trước] - DeadCount[Ngày trước]
END IF

// Kiểm tra thu tỉa
IF CóThuTỉa THEN
    FishCount = FishCount - HarvestedCount
END IF
```

**Khối lượng cá chết**:
```
DeadWeightKg = (DeadCount × TLBQ) × 0.825
DeadWeightKg = ROUND(DeadWeightKg, 0.5)

// Ví dụ: 453 con × 0.02 kg × 0.825 = 7.47 ≈ 7.5 kg
```

**Mật độ nuôi**:
```
Biomass = FishCount × TLBQ
Density = Biomass / WaterSurfaceArea

IF Density > 37 THEN
    Alert = "Mật độ vượt 37 kg/m² (Hiện tại: " + Density + ")"
    AlertLevel = "HIGH"
END IF
```

**Lượng thức ăn tối đa**:
```
IF TLBQ < 100g THEN
    MaxFeed = (4 × TLBQ × FishCount) / 100
ELSE IF TLBQ < 200g THEN
    MaxFeed = (3 × TLBQ × FishCount) / 100
ELSE
    MaxFeed = (2 × TLBQ × FishCount) / 100
END IF
```

---

## II. FORM SỔ KHO THỨC ĂN (P301-F07)

### 2.1 Luồng Xử Lý

```
START
  │
  ├─ Chọn Loại Thức Ăn
  │  ├─ Dropdown: Tên thức ăn
  │  ├─ Dropdown: Độ đạm
  │  ├─ Dropdown: Kích cỡ
  │  └─ Load dữ liệu tồn kho hiện tại
  │
  ├─ Nhập Dữ Liệu Nhập Kho
  │  ├─ Ngày nhập
  │  ├─ Lượng nhập (kg)
  │  ├─ MSL (Mã số lô)
  │  ├─ HSD (Hạn sử dụng)
  │  └─ Validate:
  │     ├─ Ngày nhập ≤ TODAY()?
  │     ├─ Ngày nhập ≤ HSD?
  │     └─ Lượng > 0?
  │
  ├─ Tính HSD từ MSL (Nếu cần)
  │  ├─ Lấy ký tự 3-4 từ MSL
  │  ├─ Chuyển sang ngày Julian
  │  ├─ Cộng 89 ngày
  │  └─ Hiển thị HSD tính toán
  │
  ├─ Nhập Dữ Liệu Xuất Kho
  │  ├─ Ngày xuất
  │  ├─ Lượng xuất (kg)
  │  ├─ Ao sử dụng
  │  └─ Validate:
  │     ├─ Lượng xuất ≤ Tồn kho?
  │     └─ Ngày xuất ≥ Ngày nhập?
  │
  ├─ Tính Tồn Kho
  │  ├─ TồnCuối = TồnĐầu + Nhập - Xuất
  │  ├─ Validate: TồnCuối ≥ 0?
  │  └─ Hiển thị tồn kho
  │
  ├─ Kiểm Tra Tình Trạng
  │  ├─ Khô ráo?
  │  ├─ Không nấm mốc?
  │  ├─ Nguyên vẹn?
  │  └─ Kết luận: Đạt / Không đạt
  │
  ├─ Cảnh Báo HSD
  │  ├─ IF TODAY() > HSD THEN
  │  │   Alert = "Thức ăn đã hết hạn"
  │  │   AllowUse = FALSE
  │  ├─ ELSE IF (HSD - TODAY()) ≤ 7 THEN
  │  │   Alert = "HSD sắp hết (còn X ngày)"
  │  │   AlertLevel = "WARNING"
  │  └─ END IF
  │
  ├─ Lưu Dữ Liệu
  │  ├─ Lưu vào FeedInventory
  │  ├─ Cập nhật tồn kho
  │  └─ Tạo bản ghi audit
  │
  └─ END
```

### 2.2 Công Thức Tính HSD

**Từ MSL**:
```
MSL = "0125-32201914"

// Lấy ký tự 3-4 từ bên phải (ngày Julian)
NgàyJulian = MID(MSL, 3, 3)  // "322"

// Cộng 89 ngày
NgàyHSD_Julian = INT(NgàyJulian) + 89  // 411

// Chuyển đổi sang năm tiếp theo nếu > 365
IF NgàyHSD_Julian > 365 THEN
    Năm = Năm + 1
    NgàyHSD_Julian = NgàyHSD_Julian - 365
END IF

// Chuyển đổi ngày Julian sang ngày/tháng/năm
HSD = ConvertJulianToDate(NgàyHSD_Julian, Năm)
// Kết quả: 2024-10-07
```

---

## III. FORM SỔ KHO HÓA CHẤT (P303-F04)

### 3.1 Luồng Xử Lý

```
START
  │
  ├─ Chọn Loại Hóa Chất
  │  ├─ Dropdown: Tên sản phẩm
  │  ├─ Hiển thị: Công ty, Quy cách
  │  └─ Load dữ liệu tồn kho
  │
  ├─ Nhập Dữ Liệu Nhập Kho
  │  ├─ Ngày nhập
  │  ├─ Lượng nhập (kg/lít)
  │  ├─ MSL & HSD
  │  └─ Validate: Ngày nhập ≤ HSD?
  │
  ├─ Nhập Dữ Liệu Xuất Kho
  │  ├─ Ngày xuất
  │  ├─ Lượng xuất
  │  ├─ Ao sử dụng
  │  └─ Validate: Lượng ≤ Tồn kho?
  │
  ├─ Kiểm Tra Sức Chứa Kho
  │  ├─ IF LoạiHóaChất = "Lỏng" THEN
  │  │   TổngLượng = SUM(LượngHóaChấtLỏng)
  │  │   SứcChứa = GetSứcChứaKho()
  │  │   PercentUsed = (TổngLượng / SứcChứa) × 100
  │  │   
  │  │   IF PercentUsed > 90 THEN
  │  │     Alert = "Sức chứa kho vượt 90%"
  │  │     AllowInput = FALSE
  │  │   END IF
  │  └─ END IF
  │
  ├─ Kiểm Tra Tình Trạng
  │  ├─ Nguyên vẹn?
  │  ├─ Khô ráo?
  │  ├─ Sạch sẽ?
  │  └─ Kết luận: Đạt / Không đạt
  │
  ├─ Cảnh Báo HSD
  │  ├─ IF TODAY() > HSD THEN
  │  │   Alert = "Hóa chất đã hết hạn"
  │  │   AllowUse = FALSE
  │  │   Status = "Hết hạn"
  │  └─ END IF
  │
  ├─ Lưu Dữ Liệu
  │  ├─ Lưu vào ChemicalInventory
  │  ├─ Cập nhật tồn kho
  │  └─ Tạo bản ghi audit
  │
  └─ END
```

---

## IV. FORM PHIẾU CHỈ ĐỊNH SỬ DỤNG (P303-F06)

### 4.1 Luồng Xử Lý

```
START
  │
  ├─ Nhập Thông Tin Người Đề Nghị
  │  ├─ Ngày đề nghị
  │  ├─ Tên người đề nghị
  │  ├─ Chức vụ
  │  ├─ Trại/Vùng nuôi
  │  └─ Lý do sử dụng
  │
  ├─ Chọn Sản Phẩm
  │  ├─ IF Lý do = "Xử lý nước" THEN
  │  │   DanhSáchSảnPhẩm = GetSảnPhẩm(Nhóm = "Xử lý nước")
  │  ├─ ELSE IF Lý do = "Bổ sung dinh dưỡng" THEN
  │  │   DanhSáchSảnPhẩm = GetSảnPhẩm(Nhóm = "Dinh dưỡng")
  │  ├─ ELSE IF Lý do = "Trị bệnh" THEN
  │  │   DanhSáchSảnPhẩm = GetSảnPhẩm(Nhóm = "Trị bệnh")
  │  └─ END IF
  │
  ├─ Thêm Chi Tiết Sử Dụng
  │  ├─ Chọn Ao
  │  ├─ Chọn Sản phẩm
  │  ├─ Nhập Lượng
  │  ├─ Chọn Đơn vị
  │  ├─ Validate: Lượng > 0?
  │  └─ Thêm vào bảng
  │
  ├─ Kiểm Tra Lượng Sử Dụng
  │  ├─ IF Sản phẩm = "Vôi" THEN
  │  │   MaxLượng = 500  // kg/10.000m²
  │  │   IF Lượng > MaxLượng THEN
  │  │     Alert = "Lượng vôi vượt mức quy định"
  │  │   END IF
  │  └─ END IF
  │
  ├─ Lưu Phiếu
  │  ├─ Lưu vào ProductUsageForm
  │  ├─ Tạo số phiếu
  │  └─ Tạo bản ghi audit
  │
  ├─ In Phiếu
  │  ├─ Định dạng: P303-F06
  │  ├─ Hiển thị: Người đề nghị & Quản lý
  │  └─ In hoặc xuất PDF
  │
  └─ END
```

---

## V. FORM THEO DÕI CHẤT LƯỢNG NƯỚC (P304-F04 & P304-F07)

### 5.1 Luồng Xử Lý P304-F04

```
START
  │
  ├─ Chọn Vùng & Ngày
  │  ├─ Dropdown: Vùng nuôi
  │  ├─ DatePicker: Ngày ghi nhận
  │  └─ Load dữ liệu ao trong vùng
  │
  ├─ Ghi Nhận Lượng Nước Cấp/Thoát
  │  ├─ For each Ao in Vùng:
  │  │   ├─ Lượng cấp (m³)
  │  │   ├─ Lượng thoát (m³)
  │  │   └─ Validate: Lượng ≥ 0?
  │  │
  │  ├─ Tính Tổng
  │  │   ├─ TổngCấp = SUM(LượngCấp)
  │  │   ├─ TổngThoát = SUM(LượngThoát)
  │  │   └─ Hiển thị tổng
  │  │
  │  └─ Kiểm Tra Giới Hạn
  │     ├─ IF TổngCấp > 8640 THEN
  │     │   Alert = "Lượng nước cấp vượt 8.640 m³/ngày"
  │     │   AllowSave = FALSE
  │     └─ END IF
  │
  ├─ Lưu Dữ Liệu
  │  ├─ Lưu vào WaterIntakeLog
  │  └─ Tạo bản ghi audit
  │
  └─ END
```

### 5.2 Luồng Xử Lý P304-F07

```
START
  │
  ├─ Chọn Vùng & Ngày
  │  ├─ Dropdown: Vùng nuôi
  │  └─ DatePicker: Ngày ghi nhận
  │
  ├─ Ghi Nhận Thời Gian & Lượng Nước
  │  ├─ Thời gian thoát nước
  │  ├─ Lượng nước thoát (m³)
  │  ├─ Thời gian cấp nước
  │  └─ Lượng nước cấp (m³)
  │
  ├─ Ghi Nhận Chỉ Tiêu Nước Thải
  │  ├─ DO (mg/L): Trước/Đang thoát
  │  ├─ pH: Trước/Đang thoát
  │  ├─ Mùi, cảm quan: Trước/Đang thoát
  │  └─ Validate: Trong ngưỡng?
  │
  ├─ Kết Luận
  │  ├─ IF Tất cả chỉ tiêu ≤ Ngưỡng THEN
  │  │   Kết luận = "Đạt"
  │  ├─ ELSE
  │  │   Kết luận = "Không đạt"
  │  └─ END IF
  │
  ├─ Lưu Dữ Liệu
  │  ├─ Lưu vào WasteWaterLog
  │  └─ Tạo bản ghi audit
  │
  └─ END
```

---

## VI. FORM SỔ GIAO NHẬN CHẤT THẢI (P305-F37)

### 6.1 Luồng Xử Lý

```
START
  │
  ├─ Chọn Vùng & Ngày
  │  ├─ Dropdown: Vùng nuôi
  │  └─ DatePicker: Ngày ghi nhận
  │
  ├─ Ghi Nhận Chất Thải
  │  ├─ Loại chất thải: [Cá chết / Thức ăn thừa / ...]
  │  ├─ Đơn vị tính: [kg / bao / ...]
  │  ├─ Số lượng
  │  ├─ Người giao
  │  └─ Người nhận
  │
  ├─ Tính Tổng Hợp
  │  ├─ Tổng cá chết (kg/ngày)
  │  ├─ Tổng thức ăn (kg/ngày)
  │  └─ Hiển thị tổng
  │
  ├─ Lưu Dữ Liệu
  │  ├─ Lưu vào WasteDeliveryLog
  │  └─ Tạo bản ghi audit
  │
  └─ END
```

---

## VII. CẢNH BÁO & VALIDATION

### 7.1 Bảng Cảnh Báo

| Sự kiện | Điều kiện | Mức | Hành động |
|---------|-----------|-----|----------|
| Mật độ cao | > 37 kg/m² | 🔴 HIGH | Dừng cho ăn, xử lý nước |
| Cá chết vượt | > Ngưỡng giai đoạn | 🔴 HIGH | Đề xuất thuốc trị bệnh |
| HSD hết | TODAY() > HSD | 🔴 HIGH | Cấm sử dụng |
| HSD sắp hết | < 7 ngày | 🟡 WARNING | Ưu tiên sử dụng |
| Sức chứa kho | > 90% | 🟡 WARNING | Cảnh báo không nhập |
| DO thấp | < Ngưỡng sáng | 🟡 WARNING | Kiểm tra máy sục khí |
| Nhiệt độ cao | > Ngưỡng chiều | 🟡 WARNING | Tăng trao đổi nước |

---

## X. THÔNG TIN TRANG ĐẦU NHẬT KÝ NUÔI (NK-P301-F01)

### 10.1 Phần I: Thông Tin Ao Nuôi

| Trường | Mô tả | Nguồn dữ liệu | Loại |
|--------|-------|---------------|------|
| I.1 | Địa chỉ (ao + vụ + địa chỉ) | "thong ke thong tin farms" | Tự động |
| I.2 | Số điện thoại (SĐT) | "thong ke thong tin farms" sheet "thong tin QL" | Dropdown |
| I.3 | Quản lý | "thong ke thong tin farms" sheet "thong tin QL" | Dropdown |
| I.4 | Diện tích ao (m²) | "thong ke thong tin farms" | Tự động |
| I.5 | Diện tích mặt nước (m²) | "thong ke thong tin farms" | Tự động |
| I.6 | Độ sâu (m) | "thong ke thong tin farms" | Tự động |

### 10.2 Phần II: Chuẩn Bị Ao Nuôi Trước Khi Thả

| Trường | Mô tả | Loại | Ghi chú |
|--------|-------|------|---------|
| II.1 | Ngày thu hoạch vụ trước | Tự nhập | Định dạng: Ngày/Tháng/Năm |
| II.2 | Ngày ao trống | Tự động | Công thức: (Ngày thả - Ngày thu hoạch) + 1 |
| II.3 | Ngày cải tạo ao | Tự động | Từ ngày hóa chất đầu tiên đến ngày thả - 1 |
| II.4 | Cách cải tạo ao | Mặc định | Giá trị: "Vét bùn" |
| II.5 | Kích cỡ mắt lưới (cm) | Chọn | Tùy chọn: 0.5, 1, 1.2, 2 |
| II.5b | Kích cỡ mắt lưới bổ sung (cm) | Chọn | Tùy chọn: 0.5, 1, 1.2, 2 |
| II.6 | Mực nước trước thả (m) | Tự động | Từ "thong ke thong tin farms" |
| II.7 | Sử dụng sản phẩm cải tạo ao | Mặc định | Giá trị: "Có" |
| II.8 | Chất lượng nước trước thả | Tự động/Chọn | DO, pH, Nhiệt độ từ dữ liệu; H2S=0; NH3=0.01 hoặc 0.03; Độ kiềm: 71.6 hoặc 89.5 |
| II.9 | Kết cấu bờ ao | Checkbox | Tùy chọn: Đất sét, Sét pha cát, Đất cát, Loại khác |

### 10.3 Phần III: Thông Tin Cá Giống

| Trường | Mô tả | Loại | Ghi chú |
|--------|-------|------|---------|
| III.1 | Loại cá nuôi | Chọn | Tùy chọn: Cá tra, Rô phi |
| III.2.1 | Ao giống/Mã ao | Tự nhập | - |
| III.2.2 | Tên trại giống | Dropdown | Từ "thong ke thong tin farms" |
| III.3 | Địa chỉ trại giống | Tự động | Dựa trên tên trại giống |
| III.4 | Kích cỡ giống thả | Chọn/Tính | Tùy chọn (cm): 1.7, 2, 2.5, Khác; Hoặc tính: (III.9/III.8)×1000 |
| III.5 | Tuổi giống (ngày) | Tự nhập | - |
| III.6 | Mật độ thả (con/m²) | Tự động | Công thức: Số lượng / Diện tích mặt nước (lấy chẵn) |
| III.7 | Ngày thả | Tự nhập | Định dạng: Ngày/Tháng/Năm |
| III.8 | Số lượng giống thả (con) | Tự nhập | - |
| III.9 | Khối lượng giống thả (kg) | Tự nhập | - |
| III.10 | Sản lượng dự kiến (tấn) | Tự nhập | - |

---

## XI. CÁC CỘT DỮ LIỆU NHẬT KÝ HÀNG NGÀY

| # | Cột | Đơn vị | Mô tả |
|---|-----|--------|-------|
| 1 | Ngày (Date) | YYYY-MM-DD | Ngày ghi nhận |
| 2 | Ngày nuôi (Days from stocking) | Ngày | Số ngày từ ngày thả |
| 3 | Số lượng cá (Fish number) | con | Số lượng cá hiện tại |
| 4 | DO (Dissolved Oxygen) | mg/L | Nồng độ oxy hòa tan |
| 5 | Nhiệt độ nước (Temperature) | °C | Nhiệt độ nước ao |
| 6 | pH | - | Độ pH nước |
| 7-9 | Thức ăn: Công ty, Độ đạm, Kích cỡ | - | Thông tin thức ăn |
| 10 | Thức ăn: Mã số lô (Batch code) | - | Mã lô thức ăn |
| 11 | Thức ăn: Hạn sử dụng (Expiry date) | YYYY-MM-DD | Ngày hết hạn |
| 12 | Thức ăn: Tổng lượng (Total quantity) | kg | Lượng thức ăn sử dụng |
| 13 | Cá chết: Số lượng (Number) | con | Số lượng cá chết |
| 14 | Cá chết: Tổng khối lượng (Total quantity) | kg | Khối lượng cá chết |
| 15 | Hóa chất: Tên sản phẩm (Name) | - | Tên hóa chất sử dụng |
| 16 | Hóa chất: Mã lô & HSD (Batch code - Expiry) | - | Mã lô và hạn sử dụng |
| 17 | Hóa chất: Lượng sử dụng (Quantity) | kg/lít | Lượng hóa chất |
| 18 | Hóa chất: Lý do sử dụng (Reason) | - | Lý do sử dụng |
| 19 | Ghi chú (Notes) | - | Ghi chú bổ sung |
| 20 | Người chịu trách nhiệm (Responsible staff) | - | Tên người phụ trách |

---

## XII. HƯỚNG DẪN GHI NHẬN DỮ LIỆU

### 12.1 Số Lượng Cá (Fish Number)

```
- Ngày đầu tiên: = Số con thả
- Các ngày tiếp theo: = Số lượng cá ngày trước - Số lượng cá chết ngày trước
- Trường hợp thu tỉa: Không ghi số con vào ngày thu tỉa, 
  sau đó ghi: = Lượng con ngày trước - (Cá chết + Cá thu hoạch)
- Trường hợp thu hoạch hết: Ghi đến ngày thu hoạch đầu tiên
```

### 12.2 Ghi Chú (Notes) - 9 Trường Hợp

```
1. "Thả cá" → Ngày đầu tiên thả
2. "Bình thường" → Quá trình nuôi bình thường
3. "Không thu hoạch trước ngày…" → Khi sử dụng thuốc trị bệnh (Ngày sử dụng + 28 ngày)
4. "Bình thường cắt mồi lúc 17h00" → Trước thu hoạch 1 ngày
5. "Thu hoạch + số con" → Nếu thu tỉa 1 ngày hoặc ngày cuối cùng của đợt thu tỉa
6. "Thu hoạch" → Tất cả các ngày khi thu hoạch 1 lần hết ao
7. "Tháo mắt lưới bổ sung" → Khi TLBQ > 100g
8. "Cắt mồi" → Khi cắt mồi trước thu hoạch
9. Ghi lượng thu tỉa → Ví dụ: "70.000kg"
```

### 12.3 Cá Chết - Tổng Khối Lượng (Total Quantity)

```
Công thức: (Số con cá chết × TLBQ) × 80-85%
Kết quả: Làm tròn đến 0.5kg
```

### 12.4 Tính Hạn Sử Dụng Thức Ăn

```
Công thức: Ký tự 2-4 từ bên phải MSL (ngày Julian) + 89 ngày
Ví dụ: MSL "0125-32201914" → Lấy "3220" → Ngày Julian 322 + 89 = Ngày 411 (năm sau)
```

---

## XIII. DỮ LIỆU TỔNG HỢP CUỐI KỲ

| Chỉ tiêu | Mô tả | Công thức |
|----------|-------|----------|
| Tổng lượng thức ăn | Cộng từ đầu vụ | SUM(Tổng lượng thức ăn hàng ngày) |
| Tổng cá chết | Cộng từ đầu vụ | SUM(Số lượng cá chết hàng ngày) |
| Tổng khối lượng cá chết | Cộng từ đầu vụ | SUM(Tổng khối lượng cá chết hàng ngày) |
| TLBQ (Trọng lượng bình quân) | Từ cân mẫu | Từ dữ liệu cân mẫu định kỳ |
| Mật độ (kg/m²) | Tính từ TLBQ | (Số lượng cá × TLBQ) / Diện tích mặt nước |

---

## XIV. CÁC FILE NGUỒN DỮ LIỆU THAM CHIẾU

- **"thong ke thong tin farms"**: Thông tin ao, quản lý, trại giống
- **"Danh mục hóa chất"**: Nhà sản xuất, quy cách hóa chất
- **"Ds ghe vận chuyển thức ăn"**: Danh sách ghe vận chuyển
- **"bac si ngu y"**: Lịch cân mẫu định kỳ
- **"quy tac ca chet"**: Quy tắc tính cá chết
- **"quy tac moi truong"**: Quy tắc môi trường ao nuôi

---

## XV. VÍ DỤ DỮ LIỆU THỰC TẾ

**Ngày 2024-07-27 (Ngày thả cá - Ngày nuôi 1)**
- Số lượng cá: 451,600 con
- DO: 3.6-4.1 mg/L | Nhiệt độ: 29.5-30.2°C | pH: 7-7.5
- Cá chết: 453 con, 9 kg
- Ghi chú: "Thả cá"

**Ngày 2024-07-28 (Ngày nuôi 2)**
- Số lượng cá: 451,147 con (= 451,600 - 453)
- Thức ăn: Feed One 26-3, MSL: 0125-32201914, HSD: 2024-10-07
- Tổng lượng thức ăn: 160 kg
- Cá chết: 667 con, 13.5 kg
- Ghi chú: "Bình thường"

**Ngày 2025-02-11 (Ngày nuôi 200 - Thu hoạch)**
- Số lượng cá: 448,036 con
- Cá chết: 83 con, 51 kg
- Ghi chú: "Thu hoạch 75,949 con"

---

**Tài liệu**: Phát Triển Window Form QLCLN  
**Trạng thái**: Hoàn tất đầy đủ  
**Phiên bản**: 2.0
