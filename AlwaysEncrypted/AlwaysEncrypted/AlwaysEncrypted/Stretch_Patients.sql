EXEC sp_configure 'remote data archive' , '1';  
GO
RECONFIGURE;  
GO  

USE Clinic
GO  
drop database scoped credential AppCred
go
CREATE DATABASE SCOPED CREDENTIAL AppCred1
    WITH IDENTITY = 'gurucb' , SECRET = 'H!RRYp0tt5rs' ;

alter database Clinic
set   REMOTE_DATA_ARCHIVE  = ON
(
	server = 'gurucbsqlstretchsvr.database.windows.net',
	credential = AppCred1
)
go

drop function dbo.fn_stretch_by_date
CREATE FUNCTION dbo.fn_stretch_by_date(@date datetime2)  
RETURNS TABLE  
WITH SCHEMABINDING   
AS   
       RETURN SELECT 1 AS is_eligible WHERE @date < CONVERT(datetime2, '1/1/2017', 101)  
GO  

ALTER TABLE Patient
    SET ( REMOTE_DATA_ARCHIVE  
        (           
            FILTER_PREDICATE = dbo.fn_stretch_by_date(DateOfRegistration),  
            MIGRATION_STATE = OUTBOUND  
        )  
        );   

