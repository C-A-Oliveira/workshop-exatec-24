
declare @dado nvarchar(max) = 'id_categoria=2'
declare @url nvarchar(max) = 'http://localhost:5000/restaurante/categorias/'
declare @retorno nvarchar(max)

exec p_get_json @url, @dado, @retorno OUTPUT

select retorno = @retorno
