CREATE SCHEMA [restaurante]
AUTHORIZATION dbo
go

create table restaurante.categoria(
    id INT PRIMARY KEY IDENTITY(1,1),
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
    id INT PRIMARY KEY IDENTITY(1,1) 
    ,nome VARCHAR(50)
    ,valor NUMERIC(19,2)
    ,id_categoria INT FOREIGN KEY REFERENCES restaurante.categoria(id)
    ,descricao VARCHAR(100)
)
GO

create table restaurante.pedido(
    id INT PRIMARY KEY IDENTITY(1,1)
    ,valor INT
    ,nome_cliente VARCHAR(max)
)
GO

create table restaurante.item_pedido(
    id INT PRIMARY KEY IDENTITY(1,1) 
    ,id_item INT FOREIGN KEY REFERENCES restaurante.item(id)
    ,id_pedido INT FOREIGN KEY REFERENCES restaurante.pedido(id)
)
GO

create table restaurante.comanda(
    id INT PRIMARY KEY IDENTITY(1,1)
    ,aberta BIT
    ,valor_total NUMERIC(19,2)
    ,data_venda smalldatetime
)
GO

create table restaurante.comanda_pedido(
    id INT PRIMARY KEY IDENTITY(1,1)
    ,id_comanda INT FOREIGN KEY REFERENCES restaurante.comanda(id)
    ,id_pedido INT FOREIGN KEY REFERENCES restaurante.pedido(id)
)
GO
