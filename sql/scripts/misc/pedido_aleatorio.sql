
-- BUSCAR OS ITENS EXISTENTES
declare @dado nvarchar(max) = ''
declare @url nvarchar(max) = 'http://localhost:5000/restaurante/itens/'
declare @retorno nvarchar(max)

exec p_get_json @url, @dado, @retorno OUTPUT

--select retorno = @retorno
--select itens = JSON_QUERY(@retorno,'$.itens')

create table #itens_ids(
	i int identity(1,1),
	id int
)

-- SEPARAR APENAS OS IDS
insert into #itens_ids(id)
select id 
from OPENJSON(JSON_QUERY(@retorno,'$.itens'))
with(
	id int '$.id'
)

declare @qt_itens int = (select count(*) from #itens_ids) -- QUANTIDADE DE ITENS EXISTENTES

declare @c int = 0, 
		@limit int = (SELECT ABS(CHECKSUM(NEWID()) % @qt_itens)) -- QTD DE ITENS PARA SEREM DESCONSIDERADOS, 0 ~ QTD_ITEMS-1
declare @id_delete int

while @c < @limit
begin
	
	SELECT TOP 1 @id_delete = id FROM #itens_ids -- ESCOLHE UM ITEM ALEATORIO PARA REMOVER DA LISTA DE CONSIDERADOS
	ORDER BY NEWID()

	DELETE FROM #itens_ids where id = @id_delete
	--select [delete] = @id_delete
	select @c += 1
end

declare @cliente varchar(50) = (SELECT TOP 1 nome FROM dbo.nomes ORDER BY NEWID())

declare @pedido nvarchar(max) = convert(nvarchar(max),(
	select pedido = convert(nvarchar(max),(
		select 
			nome_cliente = @cliente
			,itens = (select id from #itens_ids for json auto)
		for json path 
	))for json path, WITHOUT_ARRAY_WRAPPER 
))
--declare @nome_pedido varchar(50) = 'pedido' + right(replicate('0',4)+convert(varchar(4),(select count(*) from restaurante.pedido)),4)

drop table #itens_ids

select @pedido