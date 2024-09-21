-- https://zealousweb.medium.com/calling-rest-api-from-sql-server-stored-procedure-85ec1ab73504

DECLARE @WDay nvarchar = N'day=' + convert(nvarchar(1),datepart(dw, getdate()))
DECLARE @URL NVARCHAR(MAX) = concat(N'http://localhost:5000/', @WDay);
Declare @Object as Int;
Declare @ResponseText as Varchar(8000);
select @URL

-- Objeto request
Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;

-- Instancia metodo get
Exec sp_OAMethod @Object, 'open', NULL, 'get',
       @URL,
       'False'

-- Enviar request
Exec sp_OAMethod @Object, 'send'

-- Processar retorno
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
IF((Select @ResponseText) <> '')
BEGIN

     /* como o retorno do get é um json, processa a resposta recebida com a estrutura desejada*/
     DECLARE @json NVARCHAR(MAX) = (Select @ResponseText)
     SELECT *
     FROM OPENJSON(@json)
          WITH ( -- sql_table_column <- json field
                 id NVARCHAR(30) '$.day.id',
                 name NVARCHAR(50) '$.day.name'
               );
     -- com erro, para debug
     --   WITH ( -- sql_table_column <- json field
     --        id NVARCHAR(30) '$.id',
     --        name NVARCHAR(50) '$.name'
     --      );
END
ELSE
BEGIN
     DECLARE @ErroMsg NVARCHAR(30) = 'No data found.';
     Print @ErroMsg;
END

-- Destruir objeto
Exec sp_OADestroy @Object