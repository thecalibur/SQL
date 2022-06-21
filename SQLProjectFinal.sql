create database QL_HocSinh
go
use QL_HocSinh
go
--drop database QL_HocSinh

create table LOP
(
	malop char(10) primary key not null,
	tenlop nvarchar(20) not null
)
go
create table HOCSINH
(
	mahs char(6) primary key not null,
	hoten nvarchar(120) null,
	ngaysinh date not null,
	dienthoai int null,
	malop char(10) foreign key references LOP(malop) not null
	)
go
create table MONHOC
(
	tenmonhoc nvarchar(120) primary key not null,
	sosession int not null,
	diemdat float not null,
	diemtoida float not null
	)
go
create table BANGTHI
(
	mahs char(6) foreign key references HOCSINH(mahs) not null,
	monhoc nvarchar(120) foreign key references MONHOC(tenmonhoc) not null,
	diemthi float null,
	ngaythi date null,
	lanthi int null,
	primary key(mahs,monhoc)
	)
go


insert into LOP(malop,tenlop)
values('L01',N'Lớp 11A'),
	  ('L02',N'Lớp 11B'),
	  ('L03',N'Lớp 11C')
go
insert into HOCSINH(mahs,hoten,ngaysinh,dienthoai,malop)
values('M001',N'Nguyễn Quốc Oai','07-09-2000','117654','L01'),
	  ('M002',N'Trần Thanh','04-12-2000','548932','L02'),
	  ('M003',N'Phạm Văn Dương','09-01-2000','347690','L03')

go
insert into MONHOC(tenmonhoc,sosession,diemdat,diemtoida)
values(N'Toán','20','4.5','10.0'),
	  (N'Văn','40','5.0','9.0'),
	  (N'Ngoại ngữ','60','4.5','10.0')
go
insert into BANGTHI(mahs,monhoc,diemthi,ngaythi,lanthi)
values('M001',N'Toán','4','2016/9/24','1'),
	('M001',N'Ngoại ngữ','8','2016/9/26','1'),
	  ('M002',N'Văn','6.5','2016/9/25','1'),
	  ('M003',N'Toán','9.5','2016/9/24','1'),
	  ('M001',N'Văn','8','2016/9/25','2'),
	  ('M003',N'Ngoại ngữ','7.5','2016/9/29','1'),
	  ('M002',N'Toán','8.5','2016/9/24','1'),
	  ('M002',N'Ngoại ngữ','10','2016/9/29','2'),
	  ('M003',N'Văn','3.5','2016/9/25','2')
go


--1.	Chèn ở mỗi bảng 3 dòng dữ liệu mới.
insert into LOP(malop,tenlop)
values('L04',N'lớp 11D'),
      ('L05',N'lớp 11E'),
	  ('L06',N'lớp 11F')
go

insert into HOCSINH(mahs,hoten,ngaysinh,dienthoai,malop)
values('M004',N'Nguyễn Quốc Hưng','11-11-1911','123456','L04'),
      ('M005',N'Nguyễn Quốc Hùng','22-12-1922','234567','L05'),
	  ('M006',N'Nguyễn Quốc Anh','03-03-1933','345678','L06')
	
insert into MONHOC(tenmonhoc,sosession,diemdat,diemtoida)

values(N'Nhật','10','7.0','10.0'),
	  (N'Lý','15','8.0','10.0'),
	  (N'Hóa','20','9.0','10.0')
	
insert into BANGTHI(mahs,monhoc,diemthi,ngaythi,lanthi)
values('M004',N'Nhật','6.0','8/10/2016','1'),
      ('M005',N'Lý','7.0','9/11/2016','2'),
	  ('M006',N'Hóa','5.0','7/12/2016','3')
select *
from BANGTHI

--2.	Tăng số tiết học môn toán lên 25.
update MONHOC
set sosession = sosession + 25
where tenmonhoc like N'Toán'
select * 
from MONHOC

--3.	Hiển thị thông tin của học sinh thuộc lớp có mã số L02
select *
from HOCSINH join LOP on HOCSINH.malop = LOP.malop
where LOP.malop = 'L02'

--4.	Hiển thị tên lớp, tên học sinh trong lớp có mã số là L01.
select HOCSINH.hoten, tenlop, LOP.malop
from HOCSINH join LOP on HOCSINH.malop = LOP.malop
where LOP.malop = 'L01
'
--5.	Hiển thị họ và tên đầy đủ của học sinh, môn học và số tiết học mà các học sinh đã học.
select HOCSINH.hoten, tenmonhoc, sosession
from HOCSINH join BANGTHI on HOCSINH.mahs = BANGTHI.mahs join MONHOC on MONHOC.tenmonhoc = BANGTHI.monhoc

--6.	Đếm số học sinh thi trượt môn 'Literature'.
select count(*) as 'HS trượt Văn'
from BANGTHI join MONHOC on BANGTHI.monhoc = MONHOC.tenmonhoc
where tenmonhoc like N'Văn' and diemthi < diemdat

--7.	Tìm thông tin của học sinh có điểm thi cao nhất vào ngày '9/25/2016'.
select top 1 *
from HOCSINH join BANGTHI on HOCSINH.mahs = BANGTHI.mahs
where ngaythi = '9/25/2016'
order by diemthi desc

--8.	Hiển thị tên học sinh, môn thi và điểm thi vào ngày thi '9/29/2016' (Kể cả những học sinh chưa thi ngày này cũng để là null).
select hoten, ngaythi, monhoc, diemthi
from BANGTHI right join HOCSINH on BANGTHI.mahs = HOCSINH.mahs
and BANGTHI.ngaythi = '9/29/2016'

--9.	Tạo View để hiển thị toàn bộ thông tin của bản BANGDIEM.
go
create view vw_bangdiem 
as
select hoten, monhoc, diemthi
from HOCSINH, BANGTHI 
where HOCSINH.mahs = BANGTHI.mahs
select * from vw_bangdiem

--10.	Tạo Store Procedure để hiển thị toàn bộ thông tin ở BANGDIEM với mã học sinh được nhập vào từ bàn phím.
go
create proc sp_bangdiem (@MaHS char(6))
as
select hoten, monhoc, diemthi
from HOCSINH join BANGTHI on HOCSINH.mahs = BANGTHI.mahs
where HOCSINH.mahs = @MaHS
go
exec sp_bangdiem 'M001'
