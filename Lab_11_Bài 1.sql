-- bai1
-- cau 1
CREATE TABLE Khoa (
Makhoa VARCHAR(10) PRIMARY KEY,
Tenkhoa NVARCHAR(50) NOT NULL,
Dienthoai VARCHAR(20) NOT NULL
);

CREATE TABLE Lop (
Malop VARCHAR(10) PRIMARY KEY,
Tenlop NVARCHAR(50) NOT NULL,
Khoa VARCHAR(10) NOT NULL,
Hedt NVARCHAR(50) NOT NULL,
Namnhaphoc INT NOT NULL,
Makhoa VARCHAR(10) NOT NULL,
FOREIGN KEY (Khoa) REFERENCES Khoa(Makhoa),
FOREIGN KEY (Makhoa) REFERENCES Khoa(Makhoa)
);
--cau 2
CREATE PROCEDURE [dbo].[spInsertKhoa]
    @MaKhoa VARCHAR(10),
    @TenKhoa NVARCHAR(100),
    @DienThoai VARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT * FROM KHOA WHERE TenKhoa = @TenKhoa)
    BEGIN
        PRINT N'Tên khoa đã tồn tại !'
        RETURN
    END
    
    INSERT INTO KHOA(MaKhoa, TenKhoa, DienThoai)
    VALUES (@MaKhoa, @TenKhoa, @DienThoai)
    
    PRINT 'Thêm khoa thành công!'
END
EXEC spInsertKhoa 'K01', N'Khoa A', '0123456789'
EXEC spInsertKhoa 'K02', N'Khoa A', '0123456789'
-- cau 2
CREATE PROCEDURE sp_NhapLop
    @Malop nvarchar(10),
    @Tenlop nvarchar(50),
    @Khoa nvarchar(50),
    @Hedt nvarchar(50),
    @Namnhaphoc int,
    @Makhoa nvarchar(10)
AS
BEGIN
    -- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo
    IF EXISTS (SELECT * FROM Lop WHERE Tenlop = @Tenlop)
    BEGIN
        PRINT N'Lớp đã tồn tại'
        RETURN
    END

    -- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông báo
    IF NOT EXISTS (SELECT * FROM Khoa WHERE Makhoa = @Makhoa)
    BEGIN
        PRINT N'Mã khoa không tồn tại'
        RETURN
    END

    -- Nếu đầy đủ thông tin thì cho nhập
    INSERT INTO Lop(Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
    VALUES(@Malop, @Tenlop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa)
    
    PRINT N'Nhập thành công'
END
EXEC sp_NhapLop 'L01', N'Lớp A', 'K01', N'Cử nhân', 2023, 'K01'
-- cau 3
CREATE PROCEDURE sp_InsertKhoa_CheckExists
    @MaKhoa VARCHAR(10),
    @TenKhoa NVARCHAR(100),
    @DienThoai VARCHAR(20),
    @Exists BIT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT * FROM KHOA WHERE TenKhoa = @TenKhoa)
    BEGIN
        SET @Exists = 0
        RETURN
    END
    
    INSERT INTO KHOA(MaKhoa, TenKhoa, DienThoai)
    VALUES (@MaKhoa, @TenKhoa, @DienThoai)
    
    SET @Exists = 1
END
DECLARE @Exists BIT
EXEC sp_InsertKhoa_CheckExists 'K01', N'Khoa A', '0123456789', @Exists OUTPUT
IF @Exists = 1
BEGIN
    PRINT 'Thêm khoa thành công!'
END
ELSE
BEGIN
    PRINT N'Tên khoa đã tồn tại !'
END
-- cau 4
CREATE PROCEDURE sp_InsertLop
    @MaLop VARCHAR(10),
    @TenLop NVARCHAR(50),
    @Khoa NVARCHAR(10),
    @HeDT NVARCHAR(50),
    @NamNhapHoc INT,
    @MaKhoa VARCHAR(10)
AS
BEGIN
    -- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0
    IF EXISTS (SELECT 1 FROM Lop WHERE Tenlop = @TenLop)
    BEGIN
        RETURN 0
    END

    -- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì trả về 1
    IF NOT EXISTS (SELECT 1 FROM Khoa WHERE Makhoa = @MaKhoa)
    BEGIN
        RETURN 1
    END

    -- Nếu đầy đủ thông tin thì cho nhập và trả về 2
    INSERT INTO Lop(Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
    VALUES(@MaLop, @TenLop, @Khoa, @HeDT, @NamNhapHoc, @MaKhoa)
    
    RETURN 2
END
DECLARE @Result INT

EXEC @Result = sp_InsertLop 'L09', N'Lớp 9', 'K09', N'DH', 2021, 'K09'

IF @Result = 0
BEGIN
    PRINT N'Tên lớp đã có trước đó'
END
ELSE IF @Result = 1
BEGIN
    PRINT N'Mã khoa không tồn tại'
END
ELSE IF @Result = 2
BEGIN
    PRINT N'Nhập dữ liệu thành công'
END



