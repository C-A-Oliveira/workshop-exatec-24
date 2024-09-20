create or alter function busca_categoria(
    @id_categoria int
)
returns varchar(max)

begin
    declare @cat varchar(max) = ''
    
    IF not EXISTS (select top 1 1 from restaurante.categoria where id = @id_categoria)
    BEGIN        
        RETURN null
    END

    select @cat = concat(nome, ' - ', descricao)
    from restaurante.categoria
    where id = @id_categoria
    
    return @cat
end