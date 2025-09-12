/* 
================================================

Create Database and schemas

==================================================
Script purpose :
	This script creates a new database named 'DataWarehouse' after checking if it already exsists.
	if the database exsists , it is droped and recreated . Additionally, the script sets up three schemas within the databse :bronze , silver , gold. 

	Warning :
		Running this script will drop the entire 'Datawarehouse' database if it exsists.
		all the database will be permamnently deleted.proceed with caution and ensure you have a prper backups before running the script.
*/

--- Drop and recreate the 'Datawarehouse' database
if exists (select 1 from sys.databases where name ='DataWarehouse')
Begin
	alter database DataWarehouse set SINGLE_USER with  rollback immediate ;
	drop database DataWarehouse;
end;
go

--Crate database 'DataWarehouse'

use master;

Create Database DataWarehouse;
Use DataWarehouse;

--- Create Schema for each layer
go
create schema bronze;
go
create schema silver;
go
create schema gold;
go
