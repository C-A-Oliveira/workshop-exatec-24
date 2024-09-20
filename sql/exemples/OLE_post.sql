DECLARE @URL NVARCHAR(MAX) = 'http://localhost:5000/mes/';
Declare @Object as Int;
Declare @ResponseText as Varchar(8000);

-- Criar dados json para post
declare @mm int =cast(RAND()*1000000 as int) % 12+1;
declare @Body NVARCHAR(max) = ''

select @Body += convert(nvarchar(max),(
-- Tranformar em json    
        SELECT
        id = @mm,
        name = datename(month, '2000' + right('0'+convert(varchar(2),@mm),2) + '01')
    for json PATH, root('month')
))
select @Body += ',' + convert(nvarchar(max),(
-- Tranformar em json    
        SELECT
        id = @mm,
        name = datename(month, '2000' + right('0'+convert(varchar(2),@mm),2) + '01')
    for json PATH, root('month')
))

select @Body = REPLACE(@Body,N']},{"month":[',',')

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;

-- Instancia metodo get
Exec sp_OAMethod @Object, 'open', NULL, 'post',
       @URL,
       'False'

-- Request Header
EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'

-- Enviar request
Exec sp_OAMethod @Object, 'send', null, @Body

-- Processar retorno
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
IF((Select @ResponseText) <> '')
BEGIN

    select @ResponseText
    DECLARE @json NVARCHAR(MAX) = (Select @ResponseText)

    -- SELECT * FROM OPENJSON(@json)
    -- lista valores no json ["id_1","id_2"]
    declare @months nvarchar(max )= JSON_QUERY(@ResponseText,'$.success.month')
    
    SELECT *
    FROM OPENJSON(@months)
    WITH(id int '$.id'
        ,name nvarchar(20) '$.name')
    
END
ELSE
BEGIN
    DECLARE @ErroMsg NVARCHAR(30) = 'No data found.';
    Print @ErroMsg;
END

-- Destruir objeto
Exec sp_OADestroy @Object
