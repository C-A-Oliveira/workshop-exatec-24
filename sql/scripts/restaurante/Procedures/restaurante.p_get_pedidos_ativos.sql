CREATE or ALTER PROCEDURE restaurante.p_get_pedidos_ativos
AS
SET NOCOUNT ON 
begin   
	select 
	pedido.id				
	,pedido.nome_cliente	
	,pedido.valor			
	,pedido.status			
	,(select count(*) from restaurante.item_pedido ip2 where ip2.id_pedido = pedido.id)as [qtd_itens]
	,item.id				
	,item.nome				
	,item.valor				
	,item.descricao			
	,categoria.nome			
	,categoria.descricao	
    from restaurante.pedido pedido
	join restaurante.item_pedido i_p	on i_p.id_pedido = pedido.id
	join restaurante.item item				on item.id = i_p.id_item
    join restaurante.categoria categoria		on categoria.id = item.id_categoria
	where isnull(pedido.status,'') = 'Em aberto'
	order by pedido.id
	/* order by é importante para garantir a ordem (duh) correta, caso contrario, valores se repetem no JSON.
		S/ Order:	{"pedido":[{"id":2,"nome_cliente":"Silas Lawrence","valor":1233,"qtd_itens":4,"item":[{"id":11,"nome":"1nomsse23","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":1,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":2,"nome_cliente":"Silas Lawrence","valor":1233,"qtd_itens":4,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":3,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":4,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":5,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":2,"nome_cliente":"Silas Lawrence","valor":1233,"qtd_itens":4,"item":[{"id":13,"nome":"nome","valor":0.00,"descricao":"descricao","categoria":[{"nome":"Café","descricao":"Café"}]},{"id":14,"nome":"1nomsse33232","valor":1233.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]}]}
		C/ Order:	{"pedido":[{"id":1,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":2,"nome_cliente":"Silas Lawrence","valor":1233,"qtd_itens":4,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]},{"id":13,"nome":"nome","valor":0.00,"descricao":"descricao","categoria":[{"nome":"Café","descricao":"Café"}]},{"id":14,"nome":"1nomsse33232","valor":1233.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]},{"id":11,"nome":"1nomsse23","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":3,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":4,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]},{"id":5,"nome_cliente":"Steffan Rivera","valor":0,"qtd_itens":1,"item":[{"id":12,"nome":"1nomsse232","valor":0.00,"descricao":"desc3sssricao","categoria":[{"nome":"Chá","descricao":"Chá-fé"}]}]}]}
	*/

    for JSON auto,root('pedidos')
    
    RETURN 
end
