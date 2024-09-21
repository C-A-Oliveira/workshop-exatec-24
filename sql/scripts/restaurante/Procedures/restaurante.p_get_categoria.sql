create or alter procedure restaurante.p_get_categoria(
    @url nvarchar(max)
    ,@retorno nvarchar(max) OUTPUT
)
as
begin

    Declare @Object as Int;
    Declare @ResponseText as Varchar(8000);

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

end
GO
