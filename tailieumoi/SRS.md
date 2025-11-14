# SRS – Đặc tả yêu cầu hệ thống QLCLN

## 1. Mục tiêu
Xây dựng phần mềm quản lý chất lượng lâm nghiệp (QLCLN) cho hoạt động nuôi cá (nhật ký, tồn kho thức ăn/hóa chất, giao nhận, theo dõi sức khỏe cá, cấp/thoát nước, chất thải, cảnh báo và báo cáo tổng hợp).

## 2. Phạm vi & mô-đun chính
- **Nhật ký nuôi (P301-F01)** – thông tin ao/vụ, nhập chỉ số môi trường, thức ăn, hóa chất, cá chết, ghi chú, người phụ trách.
- **Báo cáo tốc độ tăng trưởng & mật độ toàn vùng/ngày bất kỳ**.
- **Kho thức ăn (P301-F07)** – nhập/xuất tồn, MSL/HSD, cảnh báo HSD và quy tắc nhập.
- **Kho hóa chất (P303-F04)** – nhập/xuất tồn, HSD, cảnh báo vượt 90% sức chứa (cho hàng lỏng).
- **Biên bản giao nhận thức ăn (P301-F06)** và **hóa chất (P303-F03)** – thông tin ghe, người giao/nhận, kiểm tra bao bì & vệ sinh phương tiện, địa điểm 48h trước.
- **Phiếu chỉ định sử dụng sản phẩm (P303-F06)** – đề nghị và chi tiết sử dụng theo ao.
- **Phiếu theo dõi sức khỏe cá nuôi (P303-F07)** – TLBQ, cá chết, ký sinh trùng, dấu hiệu, hướng xử lý.
- **Kiểm tra lượng nước cấp/thoát (P304-F04)** và **Kết quả theo dõi nước thải (P304-F07)** – theo dõi tổng lượng cấp/thoát, chỉ tiêu DO/pH & kết luận.
- **Sổ giao nhận chất thải (P305-F37)** – tổng hợp cá chết/thức ăn/thải loại theo ngày.
- **Danh mục tham chiếu**: vùng nuôi, ao, nhà sản xuất, MTP (thức ăn), danh mục hóa chất, ghe vận chuyển, bác sĩ ngư y, quy tắc môi trường/cá chết, giới hạn cấp/thoát nước, sức chứa kho.

## 3. Đối tượng sử dụng & phân quyền
- **Kho**: quản lý nhập/xuất tồn TA/HC, lập biên bản giao nhận.
- **Kỹ thuật viên/Ngư y**: nhật ký ao, theo dõi sức khỏe, đề nghị sử dụng sản phẩm, đo nước thải.
- **Quản lý vùng**: phê duyệt, xem báo cáo, thay đổi giới hạn cấp/xả (khi có giấy phép), cài đặt nhịp thay nước.
- **Admin**: cấu hình danh mục, tài khoản, tham số hệ thống.

## 4. Quy tắc nghiệp vụ (tóm lược)
- Cảnh báo **mật độ** > 37 kg/m²; tính mật độ = (Số lượng cá × TLBQ) / Diện tích mặt nước.
- Tính **HSD thức ăn** từ **MSL** theo quy tắc nội bộ; cảnh báo hết HSD hoặc ngày nhập < NSX.
- **Hóa chất lỏng**: cảnh báo > 90% sức chứa kho.
- **Trong dùng thuốc trị bệnh**: không được thay nước.
- **Báo cáo tăng trưởng & mật độ**: cho ngày bất kỳ, toàn bộ ao vùng.
- **Quy tắc cá chết** theo giai đoạn & kích cỡ; kích hoạt quy trình trị bệnh/ký sinh trùng khi vượt ngưỡng.
- **Giới hạn cấp/xả** theo vùng và giấy phép hiện hành.

> Các quy tắc và biểu mẫu đối chiếu từ tài liệu yêu cầu chi tiết (I–XXIV).

## 5. Yêu cầu phi chức năng
- Ứng dụng desktop Windows Forms, hỗ trợ offline cục bộ với SQL Server trên LAN.
- Nhật ký hành động (audit), logging lỗi, phân quyền cơ bản, sao lưu/khôi phục CSDL.
- Hiệu năng: truy vấn báo cáo ngày trong < 3s với 100 ao, 2 năm dữ liệu.

## 6. Ràng buộc công nghệ
- **Windows Forms** (.NET 8 LTS), **SQL Server 2019+**, **EF Core 8** (Database-First).
- Báo cáo: RDLC hoặc xuất Excel/CSV.
