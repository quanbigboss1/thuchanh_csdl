CREATE TABLE MonHoc (
    id INT PRIMARY KEY,
    TenMonHoc NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE NguoiDung (
    id INT PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(50) NOT NULL,
	role nvarchar(50) NOT NULL
);

CREATE TABLE CauHoi (
    id INT PRIMARY KEY,
    NoiDung NVARCHAR(MAX) NOT NULL,
    DapAn1 NVARCHAR(255) NOT NULL,
    DapAn2 NVARCHAR(255) NOT NULL,
    DapAn3 NVARCHAR(255) NOT NULL,
    DapAn4 NVARCHAR(255) NOT NULL,
    DapAnDung NVARCHAR(255) NOT NULL,
    monhoc_id INT NOT NULL,
    FOREIGN KEY (monhoc_id) REFERENCES MonHoc(id)
);
CREATE TABLE ThongTinNguoiDung (
    id INT PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255),
    email NVARCHAR(255),
    SoDienThoai NVARCHAR(20),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES NguoiDung(id)
);
CREATE TABLE KyThi (
    id INT PRIMARY KEY,
    TenKyThi NVARCHAR(255) NOT NULL,
	NamKyThi NVARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES NguoiDung(id)
);

CREATE TABLE TheLoaiThi (
    id INT PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    Ten_Mon_Hoc NVARCHAR(255) NOT NULL,
    monhoc_id INT NOT NULL,
    de_thi_id INT NOT NULL,
    FOREIGN KEY (de_thi_id) REFERENCES KyThi(id),
    FOREIGN KEY (monhoc_id) REFERENCES MonHoc(id)
);

INSERT INTO MonHoc(id,TenMonHoc)
VALUES 
	('1',N'Toán'),
	('2',N'Văn'),
	('3',N'Anh');
 Select * from MonHoc

 INSERT INTO NguoiDung(id,username,password,role)
	VALUES	(1, 'user1', 'password1', 'user'),
			(2, 'user2', 'password2', 'admin'),
			(3, 'user3', 'password3', 'user'),
			(4, 'user4', 'password4', 'admin'),
			(5, 'user5', 'password5', 'user');
 Select * from NguoiDung

 INSERT INTO CauHoi (id, NoiDung, DapAn1, DapAn2, DapAn3, DapAn4, DapAnDung, monhoc_id)
VALUES
  (1, '5 + 3 = ?', '6', '7', '8', '9', '8', 1),
  (2, '7 + 2 = ?', '8', '9', '10', '11', '9', 1),
  (3, '10 - 4 = ?', '4', '5', '6', '7', '6', 1),
  (4, '2 x 3 = ?', '3', '4', '5', '6', '6', 1),
   (5, 'Đây là tác phẩm của tác giả nào? "Tôi thấy hoa vàng trên cỏ xanh"', 'Nguyễn Nhật Ánh', 'Nam Cao', 'Vũ Trọng Phụng', 'Kim Dung', 'Nguyễn Nhật Ánh', 2),
   (6, 'Tên nhân vật chính trong truyện "Chí Phèo"', 'Chí Phèo', 'Thị Nở', 'Mã Giám Sinh', 'Thúy Kiều', 'Chí Phèo', 2),
   (7, 'Đây là tác phẩm của tác giả nào? "Tắt đèn"', 'Tô Hoài', 'Nguyễn Ngọc Ngạn', 'Bảo Ninh', 'Ngô Tất Tố', 'Ngô Tất Tố', 2),
    (8, 'What is the opposite of "hot"?', 'Cold', 'Warm', 'Wet', 'Dry', 'Cold', 3),
	(9, 'What is the plural of "child"?', 'Childs', 'Childen', 'Children', 'Childies', 'Children', 3),
	(10, 'What is the present continuous form of the verb "to eat"?', 'Eats', 'Eating', 'Ate', 'Eaten', 'Eating', 3);

  Select * from CauHoi


 INSERT INTO ThongTinNguoiDung (id, HoTen, DiaChi, email, SoDienThoai, user_id)
VALUES
    (1, N'Nguyễn Ngọc Hải Anh', N'Quận 12', 'nguyenhaianh@gmail.com', '0987654321', 1),
    (2, N'Huỳnh Văn Chiến', N'WC', 'vanchien@gmail.com', '0123456789', 2),
    (3, N'Lê Đình Quân', N'Hà Tĩnh', 'levanc@gmail.com', '0369876543', 3),
    (4, N'Nguyễn Công Trường', N'Hà Nội', 'congtruong@gmail.com', '0975123456', 4),
    (5, N'Nguyễn Anh Tới', N'Hải Phòng', 'anhtoi@gmail.com', '0901234567', 5);
 Select * from ThongTinNguoiDung

 INSERT INTO KyThi (id, TenKyThi, NamKyThi, user_id) VALUES
(1, N'Kiểm tra 15 phút', '2023', 1),
(2, N'Kiểm tra 1 tiểt', '2023',2),
(3, N'Kiểm tra giữa kì', '2023', 3),
(4, N'Thi kết thúc học phần', '2023', 4),
(5, N'Thi tốt nghiệp', '2023', 5);
 Select * from KyThi

 INSERT INTO TheLoaiThi(id, name, Ten_Mon_Hoc, monhoc_id, de_thi_id)
VALUES
    (1, N'Kiểm tra 15 phút', N'Toán', 1, 1),
    (2, N'Kiểm tra 1 tiết', N'Văn', 2, 2),
    (3, N'Kiểm tra giữa kỳ', N'Anh', 3, 3),
    (4, N'Thi kết thúc học phần', N'Anh', 3, 4),
    (5, N'Thi tốt nghiệp', N'Văn', 2, 5);
	 Select * from TheLoaiThi