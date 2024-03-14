CREATE DATABASE CFMD
GO
USE CFMD
-- Bảng nguyên liệu
CREATE TABLE NGUYENLIEU(
MaNL		CHAR(5)			PRIMARY KEY,
TenNL		NVARCHAR(50)	NOT NULL,
SoLuongTonKho FLOAT,
DonVi_NL		VARCHAR(20)
);


-- Bảng sản phẩm
CREATE TABLE SANPHAM(
MaSP		CHAR(5)			PRIMARY KEY,
TenSP		NVARCHAR(50)	NOT NULL,
Dongia		FLOAT			NOT NULL,
MaLH		CHAR(5),
FOREIGN KEY (MaLH) REFERENCES LOAIHANG(MaLH)
);

-- Bảng công thức sản phẩm 
CREATE TABLE CONGTHUCSP(
MaSP			CHAR(5),
MaNL			CHAR(5),
KhoiLuongSuDung FLOAT,
DonVi_NL		VARCHAR(20),
PRIMARY KEY(MaSP,MaNL),
FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP),
FOREIGN KEY (MaNL) REFERENCES NGUYENLIEU(MaNL),
);

-- Bảng nhà cung cấp
CREATE TABLE NHACUNGCAP(
MaNCC	CHAR(5)			PRIMARY KEY,
TenNCC	NVARCHAR(50)	NOT NULL,
SDT		VARCHAR(10)		UNIQUE NOT NULL,
DiaChi	NVARCHAR(100),
TKNH	VARCHAR(50)
);

-- Bảng nhân viên
CREATE TABLE NHANVIEN(
MaNV		CHAR(5)			PRIMARY KEY,
TenNV		NVARCHAR(50)	NOT NULL,
SDT			VARCHAR(10)		UNIQUE NOT NULL,
NgaySinh	DATE,
MK			VARCHAR(10)		NOT NULL
);

-- Bảng khách hàng
CREATE TABLE KHACHHANG(
MaKH		CHAR(5)			PRIMARY KEY,
TenKH		NVARCHAR(50)	NOT NULL,
SDT			VARCHAR(10)		UNIQUE NOT NULL,
DiaChi		NVARCHAR(100),
DiemTichLuy FLOAT
);

-- Bảng hóa đơn bán
CREATE TABLE HOADONBAN(
MaHD			CHAR(10)	PRIMARY KEY,
NgayBan			DATETIME	NOT NULL,
TongTienHang	FLOAT		DEFAULT	0,
ChietKhau		FLOAT		DEFAULT	0,
TongThanhToan	FLOAT		DEFAULT	0,
MaNV			CHAR(5),
MaKH			CHAR(5),
FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)
);
-- Bảng hóa đơn bán_chi tiết
CREATE TABLE HOADONBAN_CHITIET(
MaHD		CHAR(10),
MaSP		CHAR(5) ,
Soluong		INT		NOT NULL,
Thanhtien	FLOAT	DEFAULT	0,
PRIMARY KEY(MaHD,MaSP),
FOREIGN KEY (MaHD) REFERENCES HOADONBAN(MaHD),
FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
);

--Bảng hóa đơn nhập
CREATE TABLE HOADONNHAP(
MaHD			CHAR(10)	PRIMARY KEY,
NgayNhap		DATETIME	NOT NULL,
TongTienHang	FLOAT		DEFAULT	0,
TongGiamGia		FLOAT		DEFAULT	0,
TongThanhToan	FLOAT		DEFAULT	0,
MaNV			CHAR(5),
MaNCC CHAR(5),
FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC)
);
--Bảng hóa đơn nhập_chi tiết 
CREATE TABLE HOADONNHAP_CHITIET(
MaHD		CHAR(10),
MaNL		CHAR(5),
SoLuongNhap INT				NOT NULL,
DonVi		NVARCHAR(10)	NOT NULL,
Thanhtien	FLOAT,
GiamGia		FLOAT,
DonGia		FLOAT,
PRIMARY KEY(MaHD,MaNL),
FOREIGN KEY (MaHD) REFERENCES HOADONNHAP(MaHD),
FOREIGN KEY (MaNL) REFERENCES NGUYENLIEU(MaNL)
);

--//////////////////////////////TẠO MÃ TỰ ĐỘNG ////////////////////////////
--1 Tạo mã nguyên liệu tự động
Create or alter  function FmamoiNL()
returns char(5)
as
begin
	declare @max char(5), @n int
	set @n= (select count(MaNL) from NGUYENLIEU)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaNL) from NGUYENLIEU
		set @max=RIGHT(@max,(LEN(@max)-2))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'NL'+ REPLICATE('0',(5-LEN(@max)-2))+@max
	return @max
end
GO
select dbo.FmamoiNL()
go

--2 Tạo mã sản phẩm tự động
Create or alter  function FmamoiSP()
returns char(5)
as
begin
	declare @max char(5), @n int
	set @n= (select count(MaSP) from SANPHAM)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaSP) from SANPHAM
		set @max=RIGHT(@max,(LEN(@max)-2))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'SP'+ REPLICATE('0',(5-LEN(@max)-2))+@max
	return @max
end
GO
select dbo.FmamoiSP()
go

--3 Tạo mã khách hàng tự động
Create or alter  function FmamoiKH()
returns char(5)
as
begin
	declare @max char(5), @n int
	set @n= (select count(MaKH) from KHACHHANG)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaKH) from KHACHHANG
		set @max=RIGHT(@max,(LEN(@max)-2))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'KH'+ REPLICATE('0',(5-LEN(@max)-2))+@max
	return @max
end
go
select dbo.FmamoiKH()
go

--4 Tạo mã nhân viên tự động
Create or alter  function FmamoiNV()
returns char(5)
as
begin
	declare @max char(5), @n int
	set @n= (select count(MaNV) from NHANVIEN)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaNV) from NHANVIEN
		set @max=RIGHT(@max,(LEN(@max)-2))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'NV'+ REPLICATE('0',(5-LEN(@max)-2))+@max
	return @max
end
go
select dbo.FmamoiNV()
go

--5 Tạo mã nhà cung cấp tự động
Create or alter  function FmamoiCC()
returns char(5)
as
begin
	declare @max char(5), @n int
	set @n= (select count(MaNCC) from NHACUNGCAP)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaNCC) from NHACUNGCAP
		set @max=RIGHT(@max,(LEN(@max)-2))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'CC'+ REPLICATE('0',(5-LEN(@max)-2))+@max
	return @max
end
go
select dbo.FmamoiNCC()
go

--6 Tạo mã hóa đơn bán tự động
Create or alter  function FmamoiHDB()
returns char(10)
as
begin
	declare @max char(10), @n int
	set @n= (select count(MaHD) from HOADONBAN)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaHD) from HOADONBAN
		set @max=RIGHT(@max,(LEN(@max)-3))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'HDB'+ REPLICATE('0',(10-LEN(@max)-3))+@max
	return @max
end
go
select dbo.FmamoiHDB()
go


--7 Tạo mã hóa đơn nhập tự động
Create or alter  function FmamoiHDN()
returns char(10)
as
begin
	declare @max char(10), @n int
	set @n= (select count(MaHD) from HOADONNHAP)
	if @n=0
	begin
		set @max=1
	end
	else
	begin
		select @max=max(MaHD) from HOADONNHAP
		set @max=RIGHT(@max,(LEN(@max)-3))
		set @max=cast((cast(@max as int)+1) as varchar(10))
	end
	set @max = 'HDN'+ REPLICATE('0',(10-LEN(@max)-3))+@max
	return @max
end
go
select dbo.FmamoiHDN()
go 







