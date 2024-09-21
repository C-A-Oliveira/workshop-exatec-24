CREATE or ALTER PROCEDURE restaurante.p_get_itens
AS
begin   
    SET NOCOUNT ON
    select 
        I.id
        ,I.nome
        ,I.valor
        ,I.descricao 
        ,C.nome as nome_categoria
        ,C.descricao as descricao_categoria
    from restaurante.item I
    join restaurante.categoria C
    on C.id = I.id_categoria
    for JSON path, root('itens')
    
    RETURN 
end
