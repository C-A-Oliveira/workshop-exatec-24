
declare @dado nvarchar(max) = 'id_item=2'
declare @url nvarchar(max) = 'http://localhost:5000/restaurante/item/'
declare @retorno nvarchar(max)

exec p_get_json @url, @dado, @retorno OUTPUT

select retorno = @retorno
