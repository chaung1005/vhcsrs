# Hướng Dẫn Sử Dụng Form FSIS Reports

## 🎯 Mục Đích

Form **FSIS Reports** được sử dụng để xem và xuất báo cáo tuân thủ an toàn thực phẩm (FSIS) cho các vòng nuôi tôm/cá.

## 📋 Quy Trình Sử Dụng

### Bước 1: Mở Form FSIS Reports
- Chương trình sẽ tự động tải danh sách loại báo cáo, ao nuôi

### Bước 2: Chọn Loại Báo Cáo

Bạn có 8 loại báo cáo để lựa chọn:

| Mã | Tên Báo Cáo | Mô Tả |
|---|---|---|
| P301-F01 | Nhật ký nuôi | Ghi chép hàng ngày: nhiệt độ, pH, cấp oxy, số lượng cá... |
| P301-F06 | Biên bản giao nhận thức ăn | Ghi chép các lần nhập thức ăn |
| P301-F07 | Sổ theo dõi thức ăn | Chi tiết nhập/xuất/tồn thức ăn |
| P303-F03 | Phiếu giao hàng hóa chất | Ghi chép các lần nhập hóa chất |
| P303-F04 | Sổ theo dõi hóa chất | Chi tiết nhập/xuất/tồn hóa chất |
| P303-F06 | Phiếu chỉ định sản phẩm | Thông tin chung về vòng nuôi |
| P303-F07 | Phiếu theo dõi sức khỏe | Ghi chép sức khỏe cá, ký sinh trùng... |
| P305-F37 | Sổ giao nhận chất thải | Ghi chép xử lý chất thải |

**Cách làm:** Click vào combo "Loại báo cáo" rồi chọn loại báo cáo muốn xem

### Bước 3: Chọn Ao Nuôi

- Combo "Ao nuôi" hiển thị danh sách tất cả các ao hoạt động
- Format: `[Mã Ao] - [Tên Ao]` (ví dụ: `P001 - Ao nuôi 1`)
- **Lưu ý**: Khi bạn chọn ao, form sẽ tự động tải danh sách vòng nuôi cho ao đó

### Bước 4: Chọn Vòng Nuôi

- Combo "Vòng nuôi" sẽ hiển thị danh sách vòng nuôi cho ao bạn đã chọn
- Format: `[Mã Vòng] - [Tên Vòng] ([Trạng Thái])`
- **Lưu ý**: Vòng nuôi được sắp xếp từ mới nhất đến cũ nhất

### Bước 5: [Tùy Chọn] Lọc Theo Khoảng Ngày

Nếu bạn chỉ muốn xem dữ liệu trong một khoảng thời gian nhất định:

1. Tích checkbox "Lọc theo ngày"
2. Chọn **Ngày bắt đầu** (từ ngày nào)
3. Chọn **Ngày kết thúc** (đến ngày nào)

**Nếu không tích**, tất cả dữ liệu sẽ được hiển thị.

### Bước 6: Bấm Nút "Xem Dữ Liệu"

- Nút có màu xanh dương
- Khi bấm, form sẽ tải dữ liệu từ database
- Bạn sẽ thấy một thanh tiến độ (progress bar) khi đang tải
- **Chờ cho đến khi dữ liệu xuất hiện** trong bảng ở dưới

### Bước 7: Xem Dữ Liệu Trong Bảng

Dữ liệu sẽ được hiển thị trong bảng (DataGridView) với:
- **Các cột** tương ứng với loại báo cáo bạn chọn
- **Các hàng** chứa dữ liệu chi tiết
- **Có thể cuộn** trái phải, lên xuống để xem toàn bộ dữ liệu

### Bước 8: [Tùy Chọn] Xuất Dữ Liệu Ra Excel

Nếu bạn muốn lưu dữ liệu ra file Excel để sử dụng ngoài:

1. Bấm nút **"Xuất Excel"** (có màu xanh lá)
2. Một hộp thoại sẽ hiển thị để bạn chọn nơi lưu file
3. Tên file mặc định: `FSIS_Report_[Ngày Giờ].xlsx`
4. Chọn **"Lưu"** (Save)
5. File Excel sẽ được tạo với:
   - Header (tiêu đề cột) có background màu xám
   - Dữ liệu được format tự động
   - Các cột tự động vừa nội dung

**Chú ý**: 
- Nếu không có dữ liệu để xuất, nút này sẽ bị tắt (disable)
- File được lưu ở dạng Excel (.xlsx)
- Nếu máy không có Excel, bạn vẫn có thể mở bằng Google Sheets, LibreOffice...

### Bước 9: [Tùy Chọn] Xóa Dữ Liệu

Nếu muốn xóa dữ liệu hiện tại và bắt đầu lại:
- Bấm nút **"Xóa Dữ Liệu"** (có màu xám)
- Bảng sẽ trống
- Các combo box vẫn giữ lựa chọn trước đó

### Bước 10: Đóng Form

- Bấm nút **"Đóng"** hoặc **X** góc trên phải
- Quay lại màn hình chính

## 💡 Ví Dụ Thực Tế

### Ví Dụ 1: Xem Nhật Ký Nuôi

1. **Loại báo cáo**: Chọn `P301-F01 - Nhật ký nuôi`
2. **Ao nuôi**: Chọn `P001 - Ao nuôi 1`
3. **Vòng nuôi**: Chọn `C202401 - Vòng nuôi tháng 1/2024`
4. **Lọc theo ngày**: Tích, chọn từ 01/01/2024 đến 31/01/2024
5. **Xem dữ liệu** → Thấy dữ liệu nhật ký: ngày, nhiệt độ, pH, cấp oxy, số lượng cá...

### Ví Dụ 2: Xuất Báo Cáo Thức Ăn

1. **Loại báo cáo**: Chọn `P301-F07 - Sổ theo dõi thức ăn`
2. **Ao nuôi**: Chọn `P002 - Ao nuôi 2`
3. **Vòng nuôi**: Chọn `C202312 - Vòng nuôi tháng 12/2023`
4. **Xem dữ liệu** → Thấy dữ liệu: ngày, tên thức ăn, nhập/xuất, tồn...
5. **Xuất Excel** → Lưu file `FSIS_Report_20240110_143022.xlsx`
6. Mở file trong Excel để in hoặc sử dụng tiếp

## ⚠️ Lưu Ý Quan Trọng

### Khi Nào Nên Sử Dụng Form Này?

- ✅ Khi cần **xem báo cáo FSIS** cho một vòng nuôi cụ thể
- ✅ Khi cần **xuất dữ liệu ra Excel** để in hoặc gửi cho cơ quan
- ✅ Khi cần **kiểm tra lịch sử** nhập xuất, ghi chép sức khỏe...
- ❌ KHÔNG dùng để **nhập dữ liệu mới** (dùng các form khác như "Nhật ký nuôi", "Giao nhận thức ăn"...)

### Gặp Lỗi Gì Thì Làm?

| Lỗi | Cách Xử Lý |
|---|---|
| "Không có dữ liệu" | Kiểm tra xem ao/vòng nuôi đó có dữ liệu không |
| Form không load danh sách ao | Kiểm tra kết nối database, chờ và reload form |
| Nút "Xuất Excel" bị tắt | Bấn "Xem Dữ Liệu" trước, sau đó mới xuất |
| File Excel không mở được | Cập nhật Excel hoặc dùng Google Sheets, LibreOffice |

## 🔧 Tính Năng Bổ Sung

### Status Bar (Thanh Trạng Thái)

Ở dưới cùng form, có một thanh hiển thị trạng thái hiện tại:
- "Sẵn sàng" - Form đã sẵn sàng để dùng
- "Đang tải danh sách ao..." - Đang tải dữ liệu
- "Hoàn thành! Đã tải 25 dòng dữ liệu." - Tải xong

### Progress Bar (Thanh Tiến Độ)

Khi bấm "Xem Dữ Liệu", thanh tiến độ sẽ hiển thị:
- Cho biết form đang tải dữ liệu
- **Đợi cho đến khi nó biến mất** (chứa tính năng "Cancel")

### Date Picker (Chọn Ngày)

- Click vào ô ngày để mở calendar
- Chọn ngày muốn bắt đầu/kết thúc
- Hoặc gõ trực tiếp theo format: `DD/MM/YYYY`

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra lại các bước trên
2. Xem phần "Gặp Lỗi Gì Thì Làm"
3. Liên hệ với quản trị viên hệ thống

---

**Phiên Bản**: 1.0  
**Cập Nhật**: 11/11/2024  
**Ngôn Ngữ**: Tiếng Việt

