﻿-- Chay lenh tao CSDL truoc
CREATE DATABASE QuanLyBanHang
GO
-- Refesh lai CSDL moi lam tiep cac lenh sau
USE QuanLyBanHang
GO

--I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):
--1. Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ.
CREATE TABLE KHACHHANG (
	MAKH char(4),
	HOTEN varchar(40),
	DCHI varchar(50),
	SODT varchar(20),
	NGSINH smalldatetime,
	NGDK smalldatetime,
	DOANHSO money,
	CONSTRAINT PK_KHACHHANG PRIMARY KEY(MAKH),
);

CREATE TABLE NHANVIEN (
	MANV char(4),
	HOTEN varchar(40),
	SODT varchar(20),
	NGVL smalldatetime,
	CONSTRAINT PK_NHANVIEN PRIMARY KEY(MANV),
);

CREATE TABLE SANPHAM (
	MASP char(4),
	TENSP varchar(40),
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money,
	CONSTRAINT PK_SANPHAM PRIMARY KEY(MASP),
);

CREATE TABLE HOADON (
	SOHD int,
	NGHD smalldatetime,
	MAKH char(4),
	MANV char(4),
	TRIGIA money,
	CONSTRAINT PK_HOADON PRIMARY KEY(SOHD),
);

CREATE TABLE CTHD (
	SOHD int,
	MASP char(4),
	SL int,
	CONSTRAINT PK_CTHD PRIMARY KEY(SOHD, MASP),
);

ALTER TABLE HOADON ADD CONSTRAINT FK01_HD FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH);
ALTER TABLE HOADON ADD CONSTRAINT FK02_HD FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV);

ALTER TABLE CTHD ADD CONSTRAINT FK01_CTHD FOREIGN KEY(SOHD) REFERENCES HOADON(SOHD);
ALTER TABLE CTHD ADD CONSTRAINT FK02_CTHD FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP);

set dateformat dmy;

--2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM ADD GHICHU varchar(20);

--3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG ADD LOAIKH tinyint;

--4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM ALTER COLUMN GHICHU varchar(100);

--5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM DROP COLUMN GHICHU;

--6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị
--là: “Vang lai”, “Thuong xuyen”, “Vip”, ... (Câu này sai đề)
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHECK_LOAIKH CHECK (LOAIKH IN ('Vang lai', 'Thuong xuyen', 'Vip'));

--7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM 
ADD CONSTRAINT CHECK_DVT CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'));

--8. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM 
ADD CONSTRAINT CHECK_GIA CHECK (GIA >= 500);

--9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD
ADD CONSTRAINT CHECK_SL CHECK (SL >= 1);

--10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người
--đó.
ALTER TABLE KHACHHANG 
ADD CONSTRAINT CHECK_NGDK CHECK (NGDK > NGSINH);

--11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày
--khách hàng đó đăng ký thành viên (NGDK).


--12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó
--vào làm.


--13. Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.


--14. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa
--đơn đó.


--15. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó
--đã mua.


--II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):
--1. Nhập dữ liệu cho các quan hệ trên.

-- KHACHHANG
INSERT INTO KHACHHANG VALUES('KH01','Nguyen Van A','731 Tran Hung Dao, Q5, TpHCM','8823451','22/10/1960','22/07/2006',13060000);
INSERT INTO KHACHHANG VALUES('KH02','Tran Ngoc Han','23/5 Nguyen Trai, Q5, TpHCM','908256478','03/04/1974','30/07/2006',280000);
INSERT INTO KHACHHANG VALUES('KH03','Tran Ngoc Linh','45 Nguyen Canh Chan, Q1, TpHCM','938776266','12/06/1980','08/05/2006',3860000);
INSERT INTO KHACHHANG VALUES('KH04','Tran Minh Long','50/34 Le Dai Hanh, Q10, TpHCM','917325476','09/03/1965','10/02/2006',250000);
INSERT INTO KHACHHANG VALUES('KH05','Le Nhat Minh','34 Truong Dinh, Q3, TpHCM','8246108','10/03/1950','28/10/2006',21000);
INSERT INTO KHACHHANG VALUES('KH06','Le Hoai Thuong','227 Nguyen Van Cu, Q5, TpHCM','8631738','31/12/1981','24/11/2006',915000);
INSERT INTO KHACHHANG VALUES('KH07','Nguyen Van Tam','32/3 Tran Binh Trong, Q5, TpHCM','916783565','06/04/1971','12/01/2006',12500);
INSERT INTO KHACHHANG VALUES('KH08','Phan Thi Thanh','45/2 An Duong Vuong, Q5, TpHCM','938435756','10/01/1971','13/12/2006',365000);
INSERT INTO KHACHHANG VALUES('KH09','Le Ha Vinh','873 Le Hong Phong, Q5, TpHCM','8654763','03/09/1979','14/01/2007',70000);
INSERT INTO KHACHHANG VALUES('KH10','Ha Duy Lap','34/34B Nguyen Trai, Q1, TpHCM','8768904','02/05/1983','16/01/2007',67500);

-- NHANVIEN
INSERT INTO NHANVIEN VALUES('NV01','Nguyen Nhu Nhut','927345678','13/04/2006');
INSERT INTO NHANVIEN VALUES('NV02','Le Thi Phi Yen','987567390','21/04/2006');
INSERT INTO NHANVIEN VALUES('NV03','Nguyen Van B','997047382','27/04/2006');
INSERT INTO NHANVIEN VALUES('NV04','Ngo Thanh Tuan','913758498','24/06/2006');
INSERT INTO NHANVIEN VALUES('NV05','Nguyen Thi Truc Thanh','918590387','20/07/2006');

-- SANPHAM
INSERT INTO SANPHAM VALUES('BC01','But chi','cay','Singapore',3000);
INSERT INTO SANPHAM VALUES('BC02','But chi','cay','Singapore',5000);
INSERT INTO SANPHAM VALUES('BC03','But chi','cay','Viet Nam',3500);
INSERT INTO SANPHAM VALUES('BC04','But chi','hop','Viet Nam',30000);
INSERT INTO SANPHAM VALUES('BB01','But bi','cay','Viet Nam',5000);
INSERT INTO SANPHAM VALUES('BB02','But bi','cay','Trung Quoc',7000);
INSERT INTO SANPHAM VALUES('BB03','But bi','hop','Thai Lan',100000);
INSERT INTO SANPHAM VALUES('TV01','Tap 100 giay mong','quyen','Trung Quoc',2500);
INSERT INTO SANPHAM VALUES('TV02','Tap 200 giay mong','quyen','Trung Quoc',4500);
INSERT INTO SANPHAM VALUES('TV03','Tap 100 giay tot','quyen','Viet Nam',3000);
INSERT INTO SANPHAM VALUES('TV04','Tap 200 giay tot','quyen','Viet Nam',5500);
INSERT INTO SANPHAM VALUES('TV05','Tap 100 trang','chuc','Viet Nam',23000);
INSERT INTO SANPHAM VALUES('TV06','Tap 200 trang','chuc','Viet Nam',53000);
INSERT INTO SANPHAM VALUES('TV07','Tap 100 trang','chuc','Trung Quoc',34000)
INSERT INTO SANPHAM VALUES('ST01','So tay 500 trang','quyen','Trung Quoc',40000);
INSERT INTO SANPHAM VALUES('ST02','So tay loai 1','quyen','Viet Nam',55000);
INSERT INTO SANPHAM VALUES('ST03','So tay loai 2','quyen','Viet Nam',51000);
INSERT INTO SANPHAM VALUES('ST04','So tay','quyen','Thai Lan',55000);
INSERT INTO SANPHAM VALUES('ST05','So tay mong','quyen','Thai Lan',20000);
INSERT INTO SANPHAM VALUES('ST06','Phan viet bang','hop','Viet Nam',5000);
INSERT INTO SANPHAM VALUES('ST07','Phan khong bui','hop','Viet Nam',7000);
INSERT INTO SANPHAM VALUES('ST08','Bong bang','cai','Viet Nam',1000);
INSERT INTO SANPHAM VALUES('ST09','But long','cay','Viet Nam',5000);
INSERT INTO SANPHAM VALUES('ST10','But long','cay','Trung Quoc',7000);

-- HOADON
INSERT INTO HOADON VALUES(1001,'23/07/2006','KH01','NV01',320000);
INSERT INTO HOADON VALUES(1002,'12/08/2006','KH01','NV02',840000);
INSERT INTO HOADON VALUES(1003,'23/08/2006','KH02','NV01',100000);
INSERT INTO HOADON VALUES(1004,'01/09/2006','KH02','NV01',180000);
INSERT INTO HOADON VALUES(1005,'20/10/2006','KH01','NV02',3800000);
INSERT INTO HOADON VALUES(1006,'16/10/2006','KH01','NV03',2430000);
INSERT INTO HOADON VALUES(1007,'28/10/2006','KH03','NV03',510000);
INSERT INTO HOADON VALUES(1008,'28/10/2006','KH01','NV03',440000);
INSERT INTO HOADON VALUES(1009,'28/10/2006','KH03','NV04',200000);
INSERT INTO HOADON VALUES(1010,'01/11/2006','KH01','NV01',5200000);
INSERT INTO HOADON VALUES(1011,'04/11/2006','KH04','NV03',250000);
INSERT INTO HOADON VALUES(1012,'30/11/2006','KH05','NV03',21000);
INSERT INTO HOADON VALUES(1013,'12/12/2006','KH06','NV01',5000);
INSERT INTO HOADON VALUES(1014,'31/12/2006','KH03','NV02',3150000);
INSERT INTO HOADON VALUES(1015,'01/01/2007','KH06','NV01',910000);
INSERT INTO HOADON VALUES(1016,'01/01/2007','KH07','NV02',12500);
INSERT INTO HOADON VALUES(1017,'02/01/2007','KH08','NV03',35000);
INSERT INTO HOADON VALUES(1018,'13/01/2007','KH08','NV03',330000);
INSERT INTO HOADON VALUES(1019,'13/01/2007','KH01','NV03',30000);
INSERT INTO HOADON VALUES(1020,'14/01/2007','KH09','NV04',70000);
INSERT INTO HOADON VALUES(1021,'16/01/2007','KH10','NV03',67500);
INSERT INTO HOADON VALUES(1022,'16/01/2007',Null,'NV03',7000);
INSERT INTO HOADON VALUES(1023,'17/01/2007',Null,'NV01',330000);

-- CTHD
INSERT INTO CTHD VALUES(1001,'TV02',10);
INSERT INTO CTHD VALUES(1001,'ST01',5);
INSERT INTO CTHD VALUES(1001,'BC01',5);
INSERT INTO CTHD VALUES(1001,'BC02',10);
INSERT INTO CTHD VALUES(1001,'ST08',10);
INSERT INTO CTHD VALUES(1002,'BC04',20);
INSERT INTO CTHD VALUES(1002,'BB01',20);
INSERT INTO CTHD VALUES(1002,'BB02',20);
INSERT INTO CTHD VALUES(1003,'BB03',10);
INSERT INTO CTHD VALUES(1004,'TV01',20);
INSERT INTO CTHD VALUES(1004,'TV02',10);
INSERT INTO CTHD VALUES(1004,'TV03',10);
INSERT INTO CTHD VALUES(1004,'TV04',10);
INSERT INTO CTHD VALUES(1005,'TV05',50);
INSERT INTO CTHD VALUES(1005,'TV06',50);
INSERT INTO CTHD VALUES(1006,'TV07',20);
INSERT INTO CTHD VALUES(1006,'ST01',30);
INSERT INTO CTHD VALUES(1006,'ST02',10);
INSERT INTO CTHD VALUES(1007,'ST03',10);
INSERT INTO CTHD VALUES(1008,'ST04',8);
INSERT INTO CTHD VALUES(1009,'ST05',10);
INSERT INTO CTHD VALUES(1010,'TV07',50);
INSERT INTO CTHD VALUES(1010,'ST07',50);;
INSERT INTO CTHD VALUES(1010,'ST08',100);
INSERT INTO CTHD VALUES(1010,'ST04',50);
INSERT INTO CTHD VALUES(1010,'TV03',100);
INSERT INTO CTHD VALUES(1011,'ST06',50);
INSERT INTO CTHD VALUES(1012,'ST07',3);
INSERT INTO CTHD VALUES(1013,'ST08',5);
INSERT INTO CTHD VALUES(1014,'BC02',80);
INSERT INTO CTHD VALUES(1014,'BB02',100);
INSERT INTO CTHD VALUES(1014,'BC04',60);
INSERT INTO CTHD VALUES(1014,'BB01',50);
INSERT INTO CTHD VALUES(1015,'BB02',30);
INSERT INTO CTHD VALUES(1015,'BB03',7);
INSERT INTO CTHD VALUES(1016,'TV01',5);
INSERT INTO CTHD VALUES(1017,'TV02',1);
INSERT INTO CTHD VALUES(1017,'TV03',1);
INSERT INTO CTHD VALUES(1017,'TV04',5);
INSERT INTO CTHD VALUES(1018,'ST04',6);
INSERT INTO CTHD VALUES(1019,'ST05',1);
INSERT INTO CTHD VALUES(1019,'ST06',2);
INSERT INTO CTHD VALUES(1020,'ST07',10);
INSERT INTO CTHD VALUES(1021,'ST08',5);
INSERT INTO CTHD VALUES(1021,'TV01',7);
INSERT INTO CTHD VALUES(1021,'TV02',10);
INSERT INTO CTHD VALUES(1022,'ST07',1);
INSERT INTO CTHD VALUES(1023,'ST04',6);

SELECT * FROM KHACHHANG;
SELECT * FROM NHANVIEN;
SELECT * FROM SANPHAM;
SELECT * FROM HOADON;
SELECT * FROM CTHD;

--2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ
--KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
CREATE TABLE SANPHAM1 (
	MASP	char(4),
	TENSP	varchar(40),
	DVT	varchar(20),
	NUOCSX	varchar(40),
	GIA	money,
	constraint PK_SANPHAM1 primary key(MASP)
);

CREATE TABLE KHACHHANG1 (
	MAKH	char(4),	
	HOTEN	varchar(40),
	DCHI	varchar(50),
	SODT	varchar(20),
	NGSINH	smalldatetime,
	NGDK	smalldatetime,
	DOANHSO	money,
	constraint PK_KHACHHANG1 primary key(MAKH)
);

INSERT INTO SANPHAM1 SELECT * FROM SANPHAM;
SELECT * FROM SANPHAM1;

INSERT INTO KHACHHANG1 SELECT * FROM KHACHHANG;
SELECT * FROM KHACHHANG1;

--3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ
--SANPHAM1)
UPDATE SANPHAM1 SET GIA = GIA / 1.05 WHERE NUOCSX = 'Thai Lan';
SELECT * FROM SANPHAM1;

--4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ
--10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1 SET GIA = GIA * 0.95 WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000;
SELECT * FROM SANPHAM1;

--5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước
--ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ
--1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
ALTER TABLE KHACHHANG1 ADD LOAIKH varchar(10);
UPDATE KHACHHANG1 SET LOAIKH = 'VIP' WHERE (NGDK < '1/1/2007' AND DOANHSO >= 10000000) OR (NGDK > '1/1/2007' AND DOANHSO >= 2000000);
SELECT *FROM KHACHHANG1;

--III. Ngôn ngữ truy vấn dữ liệu:
--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc';

--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.

--Cách 1:
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE DVT IN ('cay', 'quyen');
--Cách 2:
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE DVT = 'cay' OR DVT = 'quyen';

--3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết
--thúc là “01”.
SELECT MASP, TENSP 
FROM SANPHAM
WHERE MASP LIKE 'B%01';

--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000
--đến 40.000.

--Cách 1:
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE (NUOCSX = 'Trung Quoc') AND (GIA BETWEEN 30000 AND 40000);
--Cách 2:
SELECT MASP,TENSP 
FROM SANPHAM 
WHERE NUOCSX = 'TRUNG QUOC'
INTERSECT 
SELECT MASP,TENSP 
FROM SANPHAM 
WHERE GIA BETWEEN 30000 AND 40000;

--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản
--xuất có giá từ 30.000 đến 40.000.

--Cách 1:
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND (GIA BETWEEN 30000 AND 40000);
--Cách 2:
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan'
INTERSECT 
SELECT MASP, TENSP FROM SANPHAM WHERE GIA BETWEEN 30000 AND 40000;

--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE NGHD = '1/1/2007' OR NGHD = '2/1/2007';

--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và
--trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE MONTH(NGHD)= 1 AND YEAR(NGHD) = 2007 
ORDER BY DAY(NGHD) ASC,TRIGIA DESC;

--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT KHACHHANG.MAKH, HOTEN 
FROM KHACHHANG, HOADON 
WHERE KHACHHANG.MAKH = HOADON.MAKH and HOADON.NGHD = '1/1/2007'

--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày
--28/10/2006.
SELECT HOADON.SOHD, TRIGIA 
FROM HOADON, NHANVIEN 
WHERE HOADON.MANV = NHANVIEN.MANV AND NHANVIEN.HOTEN = 'Nguyen Van B' AND NGHD = '28/10/2006';

--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A”
--mua trong tháng 10/2006.
SELECT SANPHAM.MASP, TENSP 
FROM SANPHAM INNER JOIN CTHD
ON SANPHAM.MASP = CTHD.MASP
WHERE EXISTS (SELECT *
			  FROM CTHD INNER JOIN HOADON
			  ON CTHD.SOHD = HOADON.SOHD
			  AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
			  AND MAKH IN (SELECT HOADON.MAKH
						   FROM HOADON INNER JOIN KHACHHANG
						   ON HOADON.MAKH = KHACHHANG.MAKH
						   WHERE HOTEN = 'Nguyen Van A') 
			  AND SANPHAM.MASP = CTHD.MASP);

--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.

--Cách 1:
SELECT SOHD
FROM CTHD
WHERE MASP IN ('BB01', 'BB02');
--Cách 2:
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01' OR MASP = 'BB02';

--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm
--mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE (MASP IN ('BB01', 'BB02')) AND (SL BETWEEN 10 AND 20);

--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản
--phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD FROM CTHD WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT SOHD FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20;

--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản
--phẩm được bán ra trong ngày 1/1/2007.
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT SANPHAM.MASP, TENSP FROM CTHD, HOADON, SANPHAM WHERE CTHD.SOHD = HOADON.SOHD AND NGHD = '1/1/2017';

--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.

--Cách 1 dùng NOT IN:
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM
WHERE SANPHAM.MASP NOT IN(SELECT SANPHAM.MASP
						  FROM SANPHAM SP INNER JOIN CTHD
						  ON SP.MASP = CTHD.MASP
						  AND SP.MASP = SANPHAM.MASP);
--Cách 2 dùng NOT EXISTS:
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NOT EXISTS (SELECT * 
				  FROM SANPHAM S INNER JOIN CTHD
				  ON S.MASP = CTHD.MASP
				  AND S.MASP = SANPHAM.MASP);

--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.

--Cách 1 dùng NOT IN:
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM
WHERE SANPHAM.MASP NOT IN (SELECT CTHD.MASP 
				  FROM CTHD INNER JOIN HOADON
				  ON CTHD.SOHD = HOADON.SOHD
				  WHERE YEAR(NGHD) = 2006);
--Cách 2 dùng NOT EXISTS:
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM INNER JOIN CTHD 
ON SANPHAM.MASP = CTHD.MASP
WHERE NOT EXISTS (SELECT *
				  FROM CTHD INNER JOIN HOADON
				  ON CTHD.SOHD = HOADON.SOHD
				  WHERE YEAR(NGHD) = 2006 AND CTHD.MASP = SANPHAM.MASP);

--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán
--được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND NOT EXISTS (SELECT MASP 
											FROM HOADON, CTHD 
											WHERE SANPHAM.MASP = CTHD.MASP 
											AND HOADON.SOHD = CTHD.SOHD 
											AND YEAR(NGHD) = 2006);

--18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT SOHD
FROM HOADON
WHERE NOT EXISTS(SELECT * 
				 FROM SANPHAM
				 WHERE NUOCSX = 'Singapore'
				 AND NOT EXISTS(SELECT * 
								FROM CTHD
								WHERE CTHD.SOHD = HOADON.SOHD
								AND CTHD.MASP = SANPHAM.MASP));

--19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản
--xuất.
SELECT SOHD
FROM HOADON
WHERE YEAR(NGHD) = 2006 AND NOT EXISTS (SELECT * 
										FROM SANPHAM 
										WHERE NUOCSX = 'Singapore' 
										AND NOT EXISTS (SELECT * 
														FROM CTHD
														WHERE CTHD.SOHD = HOADON.SOHD AND CTHD.MASP = SANPHAM.MASP));


--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(SOHD) 'TongHD khong DK TV'
FROM HOADON
WHERE MAKH IS NULL;

--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP) 'So SP ban trong 2006'
FROM CTHD, HOADON
WHERE CTHD.SOHD = HOADON.SOHD AND YEAR(NGHD) = 2006;

--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) 'MAX', MIN(TRIGIA) 'MIN'
FROM HOADON;

--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) 'TRI GIA TRUNG BINH'
FROM HOADON
WHERE YEAR(NGHD) = 2006;

--24. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) 'TONG DOANH THU'
FROM HOADON
WHERE YEAR(NGHD) = 2006;

--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE TRIGIA = (SELECT MAX(TRIGIA)
			    FROM HOADON
			    WHERE YEAR(NGHD) = 2006);

--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG JOIN HOADON
ON KHACHHANG.MAKH = HOADON.MAKH
WHERE TRIGIA = (SELECT MAX(TRIGIA)
				FROM HOADON
				WHERE YEAR(NGHD) = 2006);

--27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm
--dần. TOP N [PERCENT] [WITH TIES]
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC;

--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao
--nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (SELECT DISTINCT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC);

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1
--trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'THAI LAN' AND GIA IN (SELECT DISTINCT TOP 3 GIA 
									  FROM SANPHAM 
									  ORDER BY GIA DESC);

--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1
--trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNG QUOC' AND GIA IN (SELECT DISTINCT TOP 3 GIA 
										FROM SANPHAM WHERE NUOCSX = 'TRUNG QUOC' 
										ORDER BY GIA DESC);

--31. * In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
SELECT TOP 3 *
FROM KHACHHANG
ORDER BY DOANHSO DESC;

--32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(MASP) 'SO_SP_TRUNGQUOC'
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc';

--33. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(MASP) 'SO_SANPHAM'
FROM SANPHAM
GROUP BY NUOCSX;

--34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) 'GiaCaoNhat', MIN(GIA) 'GiaThapNhat', AVG(GIA) 'GiaTrungBinh'
FROM SANPHAM
GROUP BY NUOCSX;

--35. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) 'DoanhThu'
FROM HOADON
GROUP BY NGHD;

--36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT MASP, SUM(SL) 'TongSanLuong'
FROM CTHD JOIN HOADON
ON CTHD.SOHD = HOADON.SOHD
WHERE MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
GROUP BY MASP;

--37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) 'Thang', SUM(TRIGIA) 'DoanhThu'
FROM HOADON
WHERE YEAR(NGHD) = '2006'
GROUP BY MONTH(NGHD);

--38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD, COUNT(DISTINCT MASP) 'SoLuongSanPham'
FROM CTHD 
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) >= 4;

--39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT SOHD, COUNT(DISTINCT CTHD.MASP) 'SoLuong'
FROM CTHD, SANPHAM
WHERE CTHD.MASP = SANPHAM.MASP
AND NUOCSX = 'Viet Nam'
GROUP BY SOHD
HAVING COUNT(DISTINCT CTHD.MASP) = 3;

--40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT TOP 1 KHACHHANG.MAKH, HOTEN
FROM KHACHHANG, HOADON
WHERE KHACHHANG.MAKH = HOADON.MAKH
GROUP BY KHACHHANG.MAKH, HOTEN
ORDER BY COUNT(HOADON.MAKH) DESC;

--41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 MONTH(NGHD) 'Thang', SUM(TRIGIA) 'DoanhSo'
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC;

--42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 SANPHAM.MASP, TENSP, SUM(SL) 'TongSoLuong'
FROM SANPHAM, CTHD, HOADON
WHERE SANPHAM.MASP = CTHD.MASP
AND HOADON.SOHD = CTHD.SOHD
AND YEAR(NGHD) = 2006
GROUP BY SANPHAM.MASP, TENSP
ORDER BY SUM(SL) ASC;

--43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT MASP, TENSP, NUOCSX
FROM SANPHAM SP1
WHERE GIA IN (SELECT MAX(GIA)
			  FROM SANPHAM SP2
			  WHERE SP1.NUOCSX = SP2.NUOCSX);

--44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3;

--45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều
--nhất.
SELECT *
FROM KHACHHANG
WHERE MAKH IN (SELECT TOP 1 KHACHHANG.MAKH
			   FROM KHACHHANG, HOADON
			   WHERE KHACHHANG.MAKH = HOADON.MAKH
			   AND KHACHHANG.MAKH IN (SELECT TOP 10 MAKH
									  FROM KHACHHANG
									  ORDER BY DOANHSO DESC)
			   GROUP BY KHACHHANG.MAKH
			   ORDER BY COUNT(HOADON.MAKH) DESC);