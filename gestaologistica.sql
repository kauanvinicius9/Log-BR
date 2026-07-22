IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GestaoLogistica')
BEGIN 
	CREATE DATABASE GestaoLogistica;
END
GO

USE GestaoLogistica;
GO

IF OBJECT_ID('dbo.Ocorrencias', 'U') IS NOT NULL DROP TABLE dbo.Ocorrencias;
IF OBJECT_ID('dbo.Rastreamento', 'U') IS NOT NULL DROP TABLE dbo.Rastreamento;
IF OBJECT_ID('dbo.Entregas', 'U') IS NOT NULL DROP TABLE dbo.Entregas;
IF OBJECT_ID('dbo.Rotas', 'U') IS NOT NULL DROP TABLE dbo.Rotas;
IF OBJECT_ID('dbo.ItensPedido', 'U') IS NOT NULL DROP TABLE dbo.ItensPedidos;
IF OBJECT_ID('dbo.Pedidos', 'U') IS NOT NULL DROP TABLE dbo.Pedidos;
IF OBJECT_ID('dbo.Estoque', 'U') IS NOT NULL DROP TABLE dbo.Estoque;
IF OBJECT_ID('dbo.Produtos', 'U') IS NOT NULL DROP TABLE dbo.Produtos;
IF OBJECT_ID('dbo.Motorista', 'U') IS NOT NULL DROP TABLE dbo.Motorista;
IF OBJECT_ID('dbo.Veiculos', 'U') IS NOT NULL DROP TABLE dbo.Veiculos;
IF OBJECT_ID('dbo.Transportadoras', 'U') IS NOT NULL DROP TABLE dbo.Transportadoras;
IF OBJECT_ID('dbo.Armazens', 'U') IS NOT NULL DROP TABLE dbo.Armazens;
IF OBJECT_ID('dbo.Fornecedores', 'U') IS NOT NULL DROP TABLE dbo.Fornecedores;
IF OBJECT_ID('dbo.Clientes', 'U') IS NOT NULL DROP TABLE dbo.Clientes;
GO

CREATE TABLE dbo.Clientes (
	ClienteID INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(150) NOT NULL,
	CPF VARCHAR(20) NOT NULL UNIQUE,
	Email VARCHAR(150) NULL,
	Telefone VARCHAR(20) NULL,
	Endereco NVARCHAR(200) NULL,
	Cidade NVARCHAR(100) NULL,
	Estado CHAR(2) NULL,
	CEP VARCHAR(10) NULL,
	DataCadastro DATETIME NOT NULL DEFAULT GETDATE(),
	Ativo BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Fornecedores (
	FornecedorID INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(150) NOT NULL,
	CNPJ VARCHAR(20) NOT NULL UNIQUE,
	Email VARCHAR(150) NULL,
	Telefone VARCHAR(20) NULL,
	Cidade NVARCHAR(100) NULL,
	Estado CHAR(2) NULL,
	DataCadastro DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Armazens (
	ArmazemID INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(150) NOT NULL,
	Endereco NVARCHAR(200) NULL,
	Cidade NVARCHAR(100) NULL,
	Estado CHAR(2) NULL,
	CapacidadeM3 DECIMAL(10,2) NOT NULL DEFAULT 0,
	Ativo BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Produtos (
	ProdutoID INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(150) NOT NULL,
	Categoria NVARCHAR(80) NULL,
	FornecedorID INT NULL,
	PesoKG DECIMAL(10,3) NOT NULL DEFAULT 0,
	VolumeM3 DECIMAL(10,3) NOT NULL DEFAULT 0,
	PrecoUnitario DECIMAL(12,2) NOT NULL DEFAULT 0
	CONSTRAINT FK_Produtos_Fornecedores FOREIGN KEY (FornecedorID) REFERENCES dbo.Fornecedores(FornecedorID)
);
GO

CREATE TABLE dbo.Transportadoras (
	TransportadoraID INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(150) NOT NULL,
	CNPJ VARCHAR(20) NOT NULL UNIQUE,
	Email VARCHAR(150) NULL,
	Telefone VARCHAR(20) NULL
);
GO

CREATE TABLE dbo.Veiculos (
	VeiculoId INT IDENTITY(1,1) PRIMARY KEY,
	Placa VARCHAR(10) NOT NULL UNIQUE,
	Tipo NVARCHAR(50) NOT NULL,
	CapacidadeKG DECIMAL(10,2) NOT NULL DEFAULT 0,
	CapacidadeM3 DECIMAL(10,2) NOT NULL DEFAULT 0,
	TransportadoraID INT NOT NULL,
	Status NVARCHAR(30) NOT NULL 
		CONSTRAINT DF_Status DEFAULT 'Disponível'

	CONSTRAINT FK_Veiculos_Transportadoras
		FOREIGN KEY (TransportadoraID) REFERENCES dbo.Transportadoras(TransportadoraID)
);
GO

CREATE TABLE dbo.Motoristas (
	MotoristaId INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(150) NOT NULL,
	CPF VARCHAR(20) NOT NULL UNIQUE,
	CNH VARCHAR(20) NOT NULL UNIQUE,
	CategoriaCNH VARCHAR(5) NOT NULL,
	Email VARCHAR(150) NULL,
	Telefone VARCHAR(20) NULL,
	TransportadoraID INT NOT NULL,
	CONSTRAINT FK_Motoristas_Transportadoras
		FOREIGN KEY (TransportadoraID) REFERENCES dbo.Transportadoras(TransportadoraID)
);
GO

CREATE TABLE dbo.Estoque (
	EstoqueID INT IDENTITY(1,1) PRIMARY KEY,
	ArmazemID INT NOT NULL,
	ProdutoID INT NOT NULL,
	Quantidade INT NOT NULL DEFAULT 0,
	QuantidadeMin INT NOT NULL DEFAULT 0,
	DataAtualizacao DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Estoque_Armazens FOREIGN KEY (ArmazemID) REFERENCES dbo.Armazens(ArmazemID),
    CONSTRAINT FK_Estoque_Produtos FOREIGN KEY (ProdutoID) REFERENCES dbo.Produtos(ProdutoID),
    CONSTRAINT UQ_Estoque_Armazem_Produto UNIQUE (ArmazemID, ProdutoID),
    CONSTRAINT CK_Estoque_Quantidade CHECK (Quantidade >= 0)
);
GO

CREATE TABLE dbo.Pedidos (
	PedidoID INT IDENTITY(1,1) PRIMARY KEY,
	ClienteID INT NOT NULL,
	ArmazemOrigemID INT NOT NULL,
	DataPedido DATETIME NOT NULL DEFAULT GETDATE(),
	StatusPedido NVARCHAR(30) NOT NULL DEFAULT 'Pendente',
	ValorTotal DECIMAL(14,2) NOT NULL DEFAULT 0,
	CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (ClienteID) REFERENCES dbo.Clientes(ClienteID),
    CONSTRAINT FK_Pedidos_Armazens FOREIGN KEY (ArmazemOrigemID) REFERENCES dbo.Armazens(ArmazemID),
    CONSTRAINT CK_Pedidos_Status CHECK (StatusPedido IN ('Pendente','Em Preparo','Enviado','Entregue','Cancelado'))
);
GO

CREATE TABLE dbo.ItensPedido (
	ItemID INT IDENTITY(1,1) PRIMARY KEY,
	PedidoID INT NOT NULL,
	ProdutoID INT NOT NULL,
	Quantidade INT NOT NULL,
	PrecoUnitario DECIMAL(12,2) NOT NULL,
	CONSTRAINT FK_ItensPedido_Pedidos FOREIGN KEY (PedidoID) REFERENCES dbo.Pedidos(PedidoID) ON DELETE CASCADE,
    CONSTRAINT FK_ItensPedido_Produtos FOREIGN KEY (ProdutoID) REFERENCES dbo.Produtos(ProdutoID),
    CONSTRAINT CK_ItensPedido_Quantidade CHECK (Quantidade > 0)
);
GO

CREATE TABLE dbo.Rotas (
	RotaID INT IDENTITY(1,1) PRIMARY KEY,
	ArmazemOrigemID INT NOT NULL,
	CidadeDestino NVARCHAR(100) NOT NULL,
	EstadoDestino CHAR(2) NOT NULL,
	DistanciaKM DECIMAL(10,2) NOT NULL,
	TempoEstimadoHoras DECIMAL(6,2) NOT NULL,
	CONSTRAINT FK_Rotas_Armazens FOREIGN KEY (ArmazemOrigemID) REFERENCES dbo.Armazens(ArmazemID)
);
GO

CREATE TABLE dbo.Entregas (
	EntregaID INT IDENTITY(1,1) PRIMARY KEY,
	PedidoID INT NOT NULL,
	VeiculoID INT NOT NULL,
	MotoristaID INT NOT NULL,
	RotaID INT NOT NULL,
	DataSaida DATETIME NULL,
	DataEntregaPrevista DATETIME NULL,
	DataEntregaReal DATETIME NULL,
	StatusEntrega NVARCHAR(30) NOT NULL DEFAULT 'Aguardando',
	CONSTRAINT FK_Entregas_Pedidos FOREIGN KEY (PedidoID) REFERENCES dbo.Pedidos(PedidoID),
    CONSTRAINT FK_Entregas_Veiculos FOREIGN KEY (VeiculoID) REFERENCES dbo.Veiculos(VeiculoID),
    CONSTRAINT FK_Entregas_Motoristas FOREIGN KEY (MotoristaID) REFERENCES dbo.Motoristas(MotoristaID),
    CONSTRAINT FK_Entregas_Rotas FOREIGN KEY (RotaID) REFERENCES dbo.Rotas(RotaID),
    CONSTRAINT CK_Entregas_Status CHECK (StatusEntrega IN ('Aguardando','Em Trânsito','Entregue','Atrasada','Cancelada'))

);
GO

CREATE TABLE dbo.Rastreamento (
	RastreamentoID INT IDENTITY(1,1) PRIMARY KEY,
	EntregaID INT NOT NULL,
	DataHora DATETIME NOT NULL DEFAULT GETDATE(),
	Latitude DECIMAL(9,6) NOT NULL,
	Longitude DECIMAL(9,6) NOT NULL,
	StatusAnual NVARCHAR(50) NULL,
	CONSTRAINT FK_Rastreamento_Entregas FOREIGN KEY (EntregaID) REFERENCES dbo.Entregas(EntregaID) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Ocorrencias (
	OcorrenciaID INT IDENTITY(1,1) PRIMARY KEY,
	EntregaID INT NOT NULL,
	TipoOcorrencia NVARCHAR(60) NOT NULL,
	Descricao NVARCHAR(400) NULL,
	DataHora DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Ocorrencias_Entregas FOREIGN KEY (EntregaID) REFERENCES dbo.Entregas(EntregaID) ON DELETE CASCADE
);
GO

CREATE INDEX IX_Pedidos_Cliente ON dbo.Pedidos(ClienteID);
CREATE INDEX IX_Pedidos_Status ON dbo.Pedidos(StatusPedido);
CREATE INDEX IX_Entregas_Status ON dbo.Entregas(StatusEntrega);
CREATE INDEX IX_Estoque_Produto ON dbo.Estoque(ProdutoID);
CREATE INDEX IX_Rastreamento_Entrega_Data ON dbo.Rastreamento(EntregaID, DataHora);
GO
 
CREATE OR ALTER VIEW dbo.vw_EstoqueBaixo AS
SELECT a.Nome AS Armazem, p.Nome AS Produto, e.Quantidade, e.QuantidadeMin
FROM dbo.Estoque e JOIN dbo.Armazens a ON a.ArmazemID = e.ArmazemID JOIN dbo.Produtos p ON p.ProdutoID = e.ProdutoID
WHERE e.Quantidade <= e.QuantidadeMin;
GO

CREATE OR ALTER VIEW dbo.vw_PedidosPendentes AS
SELECT pe.PedidoID, c.Nome AS Cliente, pe.DataPedido, pe.StatusPedido, pe.ValorTotal
FROM dbo.Pedidos pe JOIN dbo.Clientes c ON c.ClienteID = pe.ClienteID
WHERE pe.StatusPedido IN ('Pendente','Em Preparo');
GO
 
CREATE OR ALTER VIEW dbo.vw_EntregasEmAndamento AS
SELECT en.EntregaID, pe.PedidoID, v.Placa, m.Nome AS Motorista, r.CidadeDestino, en.DataSaida, en.DataEntregaPrevista, en.StatusEntrega
FROM dbo.Entregas en JOIN dbo.Pedidos pe ON pe.PedidoID = en.PedidoID JOIN dbo.Veiculos v ON v.VeiculoID = en.VeiculoID JOIN dbo.Motoristas m ON m.MotoristaID = en.MotoristaID JOIN dbo.Rotas r ON r.RotaID = en.RotaID
WHERE en.StatusEntrega IN ('Aguardando','Em Trânsito');
GO
 
CREATE OR ALTER PROCEDURE dbo.sp_InserirPedido @ClienteID INT, @ArmazemOrigemID INT, @ItensJson NVARCHAR(MAX) AS

BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
 
        DECLARE @PedidoID INT;
        INSERT INTO dbo.Pedidos (ClienteID, ArmazemOrigemID, StatusPedido, ValorTotal)
        VALUES (@ClienteID, @ArmazemOrigemID, 'Pendente', 0);
        SET @PedidoID = SCOPE_IDENTITY();
        INSERT INTO dbo.ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario)

        SELECT @PedidoID, j.ProdutoID, j.Quantidade, p.PrecoUnitario
        FROM OPENJSON(@ItensJson)
        WITH (
            ProdutoID  INT '$.ProdutoID',
            Quantidade INT '$.Quantidade'
        ) j

        JOIN dbo.Produtos p ON p.ProdutoID = j.ProdutoID;
 
        UPDATE dbo.Pedidos
        SET ValorTotal = (
            SELECT SUM(Quantidade * PrecoUnitario)
            FROM dbo.ItensPedido
            WHERE PedidoID = @PedidoID
        )

        WHERE PedidoID = @PedidoID;
        COMMIT TRANSACTION;
        SELECT @PedidoID AS PedidoIDCriado;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE OR ALTER PROCEDURE dbo.sp_AtualizarStatusEntrega @EntregaID INT, @NovoStatus NVARCHAR(30) AS

BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
 
        UPDATE dbo.Entregas
        SET StatusEntrega = @NovoStatus, DataEntregaReal = CASE WHEN @NovoStatus = 'Entregue' THEN GETDATE() ELSE DataEntregaReal END
        WHERE EntregaID = @EntregaID;
 
        IF @NovoStatus = 'Entregue'
        BEGIN UPDATE p SET p.StatusPedido = 'Entregue' FROM dbo.Pedidos p JOIN dbo.Entregas e ON e.PedidoID = p.PedidoID WHERE e.EntregaID = @EntregaID;
        END
 
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE OR ALTER TRIGGER dbo.trg_BaixaEstoque
ON dbo.ItensPedido
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
 
    UPDATE e
    SET e.Quantidade = e.Quantidade - i.Quantidade, e.DataAtualizacao = GETDATE()
    FROM dbo.Estoque e JOIN inserted i ON i.ProdutoID = e.ProdutoID JOIN dbo.Pedidos p ON p.PedidoID = i.PedidoID AND p.ArmazemOrigemID = e.ArmazemID;
END
GO
 
INSERT INTO dbo.Clientes (Nome, CPF, Email, Telefone, Cidade, Estado, CEP)
VALUES ('Comércio Silva Ltda', '00.000.000-00', 'contato@silva.com', '(19) 3000-1000', 'Campinas', 'SP', '13010-000'),
       ('Distribuidora Norte', '11.111.111-00', 'contato@norte.com', '(11) 4000-2000', 'São Paulo', 'SP', '01000-000'),
       ('Mercantil Oliveira', '55.555.555-55', 'vendas@oliveira.com', '(31) 3100-5000', 'Belo Horizonte', 'MG', '30100-000'),
       ('Super Atacado Sul', '66.666.666-66', 'compras@sulatacado.com', '(41) 3200-6000', 'Curitiba', 'PR', '80010-000'),
       ('Comercial Horizonte', '77.777.777-77', 'contato@horizonte.com', '(27) 3300-7000', 'Vitória', 'ES', '29010-000'),
       ('Rede Nacional LTDA', '88.888.888-88', 'atendimento@redenacional.com', '(71) 3400-8000', 'Salvador', 'BA', '40010-000'),
       ('Atacado Brasil', '99.999.999-99', 'vendas@atacadobrasil.com', '(51) 3500-9000', 'Porto Alegre', 'RS', '90010-000');

INSERT INTO dbo.Fornecedores (Nome, CNPJ, Email, Cidade, Estado)
VALUES ('Indústria ABC', '12.345.678/0001-95', 'vendas@abc.com', 'Jundiaí', 'SP'),
       ('Metalúrgica Delta', '12.222.019/0001-90', 'contato@delta.com', 'Sorocaba', 'SP'),
       ('Cabos Premium', '12.999.111/0001-89', 'vendas@cabospremium.com', 'Curitiba', 'PR'),
       ('Ferragens União', '01.111.999/0001-00', 'comercial@uniao.com', 'Joinville', 'SC'),
       ('Equipamentos Brasil', '10.332.110/0003-10', 'contato@equipbrasil.com', 'Belo Horizonte', 'MG'),
	   ('Vela Automotiva', '05.333.110/004-01', 'velas@automotivo.com', 'Campinas', 'SP'),
	   ('Espaço Digital', '08.999.888/001-07', 'dig@espaco.com', 'Trindade', 'RJ');

INSERT INTO dbo.Armazens (Nome, Endereco, Cidade, Estado, CapacidadeM3)
VALUES ('Armazém Central Campinas', 'Rod. Anhanguera, km 100', 'Campinas', 'SP', 5000.00),
       ('Armazém São Paulo', 'Av. Marginal Tietê, 1500', 'São Paulo', 'SP', 8500.00),
       ('Centro Logístico Sul', 'BR-116, km 25', 'Curitiba', 'PR', 6200.00),
       ('Hub Belo Horizonte', 'Av. Amazonas, 4500', 'Belo Horizonte', 'MG', 4100.00),
       ('Armazém Nordeste', 'Rod. BR-324, km 12', 'Salvador', 'BA', 7000.00),
	   ('Armazém Sul', 'Av. General 8403', 'Gramado', 'MG', 3800.00),
	   ('Centro Automotivo', 'R. Santos Dumont-43', 'Ceilândia', 'DF', 9000.20);

INSERT INTO dbo.Produtos (Nome, Categoria, FornecedorID, PesoKg, VolumeM3, PrecoUnitario)
VALUES ('Caixa de Parafusos', 'Ferragens', 1, 5.500, 0.020, 45.90),
       ('Bobina de Cabo 100m', 'Elétrico', 1, 12.000, 0.080, 210.00),
       ('Martelo Profissional', 'Ferramentas', 2, 1.200, 0.010, 65.50),
       ('Chave de Fenda', 'Ferramentas', 2, 0.300, 0.003, 18.90),
       ('Disjuntor 40A', 'Elétrico', 3, 0.450, 0.002, 39.90),
       ('Furadeira Elétrica', 'Equipamentos', 5, 2.800, 0.018, 349.90),
       ('Alicate Universal', 'Ferramentas', 4, 0.600, 0.004, 42.00),
       ('Rolo de Fita Isolante', 'Elétrico', 3, 0.100, 0.001, 8.50),
       ('Caixa de Buchas', 'Ferragens', 4, 1.500, 0.008, 28.90),
       ('Extensão Elétrica 10m', 'Elétrico', 3, 1.800, 0.015, 79.90);

INSERT INTO dbo.Estoque (ArmazemID, ProdutoID, Quantidade, QuantidadeMin)
VALUES (1, 1, 200, 50),
       (1, 2, 80, 20),
       (1, 3, 120, 30),
       (2, 1, 350, 70),
       (2, 4, 500, 100),
       (2, 5, 250, 60),
       (3, 6, 90, 20),
       (3, 7, 180, 40),
       (4, 8, 600, 120),
       (5, 9, 300, 50),
       (5, 10, 150, 30);

INSERT INTO dbo.Transportadoras (Nome, CNPJ, Telefone, Email)
VALUES ('LogExpress Transportes', '33.333.333/0001-99', '(19) 3500-4000', 'operacoes@logexpress.com'),
       ('Rápido Brasil', '44.444.444/0001-88', '(11) 3600-5000', 'contato@rapidobrasil.com'),
       ('Carga Sul', '55.555.555/0001-77', '(41) 3700-6000', 'atendimento@cargasul.com'),
       ('Trans Minas', '66.666.666/0001-66', '(31) 3800-7000', 'operacoes@transminas.com'),
	   ('Alfa Log', '77.777.777/0001-33', '(32) 3500-2332', 'logistica@alfasul.com'),
	   ('Prime Cargo', '88.888.888/001-38', '(10) 8322-1111', 'prime@carga.com');

INSERT INTO dbo.Veiculos (Placa, Tipo, CapacidadeKg, CapacidadeM3, TransportadoraID)
VALUES ('ABC1D23', 'Caminhão Toco', 4000.00, 20.00, 1),
       ('DEF4G56', 'Caminhão Truck', 12000.00, 45.00, 1),
       ('HIJ7K89', 'VUC', 2500.00, 12.00, 2),
       ('LMN2P34', 'Carreta', 28000.00, 90.00, 3),
       ('QRS5T67', 'Caminhão Baú', 8000.00, 35.00, 4);

INSERT INTO dbo.Motoristas (Nome, CNH, CPF, CategoriaCNH, Telefone, TransportadoraID)
VALUES ('João Pereira', '12345678900', '44.444.444-44', 'D', '(19) 99999-0000', 1),
       ('Carlos Souza', '22345678901', '55.555.555-55', 'E', '(11) 98888-1111', 1),
       ('Marcos Lima', '32345678902', '66.666.666-66', 'D', '(41) 97777-2222', 2),
       ('Fernando Alves', '42345678903', '77.777.777-77', 'E', '(31) 96666-3333', 3),
       ('Ricardo Gomes', '52345678904', '88.888.888-88', 'D', '(71) 95555-4444', 4);

INSERT INTO dbo.Rotas (ArmazemOrigemID, CidadeDestino, EstadoDestino, DistanciaKM, TempoEstimadoHoras)
VALUES (1, 'São Paulo', 'SP', 100.00, 2.00),
       (1, 'Jundiaí', 'SP', 45.00, 1.00),
       (2, 'Campinas', 'SP', 95.00, 2.00),
       (2, 'Sorocaba', 'SP', 110.00, 2.50),
       (3, 'Florianópolis', 'SC', 300.00, 5.50),
       (4, 'Rio de Janeiro', 'RJ', 440.00, 7.00),
       (5, 'Recife', 'PE', 810.00, 12.00),
       (5, 'Fortaleza', 'CE', 1020.00, 15.00);