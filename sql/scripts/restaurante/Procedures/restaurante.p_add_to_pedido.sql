
CREATE or ALTER PROCEDURE restaurante.p_add_to_pedido(
    @id_pedido int 
	,@buffer NVARCHAR(MAX)

    ,@retorno VARCHAR(max) =  null OUTPUT
    ,@cd_retorno int = null OUTPUT
)
AS
SET NOCOUNT ON 
begin

	if not exists(select top 1 1 from restaurante.pedido where id = @id_pedido)
	begin 
		select
			@cd_retorno = 1
			,@retorno = 'Pedido inexistente.'
		return
	end

	if isnull((select top 1 status from restaurante.pedido where id = @id_pedido ),'') <> 'Em Aberto'
	begin 
		select
			@cd_retorno = 1
			,@retorno = 'Status do pedido invalido.'
		return
	end
	
	    
	--- ITENS PEDIDOS
	declare @itens table (id int)
	insert into @itens (id)
	select id_item
	from openjson(
		JSON_QUERY(@buffer,'$.pedido'))
	with (itens nvarchar(max) '$.itens' as json)
	outer apply openjson(json_query(itens, '$')) 
	with (id_item int '$.id')


	if exists(select top 1 1 from @itens where isnull(id, 0) = 0 or id not in (select id from restaurante.item))
	begin 
		select
			@cd_retorno = 1
			,@retorno = 'Não foi provido itens validos para adicionar ao pedido.'
		return
	end

	


	-- ASSOCIA ITENS AO PEDIDO
	insert into restaurante.item_pedido (id_pedido, id_item)
	select @id_pedido, i.id
	from @itens i

	-- ATUALIZA VALOR DO PEDIDO -- ISSO DEVERIA SER UMA OBJETO SEPARADO
	update p
	set p.valor = (select sum(i.valor)
		from restaurante.pedido p2 
		join restaurante.item_pedido isp on isp.id_pedido = p2.id
		join restaurante.item i on i.id = isp.id_item
		where p2.id = @id_pedido
	)
	from restaurante.pedido p
	where p.id = @id_pedido

   
    select
        @retorno = 'Pedido adicionado.' 
        ,@cd_retorno = 0 

    RETURN 
end


