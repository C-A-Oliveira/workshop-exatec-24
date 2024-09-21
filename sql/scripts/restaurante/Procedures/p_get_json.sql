create or alter procedure p_get_json(
    @url nvarchar(max)
    ,@dado nvarchar(max)
    ,@retorno nvarchar(max) OUTPUT
)
as
begin

    Declare @Object as Int;
    Declare @ResponseText as Varchar(8000);

	set @url = CONCAT(@url,isnull(@dado,''))

    Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
    Exec sp_OAMethod @Object, 'open', NULL, 'get', @URL, 'False'
    Exec sp_OAMethod @Object, 'send'
    Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT


    IF((Select @ResponseText) <> '')
    BEGIN
        select @retorno = JSON_QUERY(@ResponseText,'$.success')
    END
    ELSE
    BEGIN
        select @retorno = 'No data found.';
    END

    Exec sp_OADestroy @Object

end
GO
