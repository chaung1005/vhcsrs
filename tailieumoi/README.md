# QLCLN – Windows Forms + SQL Server (Database-First)

**Ngày tạo:** 2025-11-14

Bộ tài liệu & code khởi tạo dự án QLCLN cho ứng dụng **Windows Forms** sử dụng **SQL Server** với quy trình **Database-First**.

## Thư mục
- `Docs/` – Tài liệu yêu cầu, kiến trúc, kế hoạch triển khai, kiểm thử, triển khai.
- `DB/` – Script SQL tạo CSDL, SP/Views/Trigger, seed.
- `Code/WinForms/` – Mã nguồn WinForms (.NET 8 + EF Core 8) và cấu hình.

## Lưu ý quan trọng
- Đây là **bộ khung** hoàn chỉnh để khởi động. Bạn có thể mở bằng Visual Studio 2022/2025 hoặc `dotnet` CLI.
- Quy trình **Database-First**: chạy script trong `DB/` → Scaffold EF Core → mở project WinForms → build & chạy.
