--cau1---
CREATE PROCEDURE sp_insert_employee
    @manv INT,
    @tennv NVARCHAR(50),
    @sodt VARCHAR(20),
    @email VARCHAR(50),
    @phong NVARCHAR(50),
    @gioitinh NVARCHAR(3),
    @flag INT,
    @error_code INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF (@flag = 0) -- Thêm mới nhân viên
    BEGIN
        IF (@gioitinh NOT IN ('Nam', 'Nữ'))
        BEGIN
            SET @error_code = 1; -- Mã lỗi 1: Giới tính không hợp lệ
            RETURN;
        END

        INSERT INTO Nhanvien(manv, tennv, sodt, email, phong, gioitinh)
        VALUES (@manv, @tennv, @sodt, @email, @phong, @gioitinh);

        SET @error_code = 0; -- Không có lỗi
    END
    ELSE -- Cập nhật thông tin nhân viên theo mã
    BEGIN
        IF (@gioitinh NOT IN ('Nam', 'Nữ'))
        BEGIN
            SET @error_code = 1; -- Mã lỗi 1: Giới tính không hợp lệ
            RETURN;
        END

        UPDATE Nhanvien
        SET tennv = @tennv, sodt = @sodt, email = @email,
            phong = @phong, gioitinh = @gioitinh
        WHERE manv = @manv;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @error_code = 2; -- Mã lỗi 2: Không tìm thấy nhân viên cần cập nhật
            RETURN;
        END

        SET @error_code = 0; -- Không có lỗi
    END
END
DECLARE @error_code INT;
EXEC sp_insert_employee 678, 'Nguyen Van A', '0123456789', 'nguyenvana@gmail.com', 'Phong A', 'Nam', 0, @error_code OUTPUT;
-- cau 2--
CREATE PROCEDURE sp_ThemCapNhatSanPham
    @masp NVARCHAR(50),
    @tenhang NVARCHAR(50),
    @tensp NVARCHAR(50),
    @soluong INT,
    @mausac NVARCHAR(20),
    @giaban FLOAT,
    @donvitinh NVARCHAR(10),
    @mota NVARCHAR(MAX),
    @flag INT
AS
BEGIN
    DECLARE @mahangsx NVARCHAR(50)

    -- Kiểm tra xem tenhang có tồn tại trong bảng hangsx hay không
    SELECT @mahangsx = mahangsx FROM hangsx WHERE tenhang = @tenhang
    IF @mahangsx IS NULL
    BEGIN
        -- Trả về mã lỗi 1 nếu tenhang không tồn tại trong bảng hangsx
        SELECT 1 AS [ErrorCode], 'Ten hang khong ton tai' AS [Message]
        RETURN
    END

    -- Kiểm tra số lượng sản phẩm
    IF @soluong < 0
    BEGIN
        -- Trả về mã lỗi 2 nếu soluong < 0
        SELECT 2 AS [ErrorCode], 'So luong khong hop le' AS [Message]
        RETURN
    END

    IF @flag = 0 -- Thêm mới sản phẩm
    BEGIN
        INSERT INTO sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES(@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)

        SELECT 0 AS [ErrorCode], 'Them san pham thanh cong' AS [Message]
    END
    ELSE -- Cập nhật thông tin sản phẩm
    BEGIN
        UPDATE sanpham
        SET mahangsx = @mahangsx,
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp

        SELECT 0 AS [ErrorCode], 'Cap nhat san pham thanh cong' AS [Message]
    END
END
EXEC sp_ThemCapNhatSanPham 
    @masp = 'SP05',
    @tenhang = 'Samsung',
    @tensp = 'Điện thoại Samsung Galaxy A52',
    @soluong = 100,
    @mausac = 'Đen',
    @giaban = 7990000,
    @donvitinh = 'Cái',
    @mota = 'Mô tả sản phẩm',
    @flag = 0;
-- cau 4 --
CREATE PROCEDURE delete_sanpham(@masp VARCHAR(10))
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại trong bảng sanpham không
    IF NOT EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        -- Nếu không tồn tại, trả về mã lỗi 1
        SELECT 1 AS 'ErrorCode'
        RETURN
    END
    
    -- Xóa thông tin sản phẩm trong bảng Nhap
    DELETE FROM Nhap WHERE masp = @masp
    
    -- Xóa thông tin sản phẩm trong bảng Xuat
    DELETE FROM Xuat WHERE masp = @masp
    
    -- Xóa thông tin sản phẩm trong bảng sanpham
    DELETE FROM sanpham WHERE masp = @masp
    
    -- Trả về mã lỗi 0
    SELECT 0 AS 'ErrorCode'
END
-- cau 3 --
CREATE PROCEDURE sp_XoaNhanVien
    @manv NVARCHAR(10)
AS
BEGIN
    -- Kiểm tra xem mã nhân viên có tồn tại trong bảng nhanvien hay không
    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        -- Nếu không tồn tại, trả về mã lỗi 1
        SELECT 1 AS 'ErrorCode'
        RETURN
    END
    
    -- Xóa dữ liệu của nhân viên trong bảng Nhập và Xuat
    DELETE FROM Nhap WHERE manv = @manv
    DELETE FROM Xuat WHERE manv = @manv
    
    -- Xóa dữ liệu của nhân viên trong bảng nhanvien
    DELETE FROM nhanvien WHERE manv = @manv
    
    -- Trả về mã lỗi 0 để cho biết xóa thành công
    SELECT 0 AS 'ErrorCode'
END
EXEC sp_XoaNhanVien 'NV001'
-- cau 5--
CREATE PROCEDURE themHangsx 
    @mahangsx varchar(10),
    @tenhang nvarchar(50),
    @diachi nvarchar(100),
    @sodt varchar(20),
    @email varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra xem tên hãng sản xuất đã tồn tại hay chưa
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        -- Trả về mã lỗi 1 nếu tên hãng sản xuất đã tồn tại
        SELECT 1 AS [ErrorCode]
        RETURN
    END

    -- Thêm mới hãng sản xuất vào bảng
    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)

    -- Trả về mã lỗi 0 nếu thêm mới thành công
    SELECT 0 AS [ErrorCode]
    RETURN
END
EXEC themHangsx 
    @mahangsx = 'HSX001',
    @tenhang = N'Samsung',
    @diachi = N'Hà Nội',
    @sodt = '0987654321',
    @email = 'samsung@gmail.com';
-- cau 5--
CREATE PROCEDURE sp_NhapHang
    @sohdn nvarchar(50),
    @masp nvarchar(50),
    @manv nvarchar(50),
    @ngaynhap date,
    @soluongN int,
    @dongiaN float
AS
BEGIN
    -- Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        -- Nếu không, trả về mã lỗi 1
        SELECT 1 AS ErrorCode, 'Mã sản phẩm không tồn tại' AS ErrorMessage
        RETURN
    END
    
    -- Kiểm tra xem manv có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        -- Nếu không, trả về mã lỗi 2
        SELECT 2 AS ErrorCode, 'Mã nhân viên không tồn tại' AS ErrorMessage
        RETURN
    END
    
    -- Kiểm tra xem sohdn đã tồn tại trong bảng Nhap hay chưa
    IF EXISTS (SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Nếu đã tồn tại, cập nhật bảng Nhap theo sohdn
        UPDATE Nhap
        SET masp = @masp,
            manv = @manv,
            ngaynhap = @ngaynhap,
            soluongN = @soluongN,
            dongiaN = @dongiaN
        WHERE sohdn = @sohdn
        
        -- Trả về mã lỗi 0
        SELECT 0 AS ErrorCode, 'Cập nhật dữ liệu thành công' AS ErrorMessage
        RETURN
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại, thêm mới bảng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
        
        -- Trả về mã lỗi 0
        SELECT 0 AS ErrorCode, 'Thêm mới dữ liệu thành công' AS ErrorMessage
        RETURN
    END
END
-- cau 6---
DROP PROCEDURE sp_NhapXuat_Xuat
CREATE PROCEDURE sp_NhapXuat_Xuat
    @sohdx INT,
    @masp NVARCHAR(50),
    @manv NVARCHAR(50),
    @ngayxuat DATE,
    @soluongX INT
AS
BEGIN
    --Kiểm tra sự tồn tại của masp trong bảng Sanpham
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 1 --Mã lỗi 1: masp không tồn tại trong bảng Sanpham
    END
    
    --Kiểm tra sự tồn tại của manv trong bảng Nhanvien
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RETURN 2 --Mã lỗi 2: manv không tồn tại trong bảng Nhanvien
    END
    
    --Kiểm tra số lượng tồn kho của sản phẩm
    IF @soluongX > (SELECT soluong FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 3 --Mã lỗi 3: số lượng xuất vượt quá số lượng tồn kho của sản phẩm
    END
    
    --Kiểm tra sự tồn tại của sohdx
    IF EXISTS(SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        --Cập nhật bảng Xuat
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        --Thêm mới bảng Xuat
        INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX)
        VALUES(@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
    
    --Trả về mã lỗi 0: không có lỗi
    RETURN 0
END
EXEC sp_NhapXuat_Xuat
@sohdx = 123,
@masp = 'SP05',
@manv = 'NV05',
@ngayxuat = '2023-04-07',
@soluongX = 10
-- cau 7 --
CREATE PROCEDURE sp_NhapXuat_Xuat
    @sohdx INT,
    @masp INT,
    @manv INT,
    @ngayxuat DATE,
    @soluongX INT
AS
BEGIN
    --Kiểm tra sự tồn tại của masp trong bảng Sanpham
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 1 --Mã lỗi 1: masp không tồn tại trong bảng Sanpham
    END
    
    --Kiểm tra sự tồn tại của manv trong bảng Nhanvien
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RETURN 2 --Mã lỗi 2: manv không tồn tại trong bảng Nhanvien
    END
    
    --Kiểm tra số lượng tồn kho của sản phẩm
    IF @soluongX > (SELECT soluong FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 3 --Mã lỗi 3: số lượng xuất vượt quá số lượng tồn kho của sản phẩm
    END
    
    --Kiểm tra sự tồn tại của sohdx
    IF EXISTS(SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        --Cập nhật bảng Xuat
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        --Thêm mới bảng Xuat
        INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX)
        VALUES(@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
    
    --Trả về mã lỗi 0: không có lỗi
    RETURN 0
END

