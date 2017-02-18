-- Always Encrypted Demo

USE Clinic;
GO

-- Remove any existing column keys and/or table
DROP TABLE IF EXISTS Patient
IF EXISTS (SELECT 1 FROM sys.column_encryption_keys WHERE name = N'Patient_EncryptionKey')
BEGIN
	DROP COLUMN ENCRYPTION KEY Patient_EncryptionKey;
END;
IF EXISTS (SELECT 1 FROM sys.column_master_keys WHERE name = N'Patient_MasterKey')
BEGIN
	DROP COLUMN MASTER KEY Patient_MasterKey;
END;
GO

-- We need a column master key. This key is used to encrypt the column encryption keys.
-- The column master key isn't really stored in the database. It's created and stored on the 
-- client system. SQL Server only holds a link to it so that SQL Server can tell the 
-- client application where to locate the master key. The client system will encrypt a column
-- encryption key with this master key.

-- The wizard will create a certificate, install it in the certificate store, then
-- register it with SQL Server via CREATE COLUMN MASTER KEY

-- 1a. In Object Explorer, expand the security node in Clinc, then expand
--     the Always Encrypted Keys node and note the contents.
-- 1b. Right-click the Column Master Keys node and click New Column Master Key.
-- 1c. For the name, enter Patient_MasterKey.
-- 1d. Note the available entries in the Key store dropdown list. Choose Windows Certificate Store - Current User. 
--     This will only be a temporary location for the certificate.
-- 1e. Click Generate Certificate to create the new certificate. Note that an Always Encrypted certificate
--     has been created. Ensure that it is selected, then click OK.

-- We have used the MSSQL_CERTIFICATE_STORE which uses the Windows store 
-- but we can use any store that implements the SqlColumnEncryptionKeyStoreProvider 
-- class. (And is registered by calling the SqlConnection.RegisterColumnEncryptionKeyStoreProviders() 
-- method). This requires .NET framework 4.6.1 or later on the client.

-- The certificate could also have been created via the makecert utility and just loaded on the client.

-- We can see the newly created master key. Note the key_path. This path is relative to the client.

SELECT * FROM sys.column_master_keys;

-- The next key that we need is used for performing column encryption. It's held encrypted on the
-- database server and is decrypted (and cached) on the client application before use.
-- On the client system, it is protected by the column master key.

-- 2a. In Object Explorer, right-click the Column Encryption Keys node and click New Column Encryption Key.
-- 2b. In the Name textbox, enter WWI_ColumnEncryptionKey and from the Column master key dropdown list, 
--     select WWI_ColumnMasterKey to be used to encrypt this new key. Then click OK.

-- We can see the newly created encryption key.

SELECT * FROM sys.column_encryption_keys;

-- Now let's create the table that will use always encrypted.
-- We'll have one deterministic encryption column and two random 
-- encryption (salted) columns.
	CREATE TABLE Patient
	(
		PatientID int 
			CONSTRAINT  PKFK_Purchasing_Supplier_PrivateDetails PRIMARY KEY clustered,
	
		FirstName nvarchar(100) COLLATE Latin1_General_BIN2
			ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = Patient_EncryptionKey,
							   ENCRYPTION_TYPE = DETERMINISTIC,
							ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL,

		LastName nvarchar(100) COLLATE Latin1_General_BIN2
			ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = Patient_EncryptionKey,
							   ENCRYPTION_TYPE = DETERMINISTIC,
							ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL,


		CreditCardNumber nvarchar(30) COLLATE Latin1_General_BIN2
			ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = Patient_EncryptionKey,
							   ENCRYPTION_TYPE = RANDOMIZED,
							ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL,

		ExpiryDate nvarchar(5) COLLATE Latin1_General_BIN2
			ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = Patient_EncryptionKey,
							   ENCRYPTION_TYPE = RANDOMIZED,
							ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL,

		DateOfRegistration date not null,
	);
	GO

-- Note that we can't directly insert unencrypted data
-- Note the error returned. The data in the columns is only
-- understood by the client system.

INSERT into Patient
(PatientID,FirstName,LastName,CreditCardNumber,ExpiryDate,DateOfRegistration)	
VALUES
	(1, 'Guru', 'Charan', '92343-234-234','2343',getdate())
GO
create nonclustered index indDateOfRegistration on Patient(DateOfRegistration)
-- Let's ensure the table is empty, then we'll use a client application
-- to populate the data. Note that we can still perform standard 
-- table operations like truncation.

TRUNCATE TABLE Patient
GO

-- 3. Run the client application PopulateAlwaysEncryptedData.exe to insert sample data

-- 4. Verify that, on the server side (which does not have the keys), all the data is encrypted
set statistics profile on
Select * from Patient
set statistics profile off

-- To emulate a client application that has access to the keys, we 
-- can use SSMS to connect. Note that this can only work because
-- the client happens to be the same machine as the server in our 
-- case. 

-- 5a. Open the second query window for this demonstration and follow the instructions there.



-- 6. (optional) Clean up afterwards.

-- Remove any existing column keys and/or table
DROP TABLE IF EXISTS Purchasing.Supplier_PrivateDetails;
IF EXISTS (SELECT 1 FROM sys.column_encryption_keys WHERE name = N'WWI_ColumnEncryptionKey')
BEGIN
	DROP COLUMN ENCRYPTION KEY WWI_ColumnEncryptionKey;
END;
IF EXISTS (SELECT 1 FROM sys.column_master_keys WHERE name = N'WWI_ColumnMasterKey')
BEGIN
	DROP COLUMN MASTER KEY WWI_ColumnMasterKey;
END;
GO


