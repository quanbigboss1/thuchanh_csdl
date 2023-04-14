-- câu 1
CREATE TRIGGER trg_Nhap
ON Nhap
AFTER INSERT
AS
BEGIN
    DECLARE @masp NVARCHAR(10)
    DECLARE @manv NVARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN
    FROM inserted
    
    -- Kiểm tra masp có trong bảng Sanpham chưa
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR('Lỗi: masp không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra manv có trong bảng Nhanvien chưa
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR('Lỗi: manv không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Lỗi: soluongN và dongiaN phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng sản phẩm trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + @soluongN
    WHERE masp = @masp
END
-- câu 2
CREATE TRIGGER Check_Xuat
ON Xuat
AFTER INSERT
AS
BEGIN
    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = (SELECT masp FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = (SELECT manv FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    DECLARE @soluongX INT
    SELECT @soluongX = soluongX FROM inserted
    
    DECLARE @soluong INT
    SELECT @soluong = soluong FROM Sanpham WHERE masp = (SELECT masp FROM inserted)
    
    IF (@soluongX > @soluong)
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong - @soluongX
    WHERE masp = (SELECT masp FROM inserted)
END
-- câu 3--
CREATE TRIGGER updateSoluongXoaPhieuXuat
ON Xuat
AFTER DELETE
AS
BEGIN
    -- Cập nhật số lượng hàng trong bảng Sanpham tương ứng với sản phẩm đã xuất
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong + deleted.soluongX
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END
-- câu 4--
CREATE TRIGGER update_xuat_trig
ON xuat
AFTER UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1 -- check if more than 1 row is updated
    BEGIN
        RAISERROR ('Cannot update more than one row at a time', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    DECLARE @Masp int, @Soluong int, @SoluongX int

    SELECT @Masp = i.Masp, @Soluong = s.Soluong, @SoluongX = i.SoluongX
    FROM inserted i
    JOIN Sanpham s ON i.Masp = s.Masp

    IF @SoluongX > @Soluong -- check if soluongX is less than Soluong
    BEGIN
        RAISERROR ('SoluongX cannot be greater than Soluong', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- update the xuat and Sanpham tables
    UPDATE xuat
    SET soluongX = @SoluongX
    WHERE Masp = @Masp

    UPDATE Sanpham
    SET Soluong = Soluong - @SoluongX
    WHERE Masp = @Masp
END;
-- câu 5 --
CREATE TRIGGER tr_update_soluongnhap
ON Nhap
AFTER UPDATE
AS
BEGIN
  IF @@ROWCOUNT > 1
  BEGIN
    RAISERROR('Only one row can be updated at a time', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END
  
  UPDATE Sanpham
  SET soluong = soluong - (INSERTED.soluongN - DELETED.soluongN)
  FROM Sanpham
  INNER JOIN INSERTED ON Sanpham.masp = INSERTED.masp
  INNER JOIN DELETED ON INSERTED.sohdn = DELETED.sohdn
  WHERE Sanpham.masp = INSERTED.masp;
  
END;
-- câu 6--
CREATE TRIGGER update_soluong_sp 
ON Nhap
AFTER DELETE
AS

BEGIN
    
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong - deleted.soluongN
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END

