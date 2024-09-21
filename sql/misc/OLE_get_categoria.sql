-- https://zealousweb.medium.com/calling-rest-api-from-sql-server-stored-procedure-85ec1ab73504

DECLARE @URL NVARCHAR(MAX) = 'http://localhost:5000/restaurante/categorias/id_categoria=1';
Declare @Object as Int;
Declare @ResponseText as Varchar(8000);
Declare @retorno as Varchar(8000);

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get', @URL,'False'
Exec sp_OAMethod @Object, 'send'
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

IF((Select @ResponseText) <> '')
BEGIN
    select @retorno = JSON_QUERY(@ResponseText,'$.categoria')
END
ELSE
BEGIN
    select @retorno = 'No data found.';
END
Exec sp_OADestroy @Object

select categoria = @retorno