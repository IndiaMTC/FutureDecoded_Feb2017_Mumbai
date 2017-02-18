use Clinic;
go;

create Procedure spInsPatient
	@PatientID int,
	@FirstName nvarchar(100),
	@LastName nvarchar(100),
	@CreditCardNumber nvarchar(30),
	@ExpiryDate nvarchar(5),
	@DateOfRegistration datetime
as 
begin
	insert into Clinic.dbo.Patient(PatientID,FirstName,LastName,CreditCardNumber,ExpiryDate,DateOfRegistration)
	values(@PatientID,@FirstName,@LastName,@CreditCardNumber,@ExpiryDate,@DateOfRegistration)
end

