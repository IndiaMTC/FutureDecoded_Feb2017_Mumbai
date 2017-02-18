Use master
go
--Create Database
Create Database Clinic
on Primary
(
	Name = 'ClinicData',
	FileName = 'C:\Future Decoded\AlwaysEncrypted\Data\TicketReservationsData.mdf',
	size = 1024 MB,
	maxsize = 5120
)
log on
(
	Name = 'ClinicLog',
	FileName = 'C:\Future Decoded\AlwaysEncrypted\Data\TicketReservationsLog.ldf',
	size = 256 MB,
	maxsize = 512 MB
)
go