#!/bin/bash

# https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat

# install server
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo
yum install -y mssql-server
/opt/mssql/bin/mssql-conf setup

systemctl status mssql-server
firewall-cmd --zone=public --add-port=1433/tcp --permanent
firewall-cmd --reload

# install comandline tools
curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo
yum remove -y unixODBC-utf16 unixODBC-utf16-devel
yum install -y mssql-tools unixODBC-devel
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

exit 0






################################## SOME NOTES ##########################################################################################
CREATE DATABASE TestDB
SELECT Name from sys.Databases
GO


USE TestDB
CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
GO

SELECT * FROM Inventory WHERE quantity > 152;
GO

QUIT


BACKUP DATABASE [YourDB] TO  DISK =
N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\YourDB.bak'
WITH NOFORMAT, NOINIT, NAME = N'YourDB-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO


RESTORE DATABASE YourDB
FROM DISK = '/var/opt/mssql/backup/YourDB.bak'
WITH MOVE 'YourDB' TO '/var/opt/mssql/data/YourDB.mdf',
MOVE 'YourDB_Log' TO '/var/opt/mssql/data/YourDB_Log.ldf'
GO

SELECT Name FROM sys.Databases
GO

USE YourDB
SELECT * FROM YourTable
GO



