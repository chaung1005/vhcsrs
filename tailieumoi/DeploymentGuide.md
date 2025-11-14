# Hướng dẫn triển khai

## Môi trường
- Windows 10/11, .NET 8 SDK, SQL Server 2019/2022, Visual Studio 2022/2025.

## Các bước
1. Tạo DB & login trên SQL Server.
2. Chạy `DB/QLCLN_Schema.sql` → `DB/Seed_ReferenceData.sql`.
3. Chỉnh `Code/WinForms/appsettings.json` (ConnectionStrings).
4. Mở `Code/WinForms/QLCLN.WinForms.csproj` trong VS → `dotnet restore`.
5. Scaffold EF (xem `Docs/Scaffold_EF.txt`).
6. Run ứng dụng; tạo user & phân quyền (nếu có).

## Sao lưu/khôi phục
- Sử dụng backup full + diff + log theo lịch; kiểm thử restore định kỳ.
