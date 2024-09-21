-- post proc vs func
use workshop_exatec_24
go

declare @retorno NVARCHAR(max)
DECLARE @URL NVARCHAR(MAX) = 'http://localhost:5000/devolve-body/';
declare @Body NVARCHAR(max) = convert(nvarchar(max),(
    select 
        id
        ,nome
        ,descricao
    from restaurante.categoria
    for json PATH, root('categorias')
))

--FUNCTION
select [post via function] = dbo.f_post_json(@URL, @Body)

--PROCEDURE
exec dbo.p_post_json @URL, @Body, @retorno output
select @retorno
