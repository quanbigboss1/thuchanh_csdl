-- tao bang sql 
CREATE TABLE MaThang (
  MaHang INT PRIMARY KEY,
  tenHang VARCHAR(255),
  SoLuong INT
);

CREATE TABLE NhatKyBanhang (
  STT INT PRIMARY KEY,
  Ngay DATE,
  NguoiMua VARCHAR(255),
  MaHang INT,
  SoLuong INT,
  GiaBan FLOAT,
  FOREIGN KEY (MaHang) REFERENCES MaThang(MaHang)
);
---
INSERT INTO MaThang (MaHang, tenHang, SoLuong)
VALUES (1, 'Keo', 100);

INSERT INTO MaThang (MaHang, tenHang, SoLuong)
VALUES (2, 'Banh', 200);

INSERT INTO MaThang (MaHang, tenHang, SoLuong)
VALUES (3, 'Thuoc', 100);

INSERT INTO NhatKyBanhang (STT, Ngay, NguoiMua, MaHang, SoLuong, GiaBan)
VALUES (1, '1999-02-09', 'ab', 2, 230, 50.0000);

INSERT INTO NhatKyBanhang (STT, Ngay, NguoiMua, MaHang, SoLuong, GiaBan)
VALUES (2, '2000-03-03', 'abc', 1, 400, 100.0000);
-- cau a
drop trigger trg_nhatkybanhang_insert
CREATE TRIGGER trg_nhatkybanhang_insert
ON NHATKYBANHANG
AFTER INSERT
AS
BEGIN
	UPDATE MATHANG
	SET soluong = MATHANG.soluong - inserted.soluong
	FROM MATHANG
	INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	END;
--Cau b--
CREATE TRIGGER trg_nhatkybanhang_update
ON NHATKYBANHANG
AFTER UPDATE
AS
	BEGIN
		IF UPDATE(soluong)
		BEGIN
		UPDATE MATHANG
		SET soluong = MATHANG.soluong + deleted.soluong - inserted.soluong
		FROM MATHANG
		INNER JOIN deleted ON MATHANG.mahang = deleted.mahang
		INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	END
END;
drop trigger kiem_tra_so_luong
-- cau c
DROP TRIGGER kiem_tra_so_luong
CREATE TRIGGER kiem_tra_so_luong
ON NhatKyBanhang
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN MaThang m ON i.MaHang = m.MaHang
        WHERE i.SoLuong > m.SoLuong
    )
    BEGIN
        RAISERROR (N'So luong hang ban ra phai nho hon hoac bang so luong hien co', 16, 1);
    END;
    ELSE
    BEGIN
        INSERT INTO NhatKyBanhang (Ngay, NguoiMua, MaHang, SoLuong, GiaBan)
        SELECT Ngay, NguoiMua, MaHang, SoLuong, GiaBan
        FROM inserted;
    END;
END;
INSERT INTO NhatKyBanhang (STT, Ngay, NguoiMua, MaHang, SoLuong, GiaBan)
VALUES (2, '2023-04-21', 'cd', 1, 200, 100.0000);


--Cau d--

CREATE TRIGGER trg_nhatkybanhang_update1
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
IF (SELECT COUNT(*) FROM inserted) > 1
BEGIN
	RAISERROR('Chỉ được cập nhật 1 bản ghi tại một thời điểm!', 16, 1)
	ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM inserted

		SELECT @soluong_hien_co = soluong
		FROM MATHANG
		WHERE mahang = @mahang

		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
--Cau e--
drop TRIGGER trg_nhatkybanhang_delete
CREATE TRIGGER trg_nhatkybanhang_delete
ON NHATKYBANHANG
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(*) FROM deleted) > 1
	BEGIN
		RAISERROR('Chỉ được xóa 1 bản ghi tại một thời điểm!', 16, 1)
		ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
		DECLARE @mahang INT, @soluong INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM deleted
		UPDATE MATHANG
		SET soluong = soluong + @soluong
		WHERE mahang = @mahang
	END
END;
--Cau f--
CREATE TRIGGER trg_nhatkybanhang_update
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong > @soluong_hien_co
	BEGIN
		RAISERROR('Số lượng cập nhật không được vượt quá số lượng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE IF @soluong = @soluong_hien_co
	BEGIN
		RAISERROR('Không cần cập nhật số lượng!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
--Cau g--
CREATE PROCEDURE sp_xoa_mathang
@mahang INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM MATHANG WHERE mahang = @mahang)
BEGIN
PRINT 'Mã hàng không tồn tại!'
RETURN
END

BEGIN TRANSACTION

DELETE FROM NHATKYBANHANG WHERE mahang = @mahang
DELETE FROM MATHANG WHERE mahang = @mahang

COMMIT TRANSACTION

PRINT 'Xóa mặt hàng thành công!'
END
EXEC sp_xoa_mathang 3
--Cau h--
CREATE FUNCTION fn_tongtien_hang
(@tenhang NVARCHAR(50))
RETURNS MONEY
AS
BEGIN
DECLARE @tongtien MONEY

SELECT @tongtien = SUM(nk.SoLuong * nk.GiaBan)
FROM NhatKyBanhang nk
WHERE nk.MaHang = (SELECT MaHang FROM MaThang WHERE tenHang = @tenhang)

RETURN @tongtien
END
-- cau i
--Cau3i--
-- Test cho câu 2
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- Test cho câu a
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(6, '2022-04-03', 'Nguyễn Văn AB', 1, 3, 14000)
SELECT * FROM MATHANG
-- Test cho câu b
UPDATE NHATKYBANHANG SET soluong = 200 WHERE stt = 2
SELECT * FROM MATHANG
-- Test cho câu c
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(4, '2022-04-05', 'Nguyễn Văn B', 2, 10, 20000)
SELECT * FROM MATHANG
-- Test cho câu d
UPDATE NHATKYBANHANG SET soluong = 15 WHERE stt = 2
SELECT * FROM MATHANG
-- Test cho câu e
DELETE FROM NHATKYBANHANG WHERE stt = 3
SELECT * FROM MATHANG
-- Test cho câu f
UPDATE NHATKYBANHANG SET soluong = 160 WHERE stt = 5
SELECT * FROM MATHANG
-- Test cho câu g
EXEC sp_xoa_mathang 3
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- Test cho câu h
SELECT dbo.fn_tongtien_hang('Keo') AS 'Tổng tiền keo'
SELECT dbo.fn_tongtien_hang('Banh ') AS 'Tổng tiền bánh'







