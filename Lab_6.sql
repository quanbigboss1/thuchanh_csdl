----lab 6.1
CREATE FUNCTION ThongTinSanPhamTheoHangSX(@tenhangsx nvarchar(50))
returns @sanpham table(
masp nvarchar(10),
mahangsx nvarchar(10),
tensp nvarchar(50),
soluong int,
mausac nvarchar(20),
giaban float,
donvitinh nvarchar(20),
mota nvarchar(max)
)
AS
BEGIN
insert into @sanpham
select masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota
from Sanpham
where mahangsx = (select mahangsx from Hangsx where tenhang = @tenhangsx)
return
end
SELECT * FROM ThongTinSanPhamTheoHangSX('Galaxy Note 11')
--- Lab 6.2
CREATE FUNCTION DanhSachSanPhamHangSXNhap(@ngaybatdau datetime, @ngayketthuc datetime)
returns @sanphamhangsx table(
tensp nvarchar(50),
tenhangsx nvarchar(50),
soluongN int,
dongiaN float
)
AS
BEGIN
insert into @sanphamhangsx
select sp.tensp, hsx.tenhang, np.soluongN, np.dongiaN
from Sanpham sp
inner join Hangsx hsx on sp.mahangsx = hsx.mahangsx
inner join Nhap np on sp.masp = np.masp
where np.ngaynhap between @ngaybatdau and @ngayketthuc
return
end
SELECT * FROM DanhSachSanPhamHangSXNhap('01-01-2017','01-01-2022')
--Lab 6.3
CREATE FUNCTION sp_by_hangsx_soluong(@hangsx nvarchar(50), @luachon int)
RETURNS TABLE
AS
RETURN
    SELECT sp.masp, sp.tensp, hsx.tenhang, sp.soluong, sp.giaban, sp.donvitinh, sp.mota
    FROM Sanpham sp
    JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
    WHERE hsx.tenhang = @hangsx AND ((@luachon = 0 AND sp.soluong = 0) OR (@luachon = 1 AND sp.soluong > 0))
SELECT * FROM sp_by_hangsx_soluong('Oppo', 1)
-- Lab6.4
CREATE FUNCTION nv_by_phong(@x INT, @y INT)
RETURNS TABLE
AS
RETURN
    SELECT sp.masp, sp.tensp, hsx.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota, xuat.ngayxuat
    FROM Sanpham sp
    INNER JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
    INNER JOIN Xuat xuat ON sp.masp = xuat.masp
    WHERE YEAR(xuat.ngayxuat) BETWEEN @x AND @y;
SELECT * FROM nv_by_phong(2018,2020)
-- Lab 6.5
CREATE FUNCTION DanhSachHangSXTheoDiaChi(@diaChi NVARCHAR(50))
RETURNS @hangSX TABLE (
    mahangsx INT,
    tenhang NVARCHAR(50),
    diachi NVARCHAR(50),
    sodt NVARCHAR(20),
    email NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @hangSX
    SELECT mahangsx, tenhang, diachi, sodt, email
    FROM Hangsx
    WHERE diachi LIKE '%' + @diaChi + '%'

    RETURN
END
-- Lab 6.6
CREATE FUNCTION DanhSachSanPhamVaHangSXDaXuat(@namX INT, @namY INT)
RETURNS @sanPhamHangSX TABLE (
    masp INT,
    tensp NVARCHAR(50),
    tenhang NVARCHAR(50),
    ngayxuat DATE,
    soluongX INT
)
AS
BEGIN
    INSERT INTO @sanPhamHangSX
    SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.ngayxuat, Xuat.soluongX
    FROM Sanpham
    JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
    JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Xuat.ngayxuat) BETWEEN @namX AND @namY

    RETURN
END

-- Lab 6.7
CREATE FUNCTION dbo.DanhSachSanPhamTheoHangSXVaLuaChon
(
    @mahangsx INT,
    @luaChon INT
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        sp.masp, 
        sp.tensp, 
        sp.soluong, 
        sp.giaban, 
        sp.donvitinh, 
        sp.mota
    FROM 
        Sanpham sp
        JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
        LEFT JOIN Nhap n ON sp.masp = n.masp
        LEFT JOIN Xuat x ON sp.masp = x.masp
    WHERE 
        hs.mahangsx = @mahangsx 
        AND (@luaChon = 0 AND n.masp IS NOT NULL OR @luaChon = 1 AND x.masp IS NOT NULL)
)

-- Lab 6.8
CREATE FUNCTION dbo.DanhSachNhanVienDaNhapHang
(
    @ngayNhap DATE
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        nv.manv, 
        nv.tennv, 
        nv.gioitinh, 
        nv.diachi, 
        nv.sodt, 
        nv.email, 
        nv.phong
    FROM 
        Nhanvien nv 
        JOIN Nhap n ON nv.manv = n.manv
    WHERE 
        n.ngaynhap = @ngayNhap
)

-- Lab 6.9
CREATE FUNCTION GetProductsByPriceAndManufacturer
(
    @minPrice FLOAT,
    @maxPrice FLOAT,
    @manufacturer VARCHAR(50)
)
RETURNS @products TABLE
(
    masp VARCHAR(10),
    mahangsx VARCHAR(10),
    tensp NVARCHAR(50),
    soluong INT,
    mausac NVARCHAR(50),
    giaban FLOAT,
    donvitinh NVARCHAR(20),
    mota NVARCHAR(MAX)
)
AS
BEGIN
    INSERT INTO @products
    SELECT s.masp, s.mahangsx, s.tensp, s.soluong, s.mausac, s.giaban, s.donvitinh, s.mota
    FROM Sanpham s
    INNER JOIN Hangsx h ON s.mahangsx = h.mahangsx
    WHERE s.giaban >= @minPrice AND s.giaban <= @maxPrice AND h.tenhang = @manufacturer
    RETURN
END

-- Lab 6.10
CREATE FUNCTION Lab6q10
(
)
RETURNS TABLE
AS
RETURN
(
    SELECT sp.Masp, sp.Tensp, sp.Mausac, sp.Giaban, sp.Donvitinh, sp.Mota, hs.Tenhang
    FROM Sanpham sp
    INNER JOIN Hangsx hs ON sp.Mahangsx = hs.Mahangsx
)
SELECT * FROM Lab6q10()