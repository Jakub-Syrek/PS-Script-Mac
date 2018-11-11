#pull SQL serv to docker

docker pull mcr.microsoft.com/mssql/server:2017-latest 

#create DB in cont. in docker
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Password!1" `
   -p 1433:1433 --name sql1 `
   -d mcr.microsoft.com/mssql/server:2017-latest
  
#check status of DB
docker ps -a
#change pass
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd `   -S localhost -U SA -P 'Password!1' ` -Q "ALTER LOGIN SA WITH PASSWORD='Password!2'"

#start docker bash in container.
docker exec -it sql1 "bash"

#connect with new pass
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Password!1'   

#Run SQL
CREATE DATABASE TestDB

SELECT Name from sys.Databases

GO

USE TestDB

CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)

INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);

GO

SELECT * FROM Inventory WHERE quantity > 152;

QUIT

#Stop Docker and remove SQL
docker stop sql1
docker rm sql1