CREATE SCHEMA [restaurante]
AUTHORIZATION dbo
go

create table restaurante.categoria(
    id INT  IDENTITY(1,1),
    nome varchar(50),
    descricao varchar(50)
)
insert into restaurante.categoria
VALUES
('Hamburger','Hamburger Simples'),
('Hamburger','Hamburger Simples'),
('Hamburger','Hamburger Duplo'),
('Hot-Dog','Dogão dos Crias'),
('Pastel','Pastel do Japa'),
('Misto','Mistinho Quente Classico'),
('Camarão','Camarão Santista'),
('Café','Café'),
('Chá','Chá-fé'),
('Coca','Coca 600ml'),
('Coca Zero','Coca Zero 600ml')
GO

create table restaurante.item(
    id INT  IDENTITY(1,1) 
    ,nome NVARCHAR(50)
    ,valor NUMERIC(19,2)
    ,id_categoria INT 
    ,descricao NVARCHAR(100)
)
GO

create table restaurante.pedido(
    id INT  IDENTITY(1,1)
    ,valor INT
    ,nome_cliente VARCHAR(max)
)
GO

create table restaurante.item_pedido(
    id INT  IDENTITY(1,1) 
    ,id_item INT 
    ,id_pedido INT 
)
GO

create table restaurante.comanda(
    id INT  IDENTITY(1,1)
    ,aberta BIT
    ,valor_total NUMERIC(19,2)
    ,data_venda smalldatetime
)
GO

create table restaurante.comanda_pedido(
    id INT  IDENTITY(1,1)
    ,id_comanda INT 
    ,id_pedido INT 
)
GO
