create or alter function restaurante.f_get_categoria(
    @id_categoria int
)
returns varchar(max)

begin
    declare @cat varchar(max) = ''
    
    IF not EXISTS (select top 1 1 from restaurante.categoria where id = @id_categoria)
    BEGIN        
        RETURN 'Categoria inexistente.'
    END

    select @cat = concat(nome, ' - ', descricao)
    from restaurante.categoria
    where id = @id_categoria
    
    return @cat
end