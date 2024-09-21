CREATE or ALTER PROCEDURE restaurante.p_get_item(
	@id_item int
)
AS
SET NOCOUNT ON 
begin   
    select 
        I.id
        ,I.nome
        ,I.valor
        ,I.descricao 
		,I.id_categoria
        ,C.nome as nome_categoria
        ,C.descricao as descricao_categoria
    from restaurante.item I
    join restaurante.categoria C
    on C.id = I.id_categoria
	where I.id = @id_item

    for JSON path, root('item')
    
    RETURN 
end
