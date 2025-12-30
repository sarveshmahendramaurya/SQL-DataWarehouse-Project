/*script puspose:
	this script will drop database 'DataWarehouse' if is exist and create new database 'DataWarehouse'
	and use it. it will also create three schema named 'bronze','Silver',and 'Gold'*/

/*Warning:
	this script will drop database named 'DataWarehouse' and all the data will be lost if this database exists please consider it*/


USE MASTER;
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
BEGIN
DROP DATABASE DataWarehouse;
END;
GO

--===========================--
--creating and using database--
--===========================--
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

--===============--
--creating schema--
--===============--
CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
GO