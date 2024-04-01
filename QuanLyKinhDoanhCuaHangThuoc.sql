/* Bài tập lớn môn: Hệ quản trị cơ sở dữ liệu
Đề tài: Quản lí kinh doanh cửa hàng thuốc
Nhóm 17: Nguyễn Đức Mạnh 
		 Ngọ Quốc Minh 
		 Phạm Quang Thắng
		 Bùi Anh Tuấn
*/

CREATE DATABASE QuanLiKinhDoanhCuaHangThuoc
ON
(   NAME = 'QLKDCHT',
    FILENAME = 'D:\BTL_SQL\QuanLiKinhDoanhCuaHangThuoc.mdf',
    SIZE = 2MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5%
	)
USE QuanLiKinhDoanhCuaHangThuoc

drop table tblChiTietHoaDon
drop table tblNhanVien
drop table tblKhachHang
drop table tblThuoc
drop table tblHoaDon
/* ==== Khởi tạo bảng ==== */
CREATE TABLE tblNhanVien (
iMaNV INT PRIMARY KEY,
sHoTen NVARCHAR(50),
dNgaySinh DATE,
sDiaChi NVARCHAR(50),
fHSL FLOAT,
sGioiTinh BIT,
sSoDienThoai NVARCHAR(12) UNIQUE,
CONSTRAINT check_fHSL CHECK (fHSL>0))
ALTER TABLE tblNhanVien ADD fLuongCoBan FLOAT default 1500000

CREATE TABLE tblKhachHang (
iMaKH INT PRIMARY KEY,
sHoTen NVARCHAR(50) NOT NULL,
sGioiTinh BIT,
sDiaChi NVARCHAR(50) NOT NULL)

CREATE TABLE tblThuoc(
iMaThuoc INT PRIMARY KEY,
sTenThuoc NVARCHAR(50) UNIQUE,
fGia FLOAT,
dNgaySanXuat DATE,
dNgayHetHan DATE,
fSoLuong INT )

ALTER TABLE tblThuoc ADD CONSTRAINT CHECK_GIA CHECK (fGia > 0),
CONSTRAINT checkNgaySanXuat CHECK (dNgaySanXuat<GETDATE()),
CONSTRAINT checkNgayHetHan CHECK (dNgayHetHan>dNgaySanXuat)

CREATE TABLE tblHoaDon(
iSoHD INT PRIMARY KEY,
iMaNV INT ,
iMaKH INT,
dNgayLap DATE,
CONSTRAINT CheckNgayLap CHECK(dNgayLap<=GETDATE()),
FOREIGN KEY (iMaNV) REFERENCES tblNhanVien(iMaNV),
FOREIGN KEY (iMaKH) REFERENCES tblKhachHang(iMaKH))
ALTER TABLE tblHoaDon ADD fTongTien FLOAT DEFAULT 0

CREATE TABLE tblChiTietHoaDon(
iSoHD INT NOT NULL,
iMaThuoc INT NOT NULL,
fSoLuong FLOAT CHECK(fSoLuong>0),
fGia FLOAT CHECK(fGia>0))

ALTER TABLE tblChiTietHoaDon ADD CONSTRAINT pk_chitiethoadon PRIMARY KEY (iSoHD,iMaThuoc)
ALTER TABLE tblChiTietHoaDon ADD CONSTRAINT fk_chitiethoadon_soHD FOREIGN KEY (iSoHD) REFERENCES tblHoaDon(iSoHD)
ALTER TABLE tblChiTietHoaDon ADD CONSTRAINT fk_chitiethoadon_iMaThuoc FOREIGN KEY (iMaThuoc) REFERENCES tblThuoc(iMaThuoc)
ALTER TABLE tblNhanVien ADD fLuong FLOAT DEFAULT 0

/* ==== Nhập dữ liệu cho bảng ==== */
DELETE FROM tblChiTietHoaDon
DELETE FROM tblHoaDon
DELETE FROM tblThuoc
DELETE FROM tblKhachHang
DELETE FROM tblNhanVien
--Bảng nhân viên
INSERT INTO tblNhanVien(iMaNV,sHoTen,dNgaySinh,sDiaChi, fHSL,sGioiTinh, sSoDienThoai)
VALUES (001,N'Minh Anh', '2000/06/12',N'Hòa Bình', 6.2,1,'0123456789'),
	   (002,N'Đức Mạnh', '2001/10/13',N'Hải Dương', 5.6,0,'0399999999'),
	   (003,N'Quang Thắng','1998/10/19',N'Nam Định', 6,0,'0987655555'),
	   (004,N'Thúy Hiền', '2002/02/25',N'Phú Thọ', 5.8,1,'0966886688'),
	   (005,N'Anh Tuấn', '2000/10/02',N'Phú Thọ', 6.5,0,'0388616815')

	   select *from tblNhanVien
-- Bảng khách hàng
INSERT INTO tblKhachHang(iMaKH,sHoTen,sGioiTinh,sDiaChi)
VALUES (001,N'Minh Thu',1, N'Hà Nội'),
	   (002,N'Phan Hân',1, N'Hà Nội'),
	   (003,N'Ngọ Sơn',0, N'Bắc Giang'),
	   (004,N'Tất Đạt',0, N'Ninh Bình'),
	   (005,N'Ngọ Minh',0, N'Bắc Giang')

-- Bảng thuốc
INSERT INTO tblThuoc(iMaThuoc,sTenThuoc,fGia,dNgaySanXuat,dNgayHetHan,fSoLuong)
VALUES (001,N'Panadol',12000,'2022-02-15','2023-02-15',22),
	   (002,N'Thuốc Kháng Sinh',20000,'2022-08-28','2023-01-28',50),
	   (003,N'Thuốc Hạ Sốt',30000,'2022-06-08','2023-06-08',30),
	   (004,N'Thuốc Nhỏ Mắt',15000,'2022-09-21','2024-09-21',45),
	   (005,N'Nước Muối Sinh Lí',10000,'2021-09-09','2023-09-09',55),
	   (006,N'Thuốc sát trùng',50000,'2021-02-17','2023-02-17',50),
	   (007,N'Morphin',200000,'2022-06-18','2025-06-18',20),
	   (008,N'Chlorpromazin',500000,'2021-06-18','2024-06-18',27)

--Bảng Hóa Đơn
INSERT INTO tblHoaDon(iSoHD,iMaNV,iMaKH,dNgayLap)
VALUES  (001,005,003,'2022-10-18'),
		(002,003,001,'2022-10-10'),
		(003,001,004,'2022-09-21'),
		(004,002,005,'2022-09-11'),
		(005,004,002,'2022-09-06')
select * from tblHoaDon
-- Bảng chi tiết hóa đơn
DELETE FROM tblChiTietHoaDon
INSERT INTO tblChiTietHoaDon(iSoHD,iMaThuoc,fSoLuong,fGia)
VALUES (001,008,1,500000),
	   (001,006,2,50000),
	   (001,001,4,12000),
	   (002,002,2,20000),
	   (002,003,1,30000),
	   (003,004,3,15000),
	   (003,005,1,10000),
	   (004,001,2,12000),
	   (004,003,2,30000),
	   (004,007,1,200000),
	   (005,004,4,15000),
	   (005,006,1,50000)
	   SELECT * FROM tblThuoc
	
/* =====  VIEW  ====== */
--VIEW 1:Xem nhân viên có quê ở Phú Thọ

CREATE VIEW vwXemNhanVien
AS
SELECT iMaNV, sHoTen from tblNhanVien
where sDiaChi = N'Phú Thọ'

select *from vwXemNhanVien
--View 2:Tạo view xem khách hàng có giới tính là nữ 
CREATE VIEW vwGioiTinhKhachHangNu
AS
SELECT iMaKH,sHoTen from tblKhachHang
WHERE sGioiTinh = 1

SELECT *FROM vwGioiTinhKhachHangNu
--View 3:Tạo view hiện danh sách thuốc có số lượng trên 30
CREATE VIEW vwSoLuongThuocTren30
AS
SELECT iMaThuoc, sTenThuoc, fSoLuong from tblThuoc
WHERE fSoLuong > 30

select *from vwSoLuongThuocTren30
--View 4: Tạo view xem hóa đơn được lập vào tháng 09 năm 2022

CREATE VIEW vwHoaDonLapVao_09_2022
AS
SELECT iSoHD, iMaNV, iMaKH, dNgayLap from tblHoaDon
WHERE YEAR(dNgayLap)= 2022 and MONTH(dNgaylap) = 09

select *from vwHoaDonLapVao_09_2022
--View 5: Tạo view xem tổng số lượng thuốc đã bán
CREATE VIEW vwTongSoLuongThuocDaBan
AS
SELECT sum(fSoLuong) N'Tổng' from tblChiTietHoaDon

select *from vwTongSoLuongThuocDaBan
--View 6:Tạo view xem tổng số hóa đơn được lập bởi từng nhân viên

CREATE VIEW vwTongHoaDonDaLapCuaTungNV
AS
SELECT  tblNhanVien.iMaNV , count(iSoHD)  N'Tổng Hóa Đơn' 
FROM tblNhanVien join tblHoaDon 
ON tblNhanVien.iMaNV = tblHoaDon.iMaNV 
GROUP BY tblNhanVien.iMaNV

SELECT * FROM vwTongHoaDonDaLapCuaTungNV

--View 7:Tạo view xem số lượng thuốc đã bán và tổng tiền thu được theo của từng loại thuốc
CREATE VIEW vwSoLuongBan_TongTienThuoc
AS
SELECT tblThuoc.iMaThuoc,sTenThuoc,ISNULL(sum(tblChiTietHoaDon.fSoLuong),0) AS SoLuongDaBan ,
ISNULL(sum(tblChiTietHoaDon.fSoLuong* tblChiTietHoaDon.fGia),0) AS TongTien FROM tblThuoc
LEFT JOIN tblChiTietHoaDon ON tblChiTietHoaDon.iMaThuoc=tblThuoc.iMaThuoc
GROUP BY tblThuoc.iMaThuoc,sTenThuoc

select *from vwSoLuongBan_TongTienThuoc

--View 8:Tạo view cho biết tổng tiền hàng đã bán được của từng nhân viên năm 2022
CREATE OR ALTER VIEW vwTongTienBanCuaNhanVienNam2022
as
SELECT tblNhanVien.iMaNV, tblNhanVien.sHoTen , 
sum(tblChiTietHoaDon.fGia * tblChiTietHoaDon.fSoLuong) N'Tổng Tiền'
from tblNhanVien join tblHoaDon on tblNhanVien.iMaNV = tblHoaDon.iMaNV
					join tblChiTietHoaDon on tblHoaDon.iSoHD = tblChiTietHoaDon.iSoHD
	WHERE YEAR( tblHoaDon.dNgayLap) = 2022
GROUP BY tblNhanVien.iMaNV, tblNhanVien.sHoTen
	select *from vwTongTienBanCuaNhanVienNam2022

--View 9:Tạo view cho biết tên từng khách hàng và số loại thuốc đã mua
CREATE VIEW vwTenKH_SoThuocMua
as
SELECT tblKhachHang.sHoTen, count( tblChiTietHoaDon.iMaThuoc) N'Số Lượng'
from tblKhachHang , tblHoaDon, tblChiTietHoaDon
WHERE tblKhachHang.iMaKH  = tblHoaDon.iMaKH
		and tblHoaDon.iSoHD = tblChiTietHoaDon.iSoHD
GROUP BY tblKhachHang.sHoTen

select *from vwTenKH_SoThuocMua

--View 10: Tạo view cho biết tổng tiền đã bán vào tháng 10 năm 2022
DROP VIEW vwTongTienBanThang10Nam2022
CREATE VIEW vwTongTienBanThang10Nam2022
AS
SELECT sum(tblChiTietHoaDon.fSoLuong * tblChiTietHoaDon.fGia) N'Tổng Tiền'
FROM tblChiTietHoaDon join  tblHoaDon on tblChiTietHoaDon.iSoHD = tblHoaDon.iSoHD
WHERE YEAR(tblHoaDon.dNgayLap) = 2022 and MONTH( tblHoaDon.dNgayLap) = 10

SELECT * FROM vwTongTienBanThang10Nam2022

/* =====  PROCEDURE  ====== */
	
--PROC 1:Tạo procedure hiện ra những nhân viên có năm sinh là tham số truyền vào
CREATE PROC pcHienNhanVienVsNamSinh
@iNamSinh INT
AS
BEGIN
	SELECT * FROM tblNhanVien
	WHERE Year(tblNhanVien.dNgaySinh) = @iNamSinh 
END

pcHienNhanVienVsNamSinh @iNamSinh = 2000

--PROC 2: Tạo procedure với tham số chuyền vào là mã thuốc ,thống kê số lượng thuốc đã bán được theo mã thuốc chuyền vào
CREATE PROC pcThuocDaBan
@iMaThuoc int
AS
BEGIN
	SELECT tblThuoc.iMaThuoc , tblThuoc.sTenThuoc, sum(tblChiTietHoaDon.fSoLuong) as [Số Lượng]
	FROM tblThuoc, tblChiTietHoaDon
	WHERE tblThuoc.iMaThuoc = @iMaThuoc
	AND tblThuoc.iMaThuoc = tblChiTietHoaDon.iMaThuoc
	GROUP BY tblThuoc.iMaThuoc , tblThuoc.sTenThuoc
END

EXEC pcThuocDaBan @iMaThuoc = 1

--PROC 3: Tạo procedure để thêm một bản ghi mới cho tblHoaDon(kiểm tra tính hợp lệ dữ liệu bổ xung)
CREATE OR ALTER PROC pcADDtblHoaDon
@iSoHD int,
@iMaNV int,
@iMaKH int,
@dNgayLap DATE
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM tblNhanVien WHERE iMaNV=@iMaNV) 
		PRINT N'Mã Nhân Viên Không Tồn Tại'
	ELSE IF NOT EXISTS (SELECT * FROM tblKhachHang WHERE iMaKH=@iMaKH)
		PRINT N'Mã Khách Hàng Không Tồn Tại'
	ELSE IF EXISTS (SELECT * FROM tblHoaDon WHERE iSoHD=@iSoHD)
		PRINT N'Mã hóa đơn đã tồn tại'
	ELSE
		BEGIN 
			INSERT INTO tblHoaDon(iSoHD,iMaNV,iMaKH,dNgayLap)
			VALUES (@iSoHD,@iMaNV,@iMaKH,@dNgayLap)
		END
END

--PROC 4:Tạo procedure thực hiện tăng lương cơ bản của nhân viên lên gấp đôi cho nhưng nhân viên bán được số lượng hóa đơn nhiều hơn số lượng hóa đơn chuyền vào
CREATE PROC pcTangLuongNhanVien(@iSLHD int)
AS
BEGIN
	SELECT * FROM tblNhanVien
	update tblNhanVien
	SET  fLuongCoBan = fLuongCoBan*2
	WHERE tblNhanVien.iMaNV in
		(SELECT tblNhanVien.iMaNV
		FROM tblNhanVien, tblHoaDon
		WHERE 
		 tblNhanVien.iMaNV = tblHoaDon.iMaNV
		 GROUP BY tblNhanVien.iMaNV
		 HAVING count(tblHoaDon.iSoHD) > @iSLHD)
	SELECT * FROM tblNhanVien
END

EXEC pcTangLuongNhanVien 0

--PROC 5:Tạo procedure xóa đi những loại thuốc đã quá hạn sử dụng.

CREATE PROC pcXoaThuoc
AS
BEGIN
	SELECT * FROM tblThuoc
	DELETE FROM tblThuoc
	WHERE tblThuoc.dNgayHetHan <= getdate()
	SELECT * FROM tblThuoc
END
INSERT INTO tblThuoc
VALUES (15,'thuoc a', 20000, '20191211', '20191224', 5)
/* =====  Trigger  ====== */

SELECT * FROM tblNhanVien
select * FROM tblHoaDon
--Trigger 1:Tạo Trigger khi thêm 1 nhân viên thì cột lương sẽ được tính băng hệ số lương * lương cơ bản
CREATE OR ALTER TRIGGER tinhLuongNhanVien
ON tblNhanVien
AFTER INSERT
AS
BEGIN
	UPDATE tblNhanVien
	SET fLuong=fLuongCoBan*fHSL
END
SELECT * FROM tblHoaDon
SELECT * FROM tblChiTietHoaDon
--Trigger 2:Tạo Trigger sao cho giá trị của cột fTongTien của bảng tblHoaDon tự động tăng mỗi khi bổ sung thêm 1 bản ghi của tblChiTietHoaDon
DROP TRIGGER tinhTongTienHoaDon
CREATE OR ALTER TRIGGER tinhTongTienHoaDon
ON tblChiTietHoaDon
AFTER INSERT
AS 
BEGIN
	UPDATE tblHoaDon
	SET fTongTien+=B.ThanhTien
	FROM tblHoaDon
	JOIN(SELECT iSoHD,SUM(fSoLuong*fGia) AS ThanhTien FROM inserted
			GROUP BY iSoHD) AS B ON tblHoaDon.iSoHD=B.iSoHD
END
SELECT * FROM tblHoaDon
SELECT * FROM tblChiTietHoaDon
INSERT INTO tblChiTietHoaDon
VALUES (2,2,2,100000)
SELECT * FROM tblThuoc
DELETE FROM tblChiTietHoaDon
WHERE iSoHD=5

SELECT * FROM tblChiTietHoaDon
--Trigger 3: Tạo trigger sao cho giá trị của số lượng thuốc của bảng thuốc giảm mỗi khi có thêm 1 bản ghi của tblChiTietHoaDon 
CREATE OR ALTER TRIGGER soLuongThuoc
ON tblChiTietHoaDon
AFTER INSERT
AS 
BEGIN
	UPDATE tblThuoc
	SET fSoLuong=fSoLuong-C.SoLuongDaBan
	FROM tblThuoc
	JOIN (SELECT iMaThuoc,SUM(inserted.fSoLuong) AS SoLuongDaBan FROM inserted 
			GROUP BY iMaThuoc) AS C ON tblThuoc.iMaThuoc=C.iMaThuoc
END

--Trigger 4: Tạo trigger khi xóa 1 khách hàng thì hóa đơn và chi tiết hóa đơn của khách hàng đó cũng sẽ bị xóa theo
select * from tblKhachHang
CREATE OR ALTER TRIGGER xoaKhachHang
ON tblKhachHang
INSTEAD OF DELETE
AS
BEGIN
		DECLARE @iMaKH INT=(SELECT iMaKH FROM deleted)
		DECLARE @iSoHD INT=(SELECT iSoHD FROM tblHoaDon WHERE iMaKH=@iMaKH)
		DELETE FROM tblChiTietHoaDon
		WHERE iSoHD=@iSoHD
		DELETE FROM tblHoaDon
		WHERE iMaKH=@iMaKH
		DELETE FROM tblKhachHang
		WHERE iMaKH=@iMaKH
END
delete from tblKhachHang
where iMaKH=1
select * from tblKhachHang
select * from tblHoaDon
select * from tblChiTietHoaDon
--Trigger 5:Tạo trigger đảm bảo số lượng bán thuốc ra không lớn hơn số thuốc có trong bảng thuốc

CREATE OR ALTER TRIGGER checkSoLuongg
ON tblChiTietHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
		IF EXISTS (SELECT * FROM inserted
		JOIN tblThuoc ON tblThuoc.iMaThuoc=inserted.iMaThuoc
		WHERE inserted.fSoLuong>tblThuoc.fSoLuong)
			BEGIN 
				PRINT N'Số lượng thuốc không đủ để bán'
				ROLLBACK TRANSACTION
			END

END
SELECT * FROM tblChiTietHoaDon
SELECT * FROM tblThuoc
DELETE FROM tblChiTietHoaDon
WHERE fGia=11111
INSERT INTO tblChiTietHoaDon
VALUES(1,38,55,11111)



--phân cấp--
CREATE LOGIN nhom17SQL
WITH PASSWORD ='1234'

CREATE USER u17
FOR LOGIN nhom17SQL

CREATE LOGIN buianhtuan
WITH PASSWORD = '1234'

CREATE USER buianhtuan
FOR LOGIN buianhtuan

CREATE LOGIN nguyenducmanh
WITH PASSWORD = '1234'

CREATE USER nguyenducmanh
FOR LOGIN nguyenducmanh
GO 

CREATE LOGIN phamquangthang
WITH PASSWORD = '1234'

CREATE USER phamquangthang
FOR LOGIN phamquangthang

select * from tblNhanVien
select * from tblKhachHang
--phân quyền--
-- cấp quyền cho u17 quyền truy vấn, thêm, sửa, xóa trong bảng ChiTietDonNhap
GRANT INSERT ,SELECT ,DELETE,UPDATE
ON tblHoaDon
TO u17

-- cấp quyền cho buianhtuan toàn quyền sử dụng bảng nhân viên
GRANT ALL PRIVILEGES
ON dbo.tblNhanVien
TO buianhtuan

-- cấp quyền cho nguyenducmanh quyền truy vấn, thêm, sửa, xóa trong bảng khách hàng
GRANT INSERT,UPDATE,DELETE,SELECT
ON dbo.tblKhachHang
TO nguyenducmanh

-- cấp quyền cho phamquangthang quyền truy vấn, thêm, sửa, xóa  trong bảng tblThuoc
GRANT INSERT,UPDATE,DELETE,SELECT
ON tblThuoc
TO phamquangthang

--Phân tán
EXEC sp_linkedservers
CREATE TABLE AKhachHang(
iMaKH INT PRIMARY KEY,
sHoTen NVARCHAR(50) NOT NULL,
sGioiTinh BIT,
sDiaChi NVARCHAR(50) NOT NULL)

--SERVER1:
INSERT INTO dbo.AKhachHang
SELECT * FROM tblKhachHang WHERE sGioiTinh=1
--đặt tên cho server2
CREATE SYNONYM dbo.BKhachHang FOR LINKA.quanLiKinhdoanhCuaHangThuoc.dbo.BKhachHang
--SERVER 2:
INSERT INTO dbo.BKhachHang
SELECT * FROM tblKhachHang WHERE sGioiTinh=0

select * from dbo.BKhachHang





--câu 1
CREATE or alter VIEW xemToanBoKhachHangSAPxEP
AS
	SELECT * FROM dbo.AKhachHang
	 union
	SELECT * FROM dbo.BKhachHang

	select * from xemToanBoKhachHangSAPxEP order by sHoTen asc


	create table THI(
	sTenMon NVARCHAR(10) NOT NULL,
	sMasv int NOT NULL,
	dNgayThi DATE NOT NULL,
	KETQUA FLOAT)
	ALTER TABLE THI ADD CONSTRAINT FK_KHOA PRIMARY KEY(sTenMon,sMasv,dNgayThi)

	INSERT INTO THI
	VALUES('sql',1,'2022-12-16',9),
	('WEB',2,'2022-12-16',8),
	('sql',2,'2022-12-16',7),
	('CTDL',3,'2022-12-16',9),
	('sql',4,'2022-12-16',8.5)
	SELECT * FROM THI


CREATE or alter TRIGGER CHECKTHI
ON THI
AFTER INSERT ,UPDATE
AS 
BEGIN
	DECLARE @maSV INT,@ngayLap DATE,@soLanThi int
	SELECT @maSV=sMasv ,@ngayLap=dNgayThi FROM inserted
	SET @soLanThi =(SELECT COUNT(sMasv) FROM THI
	WHERE @maSV=sMasv AND @ngayLap=dNgayThi
	GROUP BY sMasv)
	
    IF(UPDATE(sMasv)AND UPDATE(dNgayThi)) 
		BEGIN
			IF(@soLanThi>2)
				BEGIN
				    PRINT N'Sinh viên không được thi quá 2 môn 1 hôm'
					ROLLBACK TRAN
				END
		END
END
--test câu 2

delete from THI
where sMasv=5
select * from THI
INSERT INTO THI
	VALUES
	('as',5,'2022-12-16',8)

	--câu 3:
	create proc cau3
	@thang int,
	@nam int
	as
	begin
		select sTenMon ,count(sMasv) as [số lượng thí sinh] FROM THI
		WHERE MONTH(dNgayThi)=@thang and YEAR(dNgayThi)=@nam
		group by sTenMon
	end
	cau3 @thang=11,@nam=2022

	ALTER TABLE dbo.tblNhanVien ADD iTSHDDaLap  INT DEFAULT(0) WITH VALUES

--cập nhật dữ liệu theo dữ liệu cũ
CREATE VIEW vwTongHoaDonDaLapCuaTungNV
AS
SELECT  tblNhanVien.iMaNV , count(iSoHD)  N'Tổng Hóa Đơn' 
FROM tblNhanVien join tblHoaDon 
ON tblNhanVien.iMaNV = tblHoaDon.iMaNV 
GROUP BY tblNhanVien.iMaNV


SELECT *FROM vwTongHoaDonDaLapCuaTungNV
UPDATE dbo.tblNhanVien SET iTSHDDaLap = DALAP.[Tổng Hóa Đơn]
FROM dbo.vwTongHoaDonDaLapCuaTungNV DALAP
WHERE tblNhanVien.iMaNV=DALAP.iMaNV

SELECT *FROM dbo.tblNhanVien