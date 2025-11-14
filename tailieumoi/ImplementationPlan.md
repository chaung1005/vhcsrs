# Kế hoạch & các giai đoạn triển khai

## Giai đoạn 0 – Khởi động (0.5 tuần)
- Chuẩn hoá yêu cầu, đối chiếu biểu mẫu & quy tắc.
- Khoá phạm vi và thiết kế database logic.

## Giai đoạn 1 – Thiết kế & triển khai CSDL (1.5–2 tuần)
- Thiết kế ERD, chuẩn hoá bảng, khoá ngoại, chỉ mục.
- Viết script `QLCLN_Schema.sql`, `Views_SP.sql`, `Seed_ReferenceData.sql`.
- Kiểm thử tính toàn vẹn & chỉ số.

## Giai đoạn 2 – Sinh model EF (0.5 tuần)
- Scaffold EF Core Database-First.
- Ràng buộc DI, Repository pattern.

## Giai đoạn 3 – Chức năng lõi (2–3 tuần)
- Nhật ký ao (P301-F01), kho TA (P301-F07), kho HC (P303-F04).
- Giao nhận TA (P301-F06), giao nhận HC (P303-F03).
- Phiếu chỉ định (P303-F06), Sức khoẻ cá (P303-F07).
- Cấp/thoát nước (P304-F04), Nước thải (P304-F07), Chất thải (P305-F37).

## Giai đoạn 4 – Cảnh báo & báo cáo (1–2 tuần)
- Cảnh báo mật độ, HSD, cá chết vượt ngưỡng, giới hạn cấp/xả, sức chứa kho.
- Báo cáo tăng trưởng & mật độ, tồn kho, giao nhận, sử dụng sản phẩm.

## Giai đoạn 5 – Kiểm thử & triển khai (1–2 tuần)
- Test chức năng & nghiệp vụ, UAT.
- Đóng gói cài đặt, hướng dẫn vận hành & backup.

> Tổng thời lượng dự kiến: 6–9 tuần tùy quy mô & nguồn lực.
