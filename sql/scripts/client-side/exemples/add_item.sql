declare @body nvarchar(max) = ''
declare @retorno nvarchar(max)

select @Body = convert(nvarchar(max),(
    select 
        nome = 'nome'
        ,valor = 0.0
        ,descricao = 'descricao'
        ,id_categoria = 8
    for json PATH, root('item')
))

select @body

exec p_post_json 'http://localhost:5000/restaurante/item/', @body, @retorno OUTPUT

select @retorno
