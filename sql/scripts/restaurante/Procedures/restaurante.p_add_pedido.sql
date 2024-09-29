--{"pedido":[{"nome_cliente":"Steffan Rivera","itens":[{"id":12}]}]}
CREATE or ALTER PROCEDURE restaurante.p_add_pedido(
    @buffer NVARCHAR(MAX)

    ,@retorno VARCHAR(max) =  null OUTPUT
    ,@cd_retorno int = null OUTPUT
)
AS
SET NOCOUNT ON 
begin

	--- NOME DO CLIENTE
    declare @nome_cliente NVARCHAR(50) = ''
	select @nome_cliente = nome_cliente
	from openjson(
		JSON_QUERY(@buffer,'$.pedido'))
	with (nome_cliente nvarchar(max) '$.nome_cliente')
    
	--- ITENS PEDIDOS
	declare @itens table (id int)
	insert into @itens (id)
	select id_item
	from openjson(
		JSON_QUERY(@buffer,'$.pedido'))
	with (itens nvarchar(max) '$.itens' as json)
	outer apply openjson(json_query(itens, '$')) with (id_item int '$.id')

	-- CRIA NOVO PEDIDO
	declare @id_pedido_novo table (id int) 
	insert into restaurante.pedido (nome_cliente)
	output inserted.id into @id_pedido_novo
	select @nome_cliente

	-- ASSOCIA ITENS AO PEDIDO
	insert into restaurante.item_pedido (id_pedido, id_item)
	select p.id, i.id
	from @itens i
	left join @id_pedido_novo p on 1=1

	-- ATUALIZA VALOR DO PEDIDO -- ISSO DEVERIA SER UMA OBJETO SEPARADO
	update p
	set p.valor = (select sum(i.valor)
		from restaurante.pedido p2 
		join restaurante.item_pedido isp on isp.id_pedido = p2.id
		join restaurante.item i on i.id = isp.id_item
		where p2.id = (select id from @id_pedido_novo)
	)
	from restaurante.pedido p
	where p.id = (select id from @id_pedido_novo)

	
	update p
	set status = 'Em Aberto'
	from restaurante.pedido p
	where p.id = (select id from @id_pedido_novo)
   
    select
        @retorno = 'Pedido adicionado.' 
        ,@cd_retorno = 0 
    RETURN 
end


