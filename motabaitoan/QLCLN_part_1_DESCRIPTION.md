# Mô Tả Chi Tiết Nội Dung Yêu Cầu Quản Lý Chất Lượng Lâm Nghiệp (QLCLN)

## I. DANH SÁCH CÁC YÊU CẦU THAO TÁC (15 yêu cầu)

### 1. **Nhật ký nuôi - Thông tin thu hoạch**
- **Biểu mẫu**: Nhật ký nuôi (P301-F01)
- **Nội dung**: Nhập liệu Thời gian thu hoạch, Sản lượng thu hoạch, TLBQ (Trọng lượng bình quân) thu hoạch và thu tỉa, FCR

### 2. **Nhật ký nuôi - Cảnh báo mật độ**
- **Biểu mẫu**: Nhật ký nuôi
- **Nội dung**: Cảnh báo khi mật độ nuôi vượt 37 kg/m²

### 3. **Nhật ký nuôi - Quản lý nhân sự**
- **Biểu mẫu**: Nhật ký nuôi
- **Nội dung**: Trường nhập tên người phụ trách ao, cho phép thay đổi khi luân chuyển nhân sự

### 4. **Nhật ký nuôi - Báo cáo tốc độ tăng trưởng**
- **Biểu mẫu**: Nhật ký nuôi
- **Nội dung**: Báo cáo tốc độ tăng trưởng và mật độ của tất cả các ao cho ngày bất kỳ

### 5. **Sổ giao nhận chất thải - Cá chết**
- **Biểu mẫu**: Sổ giao nhận chất thải (P305-F37)
- **Nội dung**: Tổng hợp số lượng cá chết (kg/ngày) trừ những ao vượt ngưỡng

### 6. **Sổ giao nhận chất thải - Thức ăn**
- **Biểu mẫu**: Sổ giao nhận chất thải (P305-F37)
- **Nội dung**: Tổng hợp lượng thức ăn, chọn đơn vị (bao 40kg hoặc túi 600kg), tính số bao bì rỗng

### 7. **Phiếu sức khỏe cá nuôi - Ngày cân mẫu**
- **Biểu mẫu**: Phiếu sức khỏe cá nuôi (P303-F07)
- **Nội dung**: Tổng hợp thông tin ngày cân mẫu: Ngày, ao, số cá chết, TLBQ, loại + lượng hóa chất

### 8. **Phiếu chỉ định sản phẩm - Hóa chất**
- **Biểu mẫu**: Phiếu chỉ định sản phẩm (P303-F06)
- **Nội dung**: Tổng hợp thông tin hóa chất (trừ thuốc trị bệnh): Ngày, ao, tên sản phẩm, đơn vị, lượng, lý do

### 9. **Sổ kho thức ăn**
- **Biểu mẫu**: Sổ theo dõi thức ăn (P301-F07)
- **Nội dung**: Tổng hợp lượng thức ăn/ngày, phân biệt theo kích cỡ, nhập: ngày, lượng, MSL, quy cách
- **Cảnh báo**: Ngày nhập trước ngày sản xuất hoặc hết HSD
- **HSD tính**: Ký tự 2-4 từ phải MSL (ngày Julian) + 89 ngày

### 10. **Sổ kho hóa chất**
- **Biểu mẫu**: Sổ theo dõi hóa chất (P303-F04)
- **Nội dung**: Tổng hợp lượng hóa chất/ngày, phân biệt theo loại, nhập: ngày, lượng, MSL, HSD
- **Cảnh báo**: Khi phát hiện hết HSD

### 11. **Cảnh báo hóa chất lỏng - Sức chứa kho**
- **Biểu mẫu**: Sổ kho hóa chất (P303-F04)
- **Nội dung**: Cảnh báo khi hóa chất lỏng vượt 90% sức chứa kho

### 12. **Biên bản giao nhận thức ăn**
- **Biểu mẫu**: Biên bản giao nhận thức ăn (P301-F06)
- **Nội dung**: Tổng hợp từ P301-F07, chọn ghe vận chuyển, người vận chuyển, nhập tên người nhận
- **Cố định**: "Huyện Cao Lãnh - Đồng Tháp" (48h trước)

### 13. **Biên bản giao nhận hóa chất**
- **Biểu mẫu**: Biên bản giao nhận hóa chất (P303-F03)
- **Nội dung**: Tổng hợp từ P303-F04, nhập tên người nhận
- **Cố định**: Người giao "Lê Thị Hồng Ngọc", "Thành phố Cao Lãnh - Đồng Tháp" (48h trước)

### 14. **Kiểm tra lượng nước cấp - Thoát ao nuôi**
- **Nội dung**: Cho phép chọn nhịp trao đổi nước của vùng khi bắt đầu chạy phần mềm

### 15. **Kiểm tra lượng nước cấp - Kết quả theo dõi nước thải**
- **Nội dung**: Cho phép thay đổi giới hạn nước cấp và xả thải của vùng (khi có giấy phép mới)

---

## II. THÔNG TIN TRANG ĐẦU NHẬT KÝ NUÔI (NK-P301-F01)

### **Phần I: Thông tin ao nuôi**

| Trường | Mô tả | Nguồn dữ liệu | Loại |
|--------|-------|---------------|------|
| I.1 | Địa chỉ (ao + vụ + địa chỉ) | "thong ke thong tin farms" | Tự động |
| I.2 | Số điện thoại (SĐT) | "thong ke thong tin farms" sheet "thong tin QL" | Dropdown |
| I.3 | Quản lý | "thong ke thong tin farms" sheet "thong tin QL" | Dropdown |
| I.4 | Diện tích ao (m²) | "thong ke thong tin farms" | Tự động |
| I.5 | Diện tích mặt nước (m²) | "thong ke thong tin farms" | Tự động |
| I.6 | Độ sâu (m) | "thong ke thong tin farms" | Tự động |

### **Phần II: Chuẩn bị ao nuôi trước khi thả**

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

### **Phần III: Thông tin cá giống**

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

## III. CÁC CỘT DỮ LIỆU NHẬT KÝ HÀNG NGÀY

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

## IV. HƯỚNG DẪN GHI NHẬN DỮ LIỆU

### **Số lượng cá (Fish number)**
- **Ngày đầu tiên**: = Số con thả
- **Các ngày tiếp theo**: = Số lượng cá ngày trước - Số lượng cá chết ngày trước
- **Trường hợp thu tỉa**: Không ghi số con vào ngày thu tỉa, sau đó ghi: = Lượng con ngày trước - (Cá chết + Cá thu hoạch)
- **Trường hợp thu hoạch hết**: Ghi đến ngày thu hoạch đầu tiên

### **Ghi chú (Notes) - 9 trường hợp**
1. **"Thả cá"** → Ngày đầu tiên thả
2. **"Bình thường"** → Quá trình nuôi bình thường
3. **"Không thu hoạch trước ngày…"** → Khi sử dụng thuốc trị bệnh (Ngày sử dụng + 28 ngày)
4. **"Bình thường cắt mồi lúc 17h00"** → Trước thu hoạch 1 ngày
5. **"Thu hoạch + số con"** → Nếu thu tỉa 1 ngày hoặc ngày cuối cùng của đợt thu tỉa
6. **"Thu hoạch"** → Tất cả các ngày khi thu hoạch 1 lần hết ao
7. **"Tháo mắt lưới bổ sung"** → Khi TLBQ > 100g
8. **"Cắt mồi"** → Khi cắt mồi trước thu hoạch
9. **Ghi lượng thu tỉa** → Ví dụ: "70.000kg"

### **Cá chết - Tổng khối lượng (Total quantity)**
- **Công thức**: (Số con cá chết × TLBQ) × 80-85%
- **Kết quả**: Làm tròn đến 0.5kg

### **Tính hạn sử dụng thức ăn**
- **Công thức**: Ký tự 2-4 từ bên phải MSL (ngày Julian) + 89 ngày
- **Ví dụ**: MSL "0125-32201914" → Lấy "3220" → Ngày Julian 322 + 89 = Ngày 411 (năm sau)

---

## V. DỮ LIỆU TỔNG HỢP CUỐI KỲ

| Chỉ tiêu | Mô tả | Công thức |
|----------|-------|----------|
| Tổng lượng thức ăn | Cộng từ đầu vụ | SUM(Tổng lượng thức ăn hàng ngày) |
| Tổng cá chết | Cộng từ đầu vụ | SUM(Số lượng cá chết hàng ngày) |
| Tổng khối lượng cá chết | Cộng từ đầu vụ | SUM(Tổng khối lượng cá chết hàng ngày) |
| TLBQ (Trọng lượng bình quân) | Từ cân mẫu | Từ dữ liệu cân mẫu định kỳ |
| Mật độ (kg/m²) | Tính từ TLBQ | (Số lượng cá × TLBQ) / Diện tích mặt nước |

---

## VI. CÁC FILE NGUỒN DỮ LIỆU THAM CHIẾU

- **"thong ke thong tin farms"**: Thông tin ao, quản lý, trại giống
- **"Danh mục hóa chất"**: Nhà sản xuất, quy cách hóa chất
- **"Ds ghe vận chuyển thức ăn"**: Danh sách ghe vận chuyển
- **"bac si ngu y"**: Lịch cân mẫu định kỳ
- **"quy tac ca chet"**: Quy tắc tính cá chết
- **"quy tac moi truong"**: Quy tắc môi trường ao nuôi

---

## VII. VÍ DỤ DỮ LIỆU THỰC TẾ

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

## VIII. QUY TẮC MÔI TRƯỜNG AO NUÔI (quy tac moi truong ao nuôi)

### **Chỉ tiêu DO (Dissolved Oxygen - mg/L)**

**Tần suất đo**: 2 lần/ngày (Sáng & Chiều)

**Yêu cầu chung**: 
- Buổi sáng thấp hơn buổi chiều
- Chênh lệch trong ngày: min = 0.2, max = 1, bước nhảy = 0.1

| Giai đoạn | Sáng | Chiều |
|-----------|------|-------|
| **Tuần đầu** | 3.5 - 3.9 | 3.9 - 4.5 |
| **Tuần 2 - Tháng 1** | 3.0 - 3.5 | 3.5 - 3.9 |
| **2 tháng tiếp theo** | 2.9 - 3.2 | 3.2 - 3.5 |
| **Các tháng còn lại** | 2.6 - 2.9 | 2.8 - 3.4 |

### **Chỉ tiêu Nhiệt độ nước (°C)**

**Tần suất đo**: 2 lần/ngày (Sáng & Chiều)

**Yêu cầu chung**:
- Buổi sáng thấp hơn buổi chiều
- Chênh lệch trong ngày: min = 0.5, max = 2, bước nhảy = 0.1
- **Lưu ý**: Tháng đề cập là tháng của năm chứ không phải tháng nuôi

| Giai đoạn | Sáng | Chiều |
|-----------|------|-------|
| **Tháng 2 - 5** | 28 - <30 | 29 - <32 |
| **Tháng 6 - 10** | 27 - <30 | 29 - <31 |
| **Tháng 11 - 1** | 26 - <29 | 28 - <30 |

### **Chỉ tiêu pH**

**Tần suất đo**: 2 lần/ngày (Sáng & Chiều)

**Yêu cầu chung**:
- Buổi sáng thấp hơn buổi chiều
- Chênh lệch trong ngày: không quá 0.5
- Bước nhảy: 0.1

| Giai đoạn | Giá trị |
|-----------|--------|
| **Tất cả giai đoạn** | 7 - 8 |

---

## IX. DANH MỤC HÓA CHẤT (44 sản phẩm)

### **Nhóm 1: Bổ sung Dinh dưỡng (23 sản phẩm)**

| STT | Tên sản phẩm | Lượng sử dụng | Công ty sản xuất | Quy cách |
|-----|--------------|---------------|------------------|----------|
| 1 | VITALUCAN - B12 NEW | 3kg/1 tấn TA | Công ty Cổ Phần UV | 1 kg/gói |
| 2 | VIMELEC CONCENTRATED | 1kg/1 tấn TA | Vemedim | 1 kg/gói |
| 3 | VITAMIN C ANTISTRESS | 1kg/500kg TA | Vemedim | 1 kg/gói |
| 4 | UV - FeB12 max | 1 lít/500kg TA | Công ty Cổ Phần UV | 1 lít/chai |
| 5 | UV-ZYMLUS MAX | 1 lít/700kg TA | Công ty Cổ Phần UV | 1 lít/chai |
| 6 | PZOZYME | 1kg/500kg TA | Công ty Cổ Phần UV | 1 kg/gói |
| 7 | HEPAMIN super | 1 lít/300kg TA | Công ty Cổ Phần UV | 1 lít/chai |
| 8 | BIO IMMUNE-100 | 1 lít/1 tấn TA | KHANG ANH | 1 lít/chai |
| 9 | PHYLUS | 2kg/1 tấn TA | Vemedim | 1 kg/gói |
| 10 | UV-BIOMAX | 1kg/500kg TA | Công ty Cổ Phần UV | 1 kg/gói |
| 11 | VITALEC FISH + | 1kg/1 tấn TA | Provimi | 1 kg/gói |
| 12 | LIVERED | 1 bộ/300kg TA | Vemedim | bộ |
| 13 | UV-BIOLAC | Cá <100g: 1lít/300kg; Cá >100g: 1lít/700kg | Công ty Cổ Phần UV | 3 lít/chai |
| 14 | CHOLINE-H | 1kg/1 tấn TA | AMORVET - ẤN ĐỘ | 1 kg/gói |
| 15 | UV-VITALET new | 1kg/500kg TA | Công ty Cổ Phần UV | 1 kg/gói |
| 16 | BIO-C COMPLEX | 1kg/1 tấn TA | AMORVET - ẤN ĐỘ | 1 kg/gói |
| 17 | P - COMPLEX - TẢO - 100 | 1kg/1 tấn TA | KHANG ANH | 500 gr/gói |
| 18 | VIT 2 | 2kg/1 tấn TA | Công ty TNHH Tiệp Phát | 1 kg/gói |
| 19 | VC-FISH | 1kg/1 tấn TA | KHANG ANH | 1 kg/gói |
| 20 | UV-C MIN | 1kg/1 tấn TA | Công ty Cổ Phần UV | 1 kg/gói |
| 21 | AQUA C ® FISH PLUS | 1kg/500kg TA | MSD ANIMAL HEALTH VN | 1 kg/gói |
| 22 | Lactozyme | 2kg/1 tấn TA | Vemedim | 1 kg/gói |
| 23 | FOLIC new | 1kg/500kg TA | Công ty Cổ Phần UV | 1 kg/gói |

### **Nhóm 2: Xử lý Nước (17 sản phẩm)**

| STT | Tên sản phẩm | Lượng sử dụng | Công ty sản xuất | Quy cách |
|-----|--------------|---------------|------------------|----------|
| 24 | PRO-POND new | Trước thả: 0.5l/5.000m³; Dùng: 0.5l/2.000m³ | Công ty Cổ Phần UV | 5 lít/can |
| 25 | COMPLEX NEW | 1lít/7.000m³ | Công ty Cổ Phần UV | 1 lít/chai |
| 26 | D - FLOW | 2 lít/1000m³ | PINPANAT - THAILAND | 20 lít/can |
| 27 | RODO-UV | 1 lít/1.500m³ | Công ty Cổ Phần UV | 10 lít/can |
| 28 | Z-17 | 1kg/10.000m³ | KHANG ANH | 500 gr/gói |
| 29 | TRICON | 1kg/10.000m² | ICON Formulation | 1 kg/gói |
| 30 | EM-F1 | Trước: 1lít/2500m³ (2 ngày); Dùng: 1lít/2000m³ (2 ngày) | Công ty Cổ Phần UV | 5 lít/can |
| 32 | VÔI | Trước: 500kg/10.000m²; Dùng: 20kg/10.000m³ | C.P Việt Nam | 25 kg/bao |
| 33 | GLU-RV new | 1 lít/6.000m³ | Công ty Cổ Phần UV | 1 lít/chai |
| 34 | Pond-Rhodo | 1 lít/1.500m³ (2 ngày liên tục) | Vemedim | 20 lít/can |
| 35 | RHODO POWER | Tháng 1: 1lít/10.000m²; Tháng 2: 3lít/10.000m²; Tháng 3: 5lít/10.000m²; Tháng 4: 7lít/10.000m² | Abtech | 30 lít/can |
| 36 | BIO-ZEOTC | 1kg/1000m² | Abtech | 10 kg/gói |
| 37 | WIN-POND | 3kg/8000m³ (2 ngày liên tục) | Công ty Cổ Phần UV | 25 kg/bao |
| 38 | HIVIDINE 90 | 1 lít/1.500m³ | Công ty TNHH Tiệp Phát | 1 lít/chai |
| 39 | YUCCA NEO | 1 lít/13000m² | AMORVET - ẤN ĐỘ | 1 lít/chai |
| 40 | ASI-ANTI SHOCK | 1kg/5.000m³ | ASIFAC | 1 kg/gói |

### **Nhóm 3: Trị Ký sinh Trùng (3 sản phẩm)**

| STT | Tên sản phẩm | Lượng sử dụng | Công ty sản xuất | Quy cách |
|-----|--------------|---------------|------------------|----------|
| 41 | FIBA | 1 lít/1.000m³ nước | Công ty TNHH Thủy Sinh | 5 lít/can |
| 42 | LICINIL -100 | 1kg/1 tấn TA | KHANG ANH | 500 gr/gói |
| 43 | FENBOVET-P | 1kg/1 tấn TA | KHANG ANH | 1 kg/gói |

### **Nhóm 4: Trị Bệnh (1 sản phẩm)**

| STT | Tên sản phẩm | Lượng sử dụng | Công ty sản xuất | Quy cách |
|-----|--------------|---------------|------------------|----------|
| 44 | VIME - FENFISH | 1 lít/1.5-2 tấn TA | Vemedim | 1 lít/chai |

---

## X. DANH MỤC MÃ SỐ THÀNH PHẨM (MTP) - 30 loại thức ăn

Các loại thức ăn cá tra Feed One với các kích cỡ khác nhau (2-8 li) và độ đạm (22-26%):

**Ví dụ**:
- Code 0104: Feed One 2 li 22 đạm
- Code 0125: Feed One 3 li 26 đạm
- Code 0128: Feed One 8 li 26 đạm
- ... (tổng 30 mã)

---

## XI. DANH SÁCH GHE VẬN CHUYỂN THỨC ĂN (24 ghe)

| STT | Người vận chuyển | Số ghe | Tải trọng (tấn) |
|-----|------------------|--------|-----------------|
| 1 | Lê Thanh Long | ĐT-26106 | 178 |
| 2 | Lê Thanh Thới | ĐT-25312 | 95 |
| 3 | Lê Văn Tâm | AG-10933 | 110 |
| 4 | Võ Thanh Bình | ĐT-23433 | 95 |
| 5 | Nguyễn Phi Long | ĐT-25411 | 142 |
| 6 | Nguyễn Tất Lập | AG-24686 | 144 |
| 7 | Nguyễn Văn Nghĩa | CT-10927 | 195 |
| 8 | Nguyễn Thành Luân | ĐT-25474 | 90 |
| 9 | Nguyễn Thị Kiều Hoa | ĐT-25568 | 97 |
| 10 | Nguyễn Văn Hồng | ĐT-23965 | 119 |
| 11 | Trần Văn Bé Sáu | AG-21833 | 90 |
| 12 | Nguyễn Thu Hà | ĐT-25467 | 188 |
| 13 | Trương Hoàng Nhựt | ĐT-22759 | 120 |
| 14 | Phan Thanh Hào | AG-22967 | 64 |
| 15 | Trần Văn Vĩnh | ĐT-25986 | 109 |
| 16 | Võ Duy Trường | ĐT-25142 | 120 |
| 17 | Huỳnh Bích Thủy | ĐT-22677 | 120 |
| 18 | Nguyễn Thị Kim Phượng | ĐT-23835 | 98 |
| 19 | Cao Bảo Trọng | AG-21503 | 40 |
| 20 | Nguyễn Thành Bờ (Nguyễn Thị Nhung) | ĐT-22214 | 120 |
| 21 | Trần Tuấn Tú | AG-25290 | 60 |
| 22 | Lê Chánh Tây | CT-11073 | 178 |
| 23 | Nguyễn Văn Thẳng | ĐT-01594 | 120 |
| 24 | Nguyễn Thành Lộc | ĐT-26337 | 100 |

---

## XII. QUY TẮC SỬ DỤNG THỨC ĂN & HÓA CHẤT (quy tac sd TA, HC)

### **A. QUY TẮC SỬ DỤNG THỨC ĂN**

#### **1. Kích cỡ thức ăn theo kích cỡ cá**

| Kích cỡ cá | Kích cỡ TA (tối đa) | Khẩu phần | Công thức tính lượng tối đa |
|-----------|-------------------|----------|---------------------------|
| 15 - 80g | 2 - 3 mm | 4% trọng lượng thân | (4 × TLBQ × Số lượng cá) / 100 |
| 80 - 200g | 3 - 4 mm | 3% trọng lượng thân | (3 × TLBQ × Số lượng cá) / 100 |
| 200 - 1000g | 4 - 6 mm | 2% trọng lượng thân | (2 × TLBQ × Số lượng cá) / 100 |

#### **2. Các quy tắc bổ sung**

- **Lượng cho ăn**: Phải chẵn 1 bao (40kg), từ 2mm-26 đạm đến 6mm-22 đạm
- **Trường hợp 2 loại MSL**: Nếu 1 ngày ăn 2 loại mã lô cùng 1 loại ly → cần tách ra 2 dòng (MSL, HSD, lượng riêng)
- **Hết kích cỡ**: Có thể lấy loại kích cỡ tiếp theo còn trong kho
- **Khi sử dụng thuốc trị bệnh**: Giảm 50% lượng TA so với ngày trước; sau hết bệnh tăng dần
- **Sau thu tỉa**: Giảm lượng TA tương đương với lượng cá còn lại
- **Tăng/giảm TA**: Không được chênh lệch quá 50% so với ngày hôm trước

### **B. QUY TẮC SỬ DỤNG HÓA CHẤT**

#### **1. Nhóm Xử lý Nước**

**Cải tạo trước khi thả giống**:
- **Ngày 1**: Vôi (Ổn định hệ đệm)
- **Ngày 2**: Chất xử lý nước (cho chọn theo danh mục) - Xử lý nước, bổ sung vi sinh, diệt tảo

**Trong quá trình nuôi**:
- **Ngày sử dụng đầu tiên**: Chất xử lý nước (Xử lý nước)
- **Định kì**: Sau cấp nước 1 ngày (Định kì xử lý nước)
- **Sau trị bệnh**: Chất xử lý nước (Sát trùng nước)
- **Lưu ý**: Nếu nhịp thay nước trùng với cắt mồi/thu hoạch → không sử dụng
- **Tần suất**: Vi sinh 2 ngày, còn lại 1 ngày

#### **2. Nhóm Dinh dưỡng**

**Trong quá trình nuôi**:
- **Lần đầu**: Bổ sung dinh dưỡng (Tăng sức đề kháng hoặc Bổ sung vitamin)
- **Định kì**: 1 tháng 2 lần (Định kì bổ sung dinh dưỡng)
- **Sau trị bệnh**: Bổ sung dinh dưỡng (Tăng sức đề kháng hoặc Bổ sung vitamin)
- **Tần suất**: Mỗi lần sử dụng 3-5 ngày

#### **3. Nhóm Trị Ký sinh Trùng**

**Trong quá trình nuôi**:
- **Thời gian**: 1-2 ngày sau khi cá chết vượt ngưỡng 1 ngày
- **Sản phẩm**: Ký sinh trùng (cho chọn theo danh mục)
- **Lý do**: Trị ký sinh trùng

#### **4. Nhóm Trị Bệnh**

**Trong quá trình nuôi**:
- **Thời gian**: 5-7 ngày bắt đầu sau khi cá chết vượt ngưỡng 2 ngày
- **Lưu ý**: Không thay nước trong quá trình sử dụng
- **Sản phẩm**: Trị bệnh (cho chọn theo danh mục)
- **Lý do**: Trị xuất huyết (hoặc lý do khác tùy tình huống)

---

## XIII. QUY TẮC CÁ CHẾT (quy tac ca chet)

### **Tỷ lệ chết theo giai đoạn nuôi**

**Lưu ý quan trọng**:
- Tỷ lệ chết dựa trên **kích cỡ giống thả** từ sheet "Thong tin trang dau NK-P301-F01" mục III.4
- Nếu chọn "Khác" → tỷ lệ chết theo TLBQ của cá thả

| Giai đoạn | Tỷ lệ chết/ngày | Ghi chú |
|-----------|-----------------|--------|
| **Cá thả từ ngày 1-7** | < 0.5% (tổng tỉ lệ hao hụt) | Tính từ ngày thả |
| **Cá thả từ ngày 8-14** | < 0.4%/ngày | Tính từ ngày thả |
| **Cỡ cá tới 40g** | < 0.3%/ngày | - |
| **Cỡ cá 40g - 80g** | < 0.1%/ngày | - |
| **Cỡ cá 80g - 100g** | < 0.03%/ngày | - |
| **Cỡ cá trên 100g** | < 0.02%/ngày | - |
| **Tỉ lệ vô hình** | ≤ 10% | (Số thả - Thu hoạch - Cá chết) / Số thả × 100 |
| **Tổng tỷ lệ chết** | ≤ 15% | Suốt quá trình nuôi |

### **Quy tắc sử dụng thuốc dựa trên cá chết vượt ngưỡng**

**Khi cá chết vượt tỷ lệ quy định**:
- Đó là dấu hiệu cá bệnh (áp dụng cho giai đoạn cá < 100g)

**Trước khi sử dụng thuốc trị bệnh**:
- Chờ cá chết vượt quy định **2 ngày**
- Sau ngày cuối cùng sử dụng thuốc: **3-5 ngày** mới dừng

**Trước khi sử dụng thuốc trị ký sinh trùng**:
- Chờ cá chết vượt quy định **1 ngày**
- Sau ngày cuối cùng sử dụng thuốc: **1-2 ngày** mới dừng

---

## XIV. QUY TẮC CẤP THOÁT NƯỚC (quy tac cap thoat nuoc)

### **Lịch thay nước theo giai đoạn nuôi**

**Nguồn dữ liệu**: Lấy từ file "thong ke thong tin farms"

| Giai đoạn | Tần suất thay nước | Lượng nước | Ghi chú |
|-----------|-------------------|-----------|--------|
| **Tháng 1** (Từ lúc thả) | 2 lần/tháng | Mức 1 | Theo nhịp thay nước |
| **Tháng 2** | 3 lần/tháng | Mức 1 | Theo nhịp thay nước |
| **Tháng 3** | 4 lần/tháng | Mức 2 | Theo nhịp thay nước |
| **Tháng 4 trở đi** | 5-10 lần/tháng | Mức 2 hoặc 3 | Tùy tổng lượng nước cấp |
| **Thu hoạch** | - | Mức 4 | Ngày thu hoạch cuối |
| **Cấp lại vụ mới** | - | 1m nước | Ngay nhịp thay nước trước ngày sử dụng thuốc đầu tiên |

### **Quy tắc ao lắng**

- **Vùng có 2 ao lắng**: Xả thải khác ngày nhau
- **Trong tháng**: Đảm bảo có 2 đợt thải cùng ngày
- **Giới hạn xả thải**: Tổng lượng xả không vượt 10.000m³/ngày (vùng không có giấy phép xả thải)

### **Giới hạn cấp thoát nước**

| Loại | Giới hạn | Ghi chú |
|------|----------|--------|
| **Cấp nước ao nuôi** | ≤ 8.640 m³/ngày | Đảm bảo không vượt |
| **Khi sử dụng thuốc trị bệnh** | Không thay nước | Ngừng hoàn toàn |

---

## XV. LỊCH CÂN MẪU ĐỊNH KỲ (bac si ngu y)

### **Bác sĩ ngư y từ tháng 4/2025**

| Bác sĩ | Vùng nuôi | Ngày thẩm tra |
|--------|-----------|---------------|
| **Dư Hữu Trọng** | Bình Thạnh, Bình Thạnh 1, Bình Thạnh 2 | Ngày cuối tháng - 2 ngày |
| | Tân Khánh Trung, Mỹ Xương | Ngày cuối tháng - 1 ngày |
| | Tân Thuận Tây, Tân Thuận Đông, Tịnh Thới | Ngày cuối tháng |
| **Hồ Thanh Vinh** | Tân Hưng Khu 2 (ao 1-97) | Ngày cuối tháng - 1 ngày |
| | Mỹ Hiệp 1, Mỹ Hiệp 2 | Ngày cuối tháng |
| | Chợ Mới | Ngày cuối tháng |
| **Hồ Minh Luân** | Tân Hưng K1 (ao 1G - 39G) | Ngày cuối tháng - 2 ngày |
| | Tân Hòa | Ngày cuối tháng |
| | Tân Hồng | Ngày cuối tháng |
| | Tân Hồng 1 | Ngày cuối tháng - 1 ngày |
| | Vĩnh Hòa | Ngày cuối tháng - 1 ngày |

---

## XVI. BIÊN BẢN GIAO NHẬN THỨC ĂN (P301-F06)

### **Cấu trúc biên bản**

**Thông tin chung**:
- Ngày, tháng, năm giao nhận
- Vùng nuôi
- Tên ghe/tàu và mã số
- Danh sách người giao nhận (2 người)

**Bảng giao nhận thức ăn**:

| Cột | Nội dung | Ghi chú |
|-----|---------|--------|
| STT | Số thứ tự | (1) |
| Nhà sản xuất | Tên công ty sản xuất | (2) |
| Kích cỡ | Kích cỡ thức ăn | (3) |
| Quy cách | Quy cách đóng gói | (4) |
| ĐVT | Đơn vị tính | (5) |
| Số lượng | Lượng giao nhận | (6) |
| Ghi chú | Ghi chú khác | (7) |

**Tình trạng vệ sinh phương tiện**:

| Chỉ tiêu | Có | Không | Hành động khắc phục |
|---------|----|----|-------------------|
| Dầu nhớt vương vãi | ☐ | ☐ | - |
| Rác thải, rong rêu, bùn đất | ☐ | ☐ | - |
| Khô ráo | ☐ | ☐ | - |

**Địa điểm ghe/tàu 48 giờ trước**: Ghi rõ vị trí

**Tình trạng bao bì lúc giao nhận**:

| Tiêu chí | Có | Không |
|---------|----|----|
| Nguyên vẹn (Integrity) | ☐ | ☐ |
| Khô ráo (Dry) | ☐ | ☐ |
| Nấm mốc (Mould) | ☐ | ☐ |
| Sạch sẽ (Clean) | ☐ | ☐ |
| **Kết luận** | **Đạt** ☐ | **Không đạt** ☐ |

**Ký tên**:
- Người giao (Deliver): Ký tên, ghi rõ họ tên
- Người nhận (Receiver): Ký tên, ghi rõ họ tên

---

## XVII. SỔ THEO DÕI THỨC ĂN (P301-F07)

### **Thông tin trang đầu**

| Trường | Nội dung |
|--------|---------|
| **Kho/Storage** | Tên kho thức ăn |
| **Vùng nuôi/Farm** | Tên vùng nuôi |
| **Tên thức ăn/Feed name** | Tên loại thức ăn |
| **Đạm/Protein - ly/size** | Độ đạm và kích cỡ |
| **Đơn vị tính/Unit** | Kg |
| **Mã số/Code** | P301-F07 |
| **Ngày hiệu lực/Effective date** | 01.01.25 |
| **Lần soát xét/Version** | 03 |

### **Bảng theo dõi thức ăn**

| Cột | Nội dung | Ghi chú |
|-----|---------|--------|
| **Ngày (Date)** | Ngày ghi nhận | - |
| **Lượng nhập (Input quantity)** | Số kg nhập vào | - |
| **MSL nhập (Input batch code)** | Mã số lô nhập | - |
| **HSD nhập (Input Expiry date)** | Hạn sử dụng nhập | - |
| **MSL cho ăn (Feed batch code)** | Mã số lô cho ăn | - |
| **HSD cho ăn (Feed expiry date)** | Hạn sử dụng cho ăn | - |
| **Xuất (Output)** | Lượng xuất | Có 2 cột: Lượng (Quantity) & Ao (Pond) |
| **Tồn cuối (Inventory)** | Lượng tồn cuối kỳ | - |
| **Tình trạng thức ăn (Feed condition)** | Đạt/Không đạt | Có 2 cột: Đạt (Ok) & Không đạt (Not ok) |
| **Ghi chú (Note)** | Ghi chú bổ sung | - |

### **Tiêu chí đánh giá tình trạng thức ăn**

**Thức ăn đạt khi**:
- Thức ăn khô ráo (Dry)
- Không nấm mốc (No mould)

### **Chữ ký và ngày tháng**

- **Ngày/Date**: Ngày ghi sổ
- **Người giám sát/Supervisor**: Ký tên người giám sát
- **Người theo dõi/Followers**: Ký tên người theo dõi

---

## XVIII. PHIẾU GIAO HÀNG HÓA CHẤT (P303-F03)

### **Thông tin chung**

- **Mã số**: P303-F03
- **Ngày hiệu lực**: 01.01.25
- **Lần soát xét**: Version 03

### **Nội dung phiếu**

**Thông tin giao hàng**:
- Khách hàng/Supplier
- Địa chỉ/Address

**Bảng giao hàng hóa chất**:

| Cột | Nội dung |
|-----|---------|
| STT (No.) | Số thứ tự |
| Tên hàng (Name of goods) | Tên hóa chất |
| Quy cách (Packing) | Quy cách đóng gói |
| ĐVT (Unit) | Đơn vị tính |
| Số lượng (Quantity) | Lượng giao nhận |
| NSX/HSD (Production date/expiry date) | Ngày sản xuất/Hạn sử dụng |
| Nhà sản xuất (Product) | Tên công ty sản xuất |
| Ghi chú (Note) | Ghi chú bổ sung |

**Địa điểm phương tiện 48h trước**: Ghi rõ vị trí

**Tình trạng bao bì lúc giao nhận**:
- Nguyên vẹn (Integrity): Có/Không
- Khô ráo (Dry): Có/Không
- Sạch sẽ (Clean): Có/Không

**Ký tên**:
- Người lập bảng (Created by): Ngày + Ký tên
- Người nhận (Receiver): Ngày + Ký tên

---

## XIX. SỔ THEO DÕI HÓA CHẤT (P303-F04)

### **Thông tin trang đầu**

| Trường | Nội dung |
|--------|---------|
| **Tên sản phẩm/Product name** | Tên hóa chất |
| **Quy cách/Packing** | Quy cách đóng gói |
| **Công ty sản xuất/Production company** | Tên công ty |
| **Vùng nuôi/Farm** | Tên vùng nuôi |
| **Đơn vị tính/Unit** | Đơn vị (kg, lít, ...) |
| **Mã số/Code** | P303-F04 |
| **Ngày hiệu lực/Effective date** | 01.01.25 |
| **Lần soát xét/Version** | 03 |

### **Bảng theo dõi hóa chất**

| Cột | Nội dung |
|-----|---------|
| **Ngày (Date)** | Ngày ghi nhận |
| **Lượng nhập (Input Quantity)** | Số kg/lít nhập vào |
| **MSL/HSD nhập (Input batch code/expiry date)** | Mã lô và hạn sử dụng nhập |
| **Xuất (Output)** | Lượng xuất (Quantity & Ao/Pond) |
| **MSL/HSD xuất (Output batch code/expiry date)** | Mã lô và hạn sử dụng xuất |
| **Tồn cuối (Inventory)** | Lượng tồn cuối kỳ |
| **Tình trạng sản phẩm (Product situation)** | Đạt/Không đạt |
| **Ghi chú (Note)** | Ghi chú bổ sung |

### **Tiêu chí đánh giá tình trạng sản phẩm**

**Hóa chất đạt khi**:
- Nguyên vẹn (Integrity)
- Khô ráo (Dry)
- Sạch sẽ (Clean)

**Chú thích**: MSL = Mã số lô (Batch code); HSD = Hạn sử dụng (Expiry date)

**Ký tên**:
- Ngày/Date
- Người giám sát/Supervisor
- Người theo dõi/Followers

---

## XX. PHIẾU CHỈ ĐỊNH SỬ DỤNG SẢN PHẨM (P303-F06)

### **Thông tin chung**

- **Mã số**: P303-F06
- **Ngày hiệu lực**: 01.01.25
- **Lần soát xét**: Version 03

### **Nội dung phiếu**

**Thông tin người đề nghị**:
- Ngày/Date
- Tôi tên/Name
- Chức vụ/Position
- Trại/Vùng nuôi/Farm
- Đề nghị/Proposal

**Bảng chi tiết sử dụng sản phẩm**:

| Cột | Nội dung |
|-----|---------|
| STT (No) | Số thứ tự |
| Ao (Pond) | Mã ao nuôi |
| Tên sản phẩm (Name of product) | Tên hóa chất/thức ăn |
| Đơn vị tính (Unit) | Đơn vị (kg, lít, ...) |
| Lượng sử dụng (Quantity) | Lượng sử dụng |
| Lý do sử dụng (The reason of use) | Lý do sử dụng |
| Ghi chú (Note) | Ghi chú bổ sung |

**Ký tên**:
- Người đề nghị (Proposed by)
- Quản lý (Managed by)

---

## XXI. PHIẾU THEO DÕI SỨC KHỎE CÁ NUÔI (P303-F07)

### **Thông tin chung**

- **Mã số**: P303-F07
- **Ngày hiệu lực**: 01.01.25
- **Lần soát xét**: Version 03

### **Nội dung phiếu**

**Thông tin chung**:
- Ngày/Date
- Vùng nuôi/Farm
- Cán bộ ngư y/Fishery staff

**Bảng theo dõi sức khỏe cá**:

| Cột | Nội dung |
|-----|---------|
| Ao (Pond) | Mã ao nuôi |
| TLBQ (kg/con) (average weight) | Trọng lượng bình quân |
| Số cá chết (con) (Dead fish pieces) | Số lượng cá chết |
| Ký sinh trùng (Parasites) | Tình trạng ký sinh trùng |
| Dấu hiệu lâm sàng (Clinical signs) | Các dấu hiệu bệnh |
| Hướng xử lý (Solution) | Biện pháp xử lý |

---

## XXII. KIỂM TRA LƯỢNG NƯỚC CẤP - THOÁT AO NUÔI (P304-F04)

### **Thông tin chung**

- **Mã số**: P304-F04
- **Ngày hiệu lực**: 01.01.25
- **Lần soát xét**: Version 03

### **Nội dung phiếu**

**Thông tin**:
- Vùng nuôi/Farm
- Ngày/Date
- Người thẩm tra/Inspector

**Bảng theo dõi lượng nước**:

| Cột | Nội dung |
|-----|---------|
| Ngày (Date) | Ngày ghi nhận |
| Ao (Pond) | Mã ao nuôi |
| Cấp (Intake) | Lượng nước cấp |
| Thoát (Drainage) | Lượng nước thoát |
| Tổng lượng nước cấp (Total intake water volume) | Tổng cộng |
| Tổng lượng nước thoát (Total drainage water volume) | Tổng cộng |
| Người thực hiện (Performer) | Tên người thực hiện |

---

## XXIII. KẾT QUẢ THEO DÕI NƯỚC THẢI (P304-F07)

### **Thông tin chung**

- **Mã số**: P304-F07
- **Ngày hiệu lực**: 01.01.25
- **Lần soát xét**: Version 03

### **Nội dung phiếu**

**Thông tin**:
- Vùng nuôi/Farm
- Ngày/Date
- Người thẩm tra/Inspector

**Bảng theo dõi nước thải**:

| Cột | Nội dung |
|-----|---------|
| Thời gian thoát (Time of discharge) | Thời gian xả thải |
| Lượng nước thoát (Waste-water volume m³) | Lượng nước thải |
| Thời gian cấp (Intake time) | Thời gian cấp nước |
| Lượng nước cấp (Amount of intake water m³) | Lượng nước cấp |
| **Chỉ tiêu nước thoát (Wastewater criteria)** | - |
| DO (mg/l) | Trước khi thoát / Đang thoát |
| pH | Trước khi thoát / Đang thoát |
| Mùi, cảm quan (Smell, sensory) | Trước khi thoát / Đang thoát |
| Người thực hiện (Performer) | Tên người thực hiện |
| Kết luận (Conclusion) | Đạt / Không đạt |

---

## XXIV. SỔ GIAO NHẬN CHẤT THẢI (P305-F37)

### **Thông tin chung**

- **Mã số**: P305-F37
- **Ngày hiệu lực**: 01.01.25
- **Lần soát xét**: Version 03

### **Nội dung phiếu**

**Thông tin**:
- Vùng nuôi/Farm

**Bảng giao nhận chất thải**:

| Cột | Nội dung |
|-----|---------|
| Ngày (Date) | Ngày ghi nhận |
| Loại chất thải (Type of waste) | Loại chất thải (cá chết, thức ăn thừa, ...) |
| Đơn vị tính (Unit) | Đơn vị (kg, bao, ...) |
| Số lượng (Quantity kg) | Lượng chất thải |
| Người giao (Deliver) | Tên người giao |
| Người nhận (Receiver) | Tên người nhận |

**Ký tên**:
- Ngày/Date (2 lần)
- Người giao/Deliver
- Người nhận/Receiver

---

**Tài liệu được tạo từ file**: `QLCLN_part_1.json`, `QLCLN_part_2.json`, `QLCLN_part_3.json`, `QLCLN_part_4.json` & `QLCLN_part_5.json`
**Ngày tạo**: 14/11/2025
**Trạng thái**: ✅ Hoàn tất - Tất cả 5 file JSON đã được xử lý
