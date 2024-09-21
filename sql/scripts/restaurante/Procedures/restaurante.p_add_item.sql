CREATE or ALTER PROCEDURE restaurante.p_add_item(
    @buffer NVARCHAR(MAX)

    ,@retorno VARCHAR(max) =  null OUTPUT
    ,@cd_retorno int = null OUTPUT
)
AS
begin
    SET NOCOUNT ON   
    declare 
        @nome NVARCHAR(50) = ''
        ,@valor NUMERIC(19,2) = -1.0
        ,@descricao NVARCHAR(100) = 'null'
        ,@id_categoria int = 0

    select
        @nome = item.nome 
        ,@valor = item.valor
        ,@descricao = item.descricao
        ,@id_categoria = item.id_categoria
    from OPENJSON(@buffer)
    with (item nvarchar(max) '$.item'as json)
    OUTER apply OPENJSON(item)
    with (
        nome nvarchar(50) '$.nome'
        ,valor NUMERIC(19,2) '$.valor'
        ,descricao nvarchar(100)  '$.descricao'
        ,id_categoria int '$.id_categoria'
    ) as item


    if isnull(@nome,'') = ''
    or isnull(@valor, -1.0) < 0
    or isnull(@id_categoria, 0) = 0
    begin 
        SELECT @retorno = 'Valores nulos ou vazios.', @cd_retorno = 1
        RETURN
    end

    if not exists (select top 1 1 
                from restaurante.categoria 
                where id = @id_categoria)
    begin
        SELECT @retorno = 'Categoria inexiste.', @cd_retorno = 1
        RETURN
    end

    if exists (select top 1 1 
                from restaurante.item i
                where i.nome = @nome 
                and i.descricao = @descricao
                and i.valor = @valor
                and i.id_categoria = @id_categoria)
    BEGIN
        SELECT @retorno = 'Item já existe.', @cd_retorno = 1
        RETURN
    END

    insert into restaurante.item
    (nome, valor, id_categoria, descricao)
    select 
        nome = @nome
        ,valor = @valor
        ,id_categoria = @id_categoria
        ,descricao = @descricao

    select
        @retorno = 'Item adicionado' 
        ,@cd_retorno = 0 
    RETURN 
end
