-- lab11_ bai3
-- cau a
CREATE PROCEDURE sp_ThemHangSX 
    @MaHangSX NCHAR(10),
    @TenHang NVARCHAR(20),
    @DiaChi NVARCHAR(30),
    @SoDT NVARCHAR(20),
    @Email NVARCHAR(30)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang)
    BEGIN
        INSERT INTO HangSX VALUES (@MaHangSX, @TenHang, @DiaChi, @SoDT, @Email)
        PRINT 'Đã thêm thành công!'
    END
    ELSE
        PRINT 'Tên hãng sản xuất này đã tồn tại. Vui lòng kiểm tra lại!'
END
EXEC sp_ThemHangSX 'H04', 'Apple', 'USA', '0123456789', 'apple@gmail.com'

-- cau b
CREATE PROCEDURE spNhapSanPham
(
    @MaSP INT,
    @TenHangSX NVARCHAR(50),
    @TenSP NVARCHAR(50),
    @SoLuong INT,
    @MauSac NVARCHAR(20),
    @GiaBan MONEY,
    @DonViTinh NVARCHAR(10),
    @MoTa NVARCHAR(MAX)
)
AS
BEGIN
    -- Kiểm tra nếu sản phẩm đã tồn tại thì cập nhật, ngược lại thêm mới
    IF EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        UPDATE SanPham
        SET TenHangSX = @TenHangSX,
            TenSP = @TenSP,
            SoLuong = @SoLuong,
            MauSac = @MauSac,
            GiaBan = @GiaBan,
            DonViTinh = @DonViTinh,
            MoTa = @MoTa
        WHERE MaSP = @MaSP
    END
    ELSE
    BEGIN
        INSERT INTO SanPham (MaSP, TenHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
        VALUES (@MaSP, @TenHangSX, @TenSP, @SoLuong, @MauSac, @GiaBan, @DonViTinh, @MoTa)
    END
END
-- cau c
CREATE PROCEDURE XoaHangSX
    @TenHang nvarchar(50)
AS
BEGIN
    -- Kiểm tra xem TenHang có tồn tại trong bảng HangSX không
    IF NOT EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang)
    BEGIN
        PRINT 'Không tìm thấy hãng sản xuất ' + @TenHang
        RETURN
    END
    
    -- Xóa các sản phẩm cung cấp bởi hãng sản xuất
    DELETE FROM SanPham WHERE MaHangSX IN (SELECT MaHangSX FROM HangSX WHERE TenHang = @TenHang)

    -- Xóa hãng sản xuất
    DELETE FROM HangSX WHERE TenHang = @TenHang

    PRINT 'Đã xóa hãng sản xuất ' + @TenHang + ' và các sản phẩm liên quan.'
END
-- cau d
CREATE PROCEDURE sp_NhapLieuNhanVien
    @manv INT,
    @TenNV NVARCHAR(50),
    @GioiTinh NVARCHAR(5),
    @DiaChi NVARCHAR(100),
    @SoDT NVARCHAR(20),
    @Email NVARCHAR(50),
    @Phong NVARCHAR(50),
    @Flag BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF(@Flag = 0) -- cập nhật thông tin nhân viên theo mã
    BEGIN
        UPDATE NhanVien
        SET TenNV = @TenNV,
            GioiTinh = @GioiTinh,
            DiaChi = @DiaChi,
            SoDT = @SoDT,
            Email = @Email,
            Phong = @Phong
        WHERE manv = @manv
    END
    ELSE -- thêm mới nhân viên
    BEGIN
        INSERT INTO NhanVien(manv, TenNV, GioiTinh, DiaChi, SoDT, Email, Phong)
        VALUES (@manv, @TenNV, @GioiTinh, @DiaChi, @SoDT, @Email, @Phong)
    END
END
-- cau e
CREATE PROCEDURE NhapHang
    @SoHDN int,
    @MaSP varchar(10),
    @manv varchar(10),
    @NgayNhap date,
    @SoLuongN int,
    @DonGiaN decimal(18,2)
AS
BEGIN
    -- Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không
    IF NOT EXISTS(SELECT * FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại trong bảng SanPham'
        RETURN
    END
    
    -- Kiểm tra xem manv có tồn tại trong bảng NhanVien hay không
    IF NOT EXISTS(SELECT * FROM NhanVien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng NhanVien'
        RETURN
    END
    
    -- Kiểm tra xem SoHDN đã tồn tại trong bảng Nhap hay chưa
    IF EXISTS(SELECT * FROM Nhap WHERE SoHDN = @SoHDN)
    BEGIN
        -- Nếu SoHDN đã tồn tại thì cập nhật bảng Nhap theo SOHDN
        UPDATE Nhap
        SET MaSP = @MaSP,
            manv = @manv,
            NgayNhap = @NgayNhap,
            SoLuongN = @SoLuongN,
            DonGiaN = @DonGiaN
        WHERE SoHDN = @SoHDN
        PRINT 'Đã cập nhật bảng Nhap thành công'
    END
    ELSE
    BEGIN
        -- Ngược lại thêm mới bảng Nhap
        INSERT INTO Nhap(SoHDN, MaSP, manv, NgayNhap, SoLuongN, DonGiaN)
        VALUES(@SoHDN, @MaSP, @manv, @NgayNhap, @SoLuongN, @DonGiaN)
        PRINT 'Đã thêm mới bảng Nhap thành công'
    END
END
-- cau f
CREATE PROCEDURE ThemXuat @SoHDX INT, @MaSP INT, @manv INT, @NgayXuat DATE, @SoLuongX INT
AS
BEGIN
    -- Kiểm tra MaSP có tồn tại trong bảng SanPham hay không
    IF NOT EXISTS(SELECT 1 FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        PRINT 'MaSP khong ton tai trong bang SanPham'
        RETURN
    END
    
    -- Kiểm tra manv có tồn tại trong bảng NhanVien hay không
    IF NOT EXISTS(SELECT 1 FROM NhanVien WHERE manv = @manv)
    BEGIN
        PRINT 'manv khong ton tai trong bang NhanVien'
        RETURN
    END
    
    -- Kiểm tra SoLuongX <= SoLuong trong bảng SanPham
    IF @SoLuongX > (SELECT SoLuong FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        PRINT 'SoLuongX lon hon SoLuong trong bang SanPham'
        RETURN
    END
    
    -- Kiểm tra nếu SoHDX đã tồn tại thì cập nhật bảng Xuat theo SoHDX, ngược lại thêm mới bảng Xuat
    IF EXISTS(SELECT 1 FROM Xuat WHERE SoHDX = @SoHDX)
    BEGIN
        UPDATE Xuat
        SET MaSP = @MaSP, manv = @manv, NgayXuat = @NgayXuat, SoLuongX = @SoLuongX
        WHERE SoHDX = @SoHDX
        PRINT 'Da cap nhat thanh cong bang Xuat'
    END
    ELSE
    BEGIN
        INSERT INTO Xuat(SoHDX, MaSP, manv, NgayXuat, SoLuongX)
        VALUES (@SoHDX, @MaSP, @manv, @NgayXuat, @SoLuongX)
        PRINT 'Da them moi thanh cong bang Xuat'
    END
END
-- cau g
CREATE PROCEDURE DeleteNhanVien @manv varchar(10)
AS
BEGIN
    -- Kiểm tra xem nhân viên có tồn tại trong bảng NhanVien hay không
    IF NOT EXISTS(SELECT * FROM NhanVien WHERE manv = @manv)
    BEGIN
        PRINT 'Không tìm thấy nhân viên có mã ' + @manv + ' trong bảng NhanVien'
        RETURN
    END

    BEGIN TRANSACTION -- Bắt đầu giao dịch

    -- Xóa các bản ghi có liên quan đến nhân viên này trong bảng Nhap
    DELETE FROM Nhap WHERE manv = @manv

    -- Xóa các bản ghi có liên quan đến nhân viên này trong bảng Xuat
    DELETE FROM Xuat WHERE manv = @manv

    -- Xóa nhân viên khỏi bảng NhanVien
    DELETE FROM NhanVien WHERE manv = @manv

    COMMIT -- Kết thúc giao dịch

    PRINT 'Đã xóa nhân viên có mã ' + @manv + ' thành công'
END
-- cau h
CREATE PROCEDURE XoaSanPham (@MaSP VARCHAR(10))
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại trong bảng SanPham hay không
    IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong bảng SanPham.'
        RETURN
    END
    
    -- Xóa bản ghi trong bảng Nhap liên quan đến sản phẩm
    DELETE FROM Nhap WHERE MaSP = @MaSP
    
    -- Xóa bản ghi trong bảng Xuat liên quan đến sản phẩm
    DELETE FROM Xuat WHERE MaSP = @MaSP
    
    -- Xóa bản ghi trong bảng SanPham
    DELETE FROM SanPham WHERE MaSP = @MaSP
    
    PRINT 'Xóa sản phẩm thành công.'
END
