create or alter procedure p_post_json(
    @url nvarchar(max)
    ,@data nvarchar(max)
    ,@retorno nvarchar(max) OUTPUT
)
as
begin

    Declare @Object as Int;
    Declare @ResponseText as Varchar(8000);

    Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
    Exec sp_OAMethod @Object, 'open', NULL, 'post', @URL, 'False'
    EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
    Exec sp_OAMethod @Object, 'send', null, @data
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
