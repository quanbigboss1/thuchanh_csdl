-- Câu 1 ( 2 điểm )
CREATE TABLE Nhap (
    SoHDN nvarchar(10) PRIMARY KEY,
    MaVT nvarchar(10) ,
    SoLuongN int ,
    DonGiaN float ,
    NgayN datetime 
);

CREATE TABLE Xuat (
    SoHDX nvarchar(10) PRIMARY KEY,
    MaFT nvarchar(10) ,
    SoLuongX int ,
    DonGiaX float ,
    NgayX datetime 
);

CREATE TABLE Ton (
    MaVT nvarchar(10) PRIMARY KEY,
    TenVT nvarchar(50),
    SoLuongT int 
);
-- Thêm 3 phiếu nhập vào bảng Nhap
INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN)
VALUES ('PN001', 'VT001', 10, 10000, '2023-04-01'),
       ('PN002', 'VT002', 20, 20000, '2023-04-02'),
       ('PN003', 'VT003', 30, 30000, '2023-04-03');

-- Thêm 3 phiếu xuất vào bảng Xuat
INSERT INTO Xuat (SoHDX, MaFT, SoLuongX, DonGiaX, NgayX)
VALUES ('PX001', 'FT001', 5, 15000, '2020-04-01'),
       ('PX002', 'FT002', 10, 25000, '2020-04-02'),
       ('PX003', 'FT003', 15, 35000, '2020-04-03');

-- Thêm 4 mặt hàng vào bảng Ton
INSERT INTO Ton (MaVT, TenVT, SoLuongT)
VALUES ('VT001', N'Mặt hàng 1', 150),
       ('VT002', N'Mặt hàng 2', 200),
       ('VT003', N'Mặt hàng 3', 250),
       ('VT004', N'Mặt hàng 4', 300);
-- Câu 2 ( 2 điểm )

CREATE FUNCTION ThongKeTienBan(@NgayX datetime, @MaVT nvarchar(10))
RETURNS TABLE
AS
RETURN (
    SELECT Ton.MaVT, Ton.TenVT, SUM(Nhap.SoLuongN * Nhap.DonGiaN) AS TienBan
    FROM Ton
    JOIN Nhap ON Ton.MaVT = Nhap.MaVT
    WHERE Nhap.MaVT = @MaVT AND CONVERT(date, Nhap.NgayN) = CONVERT(date, @NgayX)
    GROUP BY Ton.MaVT, Ton.TenVT
);

SELECT * FROM ThongKeTienBan('2023-04-01', 'VT001');

-- Câu 3
CREATE FUNCTION ThongKeTienNhap(@MaVT nvarchar(10), @NgayN datetime)
RETURNS TABLE
AS
RETURN (
SELECT MaVT, SUM(SoLuongN * DonGiaN) AS TienNhap
FROM Nhap
WHERE MaVT = @MaVT AND NgayN = @NgayN
GROUP BY MaVT, NgayN
)
SELECT * FROM ThongKeTienNhap('VT001', '2023-04-01')

-- Câu 4
CREATE TRIGGER tr_Nhap_Insert
ON Nhap
FOR INSERT
AS
BEGIN
    DECLARE @MaVT nvarchar(10)
    DECLARE @SoLuongN int

    SELECT @MaVT = MaVT, @SoLuongN = SoLuongN
    FROM inserted

    IF EXISTS(SELECT 1 FROM Ton WHERE MaVT = @MaVT)
    BEGIN
        UPDATE Ton SET SoLuongT = SoLuongT + @SoLuongN WHERE MaVT = @MaVT
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR ('Mã VT chưa có mặt trong bảng Ton', 16, 1)
    END
END
INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN) VALUES ('PN007', 'VT004', 15, 12000, '2023-04-04');
