--lab2 query1
CREATE VIEW lab2_1
AS
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
SELECT * FROM lab2_1
--lab 2 query2
Create View lab2_2
AS
SELECT masp,tensp,tenhang,soluong,mausac,giaban,donvitinh,mota
FROM sanpham inner join Hangsx on sanpham.mahangsx = hangsx.mahangsx
select * from lab2_2
-- lab 2 query 3
CREATE VIEW lab2_3 AS
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung';
SELECT * FROM lab2_3
-- lab 2 query 4
CREATE VIEW lab2_4 AS
SELECT * FROM nhanvien
WHERE gioitinh = 'Nữ' AND phong = 'Kế toán';
SELECT * FROM lab2_4
-- lab 2 query 5
CREATE VIEW lab2_5 AS
SELECT Nhap.sohdn, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.soluongN, Nhap.dongiaN, Sanpham.mausac, Sanpham.donvitinh, Nhap.ngaynhap, Nhanvien.tennv, Nhanvien.phong,
  Nhap.soluongN*Nhap.dongiaN AS tiennhap
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv;
SELECT * FROM lab2_5
-- lab 2 query 6
CREATE VIEW lab2_6 AS
SELECT Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, 
       Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, 
       Nhanvien.tennv, Nhanvien.phong
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE MONTH(Xuat.ngayxuat) = 10 AND YEAR(Xuat.ngayxuat) = 2018;
SELECT * FROM lab2_6
-- lab 2 query 7
CREATE VIEW lab2_7 AS
SELECT sohdn, Sanpham.masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong
FROM Nhap 
JOIN Sanpham ON Nhap.masp = Sanpham.masp 
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2017;
SELECT * FROM lab2_7
-- lab 2 query 8 
CREATE VIEW lab2_8 AS
SELECT TOP 10 Xuat.sohdx, Sanpham.tensp, Xuat.soluongX
FROM Xuat 
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE YEAR(Xuat.ngayxuat) = '2022' 
ORDER BY Xuat.soluongX DESC;
SELECT * FROM lab2_8
-- lab 2 query 9
CREATE VIEW lab2_9 AS
SELECT TOP 10 tenSP, giaBan
FROM SanPham
ORDER BY giaBan DESC;
SELECT * FROM lab2_9;
-- lab 2_10
CREATE VIEW lab2_10 AS
SELECT Sanpham.masp, Sanpham.tensp, Sanpham.giaban, Sanpham.mausac, Sanpham.donvitinh, Hangsx.tenhang AS hangsx_name
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND Sanpham.giaban >= 100000 AND Sanpham.giaban <= 500000
SELECT * FROM lab2_10;
-- lab 2_11
CREATE VIEW lab2_11 AS
SELECT SUM(soluongN * dongiaN) AS tongtien
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2018
SELECT * FROM lab2_11;
-- lab 2_12
CREATE VIEW lab2_12 AS
SELECT SUM(Xuat.soluongX * Sanpham.giaban) AS Tongtien
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE Xuat.ngayxuat = '2018-09-02'
SELECT * FROM lab2_12;
-- lab 2_13
CREATE VIEW lab2_13 AS
SELECT TOP 1 sohdn, ngaynhap, dongiaN
FROM Nhap
ORDER BY dongiaN DESC
SELECT * FROM lab2_13;
-- lab 2_14
CREATE VIEW lab2_14 AS
SELECT TOP 10 Sanpham.tensp, SUM(Nhap.soluongN) AS TongSoLuongN 
FROM Sanpham 
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp 
WHERE YEAR(Nhap.ngaynhap) = 2019 
GROUP BY Sanpham.tensp 
ORDER BY TongSoLuongN DESC;
SELECT * FROM lab2_14;
-- lab 2_15
CREATE VIEW lab2_15 AS
SELECT Sanpham.masp, Sanpham.tensp
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp
INNER JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND Nhanvien.manv = 'NV01';
SELECT * FROM lab2_15;
-- lab 2_16
CREATE VIEW lab2_16 AS
SELECT sohdn, masp, soluongN, ngaynhap
FROM Nhap
WHERE masp = 'SP02' AND manv = 'NV02';
SELECT * FROM lab2_16;
-- lab 2_17
CREATE VIEW lab2_17 AS
SELECT Nhanvien.manv, Nhanvien.tennv
FROM Nhanvien
JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Xuat.masp = 'SP02' AND Xuat.ngayxuat = '2020-03-02'
SELECT * FROM lab2_17;
--lab3 query 1--
CREATE VIEW lab3_1 AS
SELECT TOP 100 PERCENT Hangsx.tenhang, COUNT(Sanpham.masp) AS so_luong_sp
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
GROUP BY Hangsx.tenhang
ORDER BY so_luong_sp DESC;
SELECT * FROM lab3_1;
-- lab 3 query 2--
CREATE VIEW lab3_2 AS
SELECT masp, SUM(soluongN * dongiaN) AS TongTienNhap
FROM Nhap
WHERE YEAR(ngaynhap) = 2020
GROUP BY masp;
SELECT * FROM lab3_2;
-- lab 3 query 3--
CREATE VIEW lab3_3 AS
SELECT Sanpham.masp, Sanpham.tensp, SUM(Xuat.soluongX) AS tong_so_luong_xuat
FROM Sanpham JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE Sanpham.mahangsx = 'H01'
GROUP BY Sanpham.masp, Sanpham.tensp
HAVING SUM(Xuat.soluongX) > 10000;
SELECT * FROM lab3_3;
-- lab 3 query 4--
CREATE VIEW lab3_4 AS
SELECT phong, COUNT(*) AS So_luong_nhan_vien_nam
FROM Nhanvien
WHERE gioitinh = N'Nam'
GROUP BY phong;
SELECT * FROM lab3_4;
-- lab 3 query 5
CREATE VIEW lab3_5 AS
SELECT Hangsx.tenhang, SUM(Nhap.soluongN) AS tongnhap
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2020
GROUP BY Hangsx.tenhang;
SELECT * FROM lab3_5;
-- lab 3 query 6--
CREATE VIEW lab3_6 AS
SELECT Nhanvien.manv, Nhanvien.tennv, SUM(Xuat.soluongX * Sanpham.giaban) AS tongtienxuat
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE YEAR(Xuat.ngayxuat) = 2018
GROUP BY Nhanvien.manv, Nhanvien.tennv;
SELECT * FROM lab3_6;
-- lab 3 query 7--
CREATE VIEW lab3_7 as
SELECT manv, SUM(soluongN * dongiaN) AS tong_tien_nhap
FROM Nhap
WHERE MONTH(ngaynhap) = 8 AND YEAR(ngaynhap) = 2018
GROUP BY manv
HAVING SUM(soluongN * dongiaN) > 100000;
CREATE VIEW lab3_7 as
SELECT * FROM lab3_7;
-- lab 3 query 8
CREATE VIEW lab3_8 as
SELECT *
FROM Sanpham
WHERE masp NOT IN (SELECT masp FROM Xuat)
SELECT * FROM lab3_8;
-- lab 3 query 9--
CREATE VIEW lab3_9 as
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.ngaynhap, Xuat.ngayxuat
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Nhap.ngaynhap) = 2018 AND YEAR(Xuat.ngayxuat) = 2018;
SELECT * FROM lab3_9;
-- lab 3 query 10--
CREATE VIEW lab3_10 as
SELECT DISTINCT NV.manv, NV.tennv
FROM Nhap N 
JOIN Xuat X ON N.masp = X.masp AND N.manv = X.manv
JOIN Nhanvien NV ON N.manv = NV.manv;
SELECT * FROM lab3_10;
-- lab 3 query 11--
CREATE VIEW lab3_11 AS
SELECT Nhanvien.manv AS nv_manv, Nhanvien.tennv, Nhap.manv AS nhap_manv, Xuat.manv AS xuat_manv
FROM Nhanvien
LEFT JOIN Nhap ON Nhanvien.manv = Nhap.manv
LEFT JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Nhap.manv IS NULL AND Xuat.manv IS NULL;
SELECT * FROM lab3_11;
;


