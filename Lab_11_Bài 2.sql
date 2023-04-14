-- lab_11_câu 2
--  a)tạo csdl
create database QLNV
-- b) tạo các bảng
CREATE TABLE tblChucvu (
  MaCV VARCHAR(2) PRIMARY KEY,
  TenCV NVARCHAR(30) NOT NULL
);

CREATE TABLE tblNhanVien (
  MaNV VARCHAR(4) PRIMARY KEY,
  MaCV VARCHAR(2) NOT NULL,
  TenNV NVARCHAR(30) NOT NULL,
  NgaySinh DATE NOT NULL,
  LuongCanBan float NOT NULL,
  NgayCong INT NOT NULL,
  PhuCap float NOT NULL,
  FOREIGN KEY (MaCV) REFERENCES tblChucvu(MaCV)
);
-- insert du lieu
INSERT INTO tblChucvu (MaCV, TenCV) VALUES ('BV', 'Bảo vệ');
INSERT INTO tblChucvu (MaCV, TenCV) VALUES ('GD', 'Giám đốc');
INSERT INTO tblChucvu (MaCV, TenCV) VALUES ('HC', 'Hành Chính');
INSERT INTO tblChucvu (MaCV, TenCV) VALUES ('KT', 'Kế Toán');
INSERT INTO tblChucvu (MaCV, TenCV) VALUES ('TQ', 'Thu Quỹ');
INSERT INTO tblChucvu (MaCV, TenCV) VALUES ('VS', 'Vệ Sinh');

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES ('NV01', 'GD', 'Nguyễn Văn An', '1977-12-12', 700000, 25, 500000);

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES ('NV02', 'BV', 'Bùi Văn Tí', '1978-10-10', 400000, 24, 100000);

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES ('NV03', 'KT', 'Trần Thanh Nhật', '1977-9-9', 600000, 26, 400000);

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES ('NV04', 'VS', 'Nguyễn Thị Út', '1980-10-10', 300000, 26, 300000);

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES ('NV05', 'HC', 'Lê Thị Hà', '1979-10-10', 500000, 27, 200000);
--Yeu cau a
CREATE PROCEDURE [dbo].[ThemNhanVien]
    @MaNV VARCHAR(4),
    @MaCV VARCHAR(2),
    @TenNV NVARCHAR(30),
    @NgaySinh DATE,
    @LuongCanBan FLOAT,
    @NgayCong INT,
    @PhuCap FLOAT
AS
BEGIN
    -- Kiểm tra xem MaCV có tồn tại trong bảng tblChucVu hay không
    IF NOT EXISTS (SELECT * FROM tblChucVu WHERE MaCV = @MaCV)
    BEGIN
        PRINT N'Mã chức vụ không tồn tại trong bảng tblChucVu!'
        RETURN
    END
    
    -- Thêm nhân viên mới vào bảng tblNhanVien
    INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap)
    
    PRINT N'Thêm nhân viên thành công!'
END
EXEC ThemNhanVien 'NV01', 'CV01', N'Nguyễn Văn A', '1990-01-01', 5000000, 22, 1000000
-- yeu cau b
CREATE PROCEDURE SP_CapNhatNhanVien 
  @MaNV VARCHAR(4),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(30),
  @NgaySinh DATE,
  @LuongCanBan FLOAT,
  @NgayCong INT,
  @PhuCap FLOAT
AS
BEGIN
  -- kiểm tra xem MaCV có tồn tại trong tblChucVu hay không
  IF EXISTS(SELECT * FROM tblChucVu WHERE MaCV = @MaCV)
  BEGIN
    -- cập nhật thông tin nhân viên
    UPDATE tblNhanVien 
    SET MaCV = @MaCV, 
        TenNV = @TenNV, 
        NgaySinh = @NgaySinh, 
        LuongCanBan = @LuongCanBan, 
        NgayCong = @NgayCong, 
        PhuCap = @PhuCap 
    WHERE MaNV = @MaNV;
    PRINT N'Đã cập nhật thông tin nhân viên.'
  END
  ELSE
  BEGIN
    -- thông báo lỗi nếu MaCV không tồn tại trong tblChucVu
    PRINT N'Mã chức vụ không tồn tại trong bảng chức vụ.'
  END
END
EXEC SP_CapNhatNhanVien 'NV01', 'CV01', 'Nguyen Van A', '1990-01-01', 5000000, 20, 1000000
-- yeu cau c
CREATE PROCEDURE SP_LuongLN
AS
BEGIN
  SELECT MaNV, TenNV, LuongCanBan*NgayCong+PhuCap AS Luong
  FROM tblNhanVien;
END
EXEC SP_LuongLN;





