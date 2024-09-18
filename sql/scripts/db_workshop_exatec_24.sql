if not exists (select top 1
    1
from sys.databases
where name = 'workshop_exatec_24' )
begin

    CREATE DATABASE [workshop_exatec_24]
end
GO

use workshop_exatec_24
go



sp_configure 'show advanced options', 1;  
GO
RECONFIGURE;  
GO
sp_configure 'Ole Automation Procedures', 1;  
GO
RECONFIGURE;  
GO  

-- return
-- select * from sys.configurations order by name 