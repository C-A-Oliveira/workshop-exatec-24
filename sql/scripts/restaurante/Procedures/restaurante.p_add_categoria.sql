CREATE or ALTER PROCEDURE restaurante.p_adicionar_categoria(
    @nome VARCHAR(50),
    @descricao VARCHAR(50) NULL,
    @retorno VARCHAR(max) = 'Categoria adicionada' OUTPUT,
    @cd_retorno int = 0 OUTPUT
)

AS
begin   
    -- diferença entre isnull() e is (not) null
    IF isnull(@nome,'') <> '' or @descricao is NULL
    BEGIN
        SELECT @retorno = 'Valores nulos ou vazios.', @cd_retorno = 1
        RETURN
    END
    
    IF EXISTS (select top 1 1 from restaurante.categoria where nome = @nome and descricao = @descricao)
    BEGIN
        SELECT @retorno = 'Categoria já existe.', @cd_retorno = 1
        RETURN
    END
    
    insert into restaurante.categoria
    select @nome, @descricao

    RETURN 
end
