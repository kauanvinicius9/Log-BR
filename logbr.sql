IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'logBR') BEGIN
  
CREATE DATABASE LogBR; END
GO

USE LogBR;
GO

-- Logistics Tables
IF OBJECT_ID('dbo.Occurrences', 'U') IS NOT NULL DROP TABLE dbo.Occurrences;
IF OBJECT_ID('dbo.Tracking', 'U') IS NOT NULL DROP TABLE dbo.Tracking;
IF OBJECT_ID('dbo.Shipments', 'U') IS NOT NULL DROP TABLE dbo.Shipments;
IF OBJECT_ID('dbo.Routers', 'U') IS NOT NULL DROP TABLE dbo.Routers;
IF OBJECT_ID('dbo.OrderItem', 'U') IS NOT NULL DROP TABLE dbo.OrderItem;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Stock', 'U') IS NOT NULL DROP TABLE dbo.Stock;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Drivers', 'U') IS NOT NULL DROP TABLE dbo.Drivers;
IF OBJECT_ID('dbo.Vehicles', 'U') IS NOT NULL DROP TABLE dbo.Vehicles;
IF OBJECT_ID('dbo.ShippingCompanies', 'U') IS NOT NULL DROP TABLE dbo.ShippingCompanies;
IF OBJECT_ID('dbo.Warehouse', 'U') IS NOT NULL DROP TABLE dbo.Warehouse;
IF OBJECT_ID('dbo.Suppliers', 'U') IS NOT NULL DROP TABLE dbo.Suppliers;
IF OBJECT_ID('dbo.Clients', 'U') IS NOT NULL DROP TABLE dbo.Clients;
GO

CREATE TABLE dbo.Clients (
  ClientID INT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(150) NOT NULL,
  CPF VARCHAR(20) NOT NULL UNIQUE,
  Email VARCHAR(150) NULL,
  Phone VARCHAR(20) NULL,
  Address NVARCHAR(200) NULL,
  City NVARCHAR(100) NULL,
  State CHAR(2) NULL,
  CEP VARCHAR(10) NULL,
  RegisterDate DATETIME NOT NULL DEFAULT GETDATE(),
  Active BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Suppliers (
  SupplierID INT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(150) NOT NULL,
  CNPJ VARCHAR(20) NOT NULL UNIQUE,
  Email VARCHAR(150) NULL,
  Phone VARCHAR(20) NULL,
  City NVARCHAR(100) NULL,
  State CHAR(2) NULL,
  RegisterDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Warehouse (
  WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(150) NOT NULL,
  Address NVARCHAR(200) NULL,
  City NVARCHAR(100) NULL,
  State CHAR(2) NULL,
  CapacityM3 DECIMAL(10,2) NOT NULL DEFAULT 0,
  Active BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Product (
  ProductID INT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(150) NOT NULL,
  Category NVARCHAR(80) NULL,
  SupplierID INT NULL,
  WeightKG DECIMAL(10,3) NOT NULL DEFAULT 0,
  VolumnM3 DECIMAL(10,3) NOT NULL DEFAULT 0,
  UnityPrice DECIMAL(12,2) NOT NULL DEFAULT 0,
  CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID)
);
GO

CREATE TABLE dbo.ShippingCompanies (
  ShippingCompanyID INT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(150) NOT NULL,
  CNPJ VARCHAR(20) NOT NULL UNIQUE,
  Email VARCHAR(150) NULL,
  Phone VARCHAR(20) NULL
);
GO

CREATE TABLE dbo.Vehicles (
  VehicleID INT IDENTITY(1,1) PRIMARY KEY,
  LicensePlate VARCHAR(10) NOT NULL UNIQUE,
  Type NVARCHAR(50) NOT NULL,
  CapacityKG DECIMAL(10,2) NOT NULL DEFAULT 0,
  CapacityM3 DECIMAL(10,2) NOT NULL DEFAULT 0,
  ShippingCompanyID INT NOT NULL,
  Status NVARCHAR(30) NOT NULL CONSTRAINT DF_Status DEFAULT 'Disponível',
  CONSTRAINT FK_Vehicles_ShippingCompanies FOREIGN KEY (ShippingCompanyID) REFERENCES dbo.ShippingCompanies(ShippingCompanyID)
);
GO

CREATE TABLE dbo.Drivers (
  DriveID INT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(150) NOT NULL,
  CPF VARCHAR(20) NOT NULL UNIQUE,
  CNH VARCHAR(20) NOT NULL UNIQUE,
  CategoryCNH VARCHAR(5) NOT NULL,
  Email VARCHAR(150) NULL,
  Phone VARCHAR(20) NULL,
  ShippingCompanyID INT NOT NULL,
  CONSTRAINT FK_Drivers_ShippingCompanies FOREIGN KEY (ShippingCompanyID) REFERENCES dbo.ShippingCompanies(ShippingCompanyID)
);
GO

CREATE TABLE dbo.Stock (
  StockID INT IDENTITY(1,1) PRIMARY KEY,
  WarehouseID INT NOT NULL,
  ProductID INT NOT NULL,
  Quantity INT NOT NULL DEFAULT 0,
  QuantityMin INT NOT NULL DEFAULT 0,
  UpdateDate DATETIME NOT NULL DEFAULT GETDATE(),
  CONSTRAINT FK_Stock_Warehouses FOREIGN KEY (WarehouseID) REFERENCES dbo.Warehouses(WarehouseID),
  CONSTRAINT FK_Stock_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
  CONSTRAINT UQ_Stock_Warehouse_Product UNIQUE (WarehouseID, ProductID),
  CONSTRAINT CK_Stock_Quantity CHECK (Quantity >= 0)
);
GO

CREATE TABLE dbo.Orders (
  OrderID INT IDENTITY(1,1) PRIMARY KEY,
  ClientID INT NOT NULL,
  WarehouseOriginID INT NOT NULL,
  OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
  OrderStatus NVARCHAR(30) NOT NULL DEFAULT 'Enviado',
  TotalValue DECIMAL(14,2) NOT NULL DEFAULT 0,
  CONSTRAINT FK_Orders_Clients FOREIGN KEY (ClientID) REFERENCES dbo.Clients(ClientID),
  CONSTRAINT FK_Orders_Warehouses FOREIGN KEY (WarehouseOriginID) REFERENCES dbo.Warehouses(WarehouseID),
  CONSTRAINT CK_Orders_Status CHECK (OrderStatus IN ('Enviado','Entregue','Cancelado', 'Atrasado'))
);
GO

CREATE TABLE dbo.OrderItem (
  ItemID INT IDENTITY(1,1) PRIMARY KEY,
  OrderID INT NOT NULL,
  ProductID INT NOT NULL,
  Quantity INT NOT NULL,
  UnityPrice DECIMAL(12,2) NOT NULL,
  CONSTRAINT FK_OrderItem_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID) ON DELETE CASCADE,
  CONSTRAINT FK_OrderItem_Products FOREIGN KEY (ProductID) REFERENCES dbo.Orders(OrderID),
  CONSTRAINT CK_OrderItem_Quantity CHECK (Quantity > 0)
);
GO

CREATE TABLE dbo.Routers (
  RouterID INT IDENTITY(1,1) PRIMARY KEY,
  WarehouseOriginID INT NOT NULL,
  DestinationCity NVARCHAR(100) NOT NULL,
  StateCity CHAR(2) NOT NULL,
  DistanceKM DECIMAL(10,2) NOT NULL,
  TimeInHours DECIMAL(6,2) NOT NULL,
  CONSTRAINT FK_Routers_Warehouses FOREIGN KEY (WarehouseOriginID) REFERENCES dbo.Warehouses(WarehouseID)
);
GO

CREATE TABLE dbo.Shipments (
  ShipmentID INT IDENTITY(1,1) PRIMARY KEY,
  OrderID INT NOT NULL,
  VehicleID INT NOT NULL,
  DriverID INT NOT NULL,
  RouterID INT NOT NULL,
  ExitDate DATETIME NULL,
  EstimatedShipmentDate DATETIME NULL,
  RealShipmentDate DATETIME NULL,
  StatusShipment NVARCHAR(30) NOT NULL DEFAULT 'Entregue',
  CONSTRAINT FK_Shipments_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
  CONSTRAINT FK_Shipments_Vehicles FOREIGN KEY (VehicleID) REFERENCES dbo.Vehicles(VehicleID),
  CONSTRAINT FK_Shipments_Drivers FOREIGN KEY (DriverID) REFERENCES dbo.Drivers(DriverID),
  CONSTRAINT FK_Shipments_Routers FOREIGN KEY (RouterID) REFERENCES dbo.Routers(RouterID),
  CONSTRAINT CK_Shipments_Status CHECK (StatusShipment IN ('Entregue','Atrasado','Cancelado'))
);
GO

CREATE TABLE dbo.Tracking (
  TrackingID INT IDENTITY(1,1) PRIMARY KEY,
  ShipmentID INT NOT NULL,
  DateTime DATETIME NOT NULL DEFAULT GETDATE(),
  Lat DECIMAL(9,6) NOT NULL,
  Long DECIMAL(9,6) NOT NULL,
  ActuallyStatus NVARCHAR(50) NULL,
  CONSTRAINT FK_Tracking_Shipments FOREIGN KEY (ShipmentID) REFERENCES dbo.Shipments(ShipmentID) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Occurrences (
  OccurrenceID INT IDENTITY(1,1) PRIMARY KEY,
  ShipmentID INT NOT NULL,
  TypeOccurrence NVARCHAR(60) NOT NULL,
  Desciption NVARCHAR(400) NULL,
  DateTime DATETIME NOT NULL DEFAULT GETDATE(),
  CONSTRAINT FK_Occurrences_Shipments FOREIGN KEY (ShipmentID) REFERENCES dbo.Shipments(ShipmentID) ON DELETE CASCADE
);
GO

CREATE INDEX IX_Orders_Client ON dbo.Orders(ClientID);
CREATE INDEX IX_Orders_Status ON dbo.Orders(StatusOrder);
CREATE INDEX IX_Shipments_Status ON dbo.Shipments(StatusShipment);
CREATE INDEX IX_Stock_Product ON dbo.Stock(ProductID);
CREATE INDEX IX_Tracking_Shipment_Date ON dbo.Tracking(ShipmentID, DateTime);
GO

INSERT INTO dbo.Clients(Name, CPF, Email, Phone, City, State, CEP) VALUES
('Comércio Silva Ltda', '00.000.000-00', 'contato@silva.com', '(19) 3000-1000', 'Campinas', 'SP', '13010-000'),
('Distribuidora Norte', '11.111.111-00', 'contato@norte.com', '(11) 4000-2000', 'São Paulo', 'SP', '01000-000'),
('Mercantil Oliveira', '55.555.555-55', 'vendas@oliveira.com', '(31) 3100-5000', 'Belo Horizonte', 'MG', '30100-000'),
('Super Atacado Sul', '66.666.666-66', 'compras@sulatacado.com', '(41) 3200-6000', 'Curitiba', 'PR', '80010-000'),
('Comercial Horizonte', '77.777.777-77', 'contato@horizonte.com', '(27) 3300-7000', 'Vitória', 'ES', '29010-000'),
('Rede Nacional LTDA', '88.888.888-88', 'atendimento@redenacional.com', '(71) 3400-8000', 'Salvador', 'BA', '40010-000'),
('Atacado Brasil', '99.999.999-99', 'vendas@atacadobrasil.com', '(51) 3500-9000', 'Porto Alegre', 'RS', '90010-000'),
('Indústria Nova Era', '10.111.222-33', 'compras@novaera.com', '(11) 3555-1000', 'Jundiaí', 'SP', '13200-000'),
('ConstruMais Materiais', '20.222.333-44', 'contato@construmais.com', '(41) 3666-2000', 'Joinville', 'SC', '89200-000'),
('Grupo Alpha', '30.333.444-55', 'logistica@alpha.com', '(21) 3777-3000', 'Rio de Janeiro', 'RJ', '20000-000');
GO

INSERT INTO dbo.Suppliers(Name, CNPJ, Email, City, State) VALUES
('Indústria ABC', '12.345.678/0001-95', 'vendas@abc.com', 'Jundiaí', 'SP'),
('Metalúrgica Delta', '12.222.019/0001-90', 'contato@delta.com', 'Sorocaba', 'SP'),
('Cabos Premium', '12.999.111/0001-89', 'vendas@cabospremium.com', 'Curitiba', 'PR'),
('Ferragens União', '01.111.999/0001-00', 'comercial@uniao.com', 'Joinville', 'SC'),
('Equipamentos Brasil', '10.332.110/0003-10', 'contato@equipbrasil.com', 'Belo Horizonte', 'MG'),
('Vela Automotiva', '05.333.110/0004-01', 'velas@automotivo.com', 'Campinas', 'SP'),
('Espaço Digital', '08.999.888/0001-07', 'dig@espaco.com', 'Rio de Janeiro', 'RJ');
GO

INSERT INTO dbo.Warehouse(Name, Address, City, State, CapacityM3) VALUES
('Armazém Central Campinas', 'Rod. Anhanguera, km 100', 'Campinas', 'SP', 5000.00),
('Armazém São Paulo', 'Av. Marginal Tietê, 1500', 'São Paulo', 'SP', 8500.00),
('Centro Logístico Sul', 'BR-116, km 25', 'Curitiba', 'PR', 6200.00),
('Hub Belo Horizonte', 'Av. Amazonas, 4500', 'Belo Horizonte', 'MG', 4100.00),
('Armazém Nordeste', 'Rod. BR-324, km 12', 'Salvador', 'BA', 7000.00),
('Centro Logístico Rio', 'Av. Brasil, 5000', 'Rio de Janeiro', 'RJ', 5500.00);
GO

INSERT INTO dbo.Products(Name, Category, SupplierID, WeightKg, VolumnM3, UnityPrice) VALUES
('Caixa de Parafusos', 'Ferragens', 1, 5.500, 0.020, 45.90),
('Bobina de Cabo 100m', 'Elétrico', 3, 12.000, 0.080, 210.00),
('Martelo Profissional', 'Ferramentas', 2, 1.200, 0.010, 65.50),
('Chave de Fenda', 'Ferramentas', 2, 0.300, 0.003, 18.90),
('Disjuntor 40A', 'Elétrico', 3, 0.450, 0.002, 39.90),
('Furadeira Elétrica', 'Equipamentos', 5, 2.800, 0.018, 349.90),
('Alicate Universal', 'Ferramentas', 4, 0.600, 0.004, 42.00),
('Rolo de Fita Isolante', 'Elétrico', 3, 0.100, 0.001, 8.50),
('Caixa de Buchas', 'Ferragens', 4, 1.500, 0.008, 28.90),
('Extensão Elétrica 10m', 'Elétrico', 3, 1.800, 0.015, 79.90);
GO

INSERT INTO dbo.ShippingCompanies(Name, CNPJ, Phone, Email) VALUES
('LogExpress Transportes', '33.333.333/0001-99', '(19) 3500-4000', 'operacoes@logexpress.com'),
('Rápido Brasil', '44.444.444/0001-88', '(11) 3600-5000', 'contato@rapidobrasil.com'),
('Carga Sul', '55.555.555/0001-77', '(41) 3700-6000', 'atendimento@cargasul.com'),
('Trans Minas', '66.666.666/0001-66', '(31) 3800-7000', 'operacoes@transminas.com'),
('Alfa Log', '77.777.777/0001-33', '(32) 3500-2332', 'logistica@alfalog.com'),
('Prime Cargo', '88.888.888/0001-38', '(21) 3833-1111', 'prime@primecargo.com');
GO

INSERT INTO dbo.Vehicles(LicensePlate, Type, CapacityKg, CapacityM3, ShippingCompanyID) VALUES
('ABC1D23', 'Caminhão Toco', 4000.00, 20.00, 1),
('DEF4G56', 'Caminhão Truck', 12000.00, 45.00, 1),
('HIJ7K89', 'VUC', 2500.00, 12.00, 2),
('LMN2P34', 'Carreta', 28000.00, 90.00, 3),
('QRS5T67', 'Caminhão Baú', 8000.00, 35.00, 4),
('TUV8W90', 'Caminhão Toco', 5000.00, 25.00, 5),
('XYZ9A12', 'Carreta', 30000.00, 100.00, 6),
('JKL3M45', 'VUC', 3000.00, 15.00, 2),
('NOP6Q78', 'Caminhão Baú', 9000.00, 40.00, 3),
('RST9U01', 'Truck', 15000.00, 55.00, 4);
GO

INSERT INTO dbo.Drivers(Name, CNH, CPF, CategoryCNH, Phone, ShippingCompanyID) VALUES
('João Pereira', '12345678900', '44.444.444-44', 'D', '(19) 99999-0000', 1),
('Carlos Souza', '22345678901', '55.555.555-55', 'E', '(11) 98888-1111', 1),
('Marcos Lima', '32345678902', '66.666.666-66', 'D', '(41) 97777-2222', 2),
('Fernando Alves', '42345678903', '77.777.777-77', 'E', '(31) 96666-3333', 3),
('Ricardo Gomes', '52345678904', '88.888.888-88', 'D', '(71) 95555-4444', 4),
('Paulo Mendes', '62345678905', '99.999.999-99', 'E', '(32) 94444-5555', 5),
('André Martins', '72345678906', '10.111.222-33', 'D', '(21) 93333-6666', 6),
('Lucas Ribeiro', '82345678907', '20.222.333-44', 'E', '(11) 92222-7777', 2),
('Bruno Costa', '92345678908', '30.333.444-55', 'D', '(41) 91111-8888', 3),
('Diego Oliveira', '10345678909', '40.444.555-66', 'E', '(31) 90000-9999', 4);
GO

INSERT INTO dbo.Routers(WarehouseOriginID, DestinationCity, DestinationState, DistanceKM, TimeInHours) VALUES
(1, 'São Paulo', 'SP', 100.00, 2.00),
(1, 'Jundiaí', 'SP', 45.00, 1.00),
(1, 'Campinas', 'SP', 95.00, 2.00),
(1, 'Sorocaba', 'SP', 110.00, 2.50),
(1, 'Florianópolis', 'SC', 300.00, 5.50),
(1, 'Rio de Janeiro', 'RJ', 440.00, 7.00),
(1, 'Recife', 'PE', 810.00, 12.00),
(1, 'Fortaleza', 'CE', 1020.00, 15.00),
(1, 'Niterói', 'RJ', 30.00, 1.00),
(1, 'Porto Alegre', 'RS', 700.00, 10.00);
GO

INSERT INTO dbo.Stock(WarehouseID, ProductID, Quantity, QuantityMin) VALUES
(1, 1, 200, 50),
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
GO

INSERT INTO dbo.Orders(ClientID, WarehouseOriginID, OrderDate, OrderStatus, TotalValue) VALUES
(1, 1, '2026-07-01', 'Entregue', 1500.00),
(2, 2, '2026-04-20', 'Cancelado', 850.50),
(3, 3, '2026-07-20', 'Entregue', 2300.00),
(4, 4, '2025-05-10', 'Entregue', 4200.00),
(5, 5, '2026-02-05', 'Entregue', 980.00),
(6, 6, '2026-01-01', 'Atrasado', 1750.00),
(7, 1, '2024-05-12', 'Entregue', 3200.00),
(8, 2, '2024-06-08', 'Cancelado', 600.00),
(9, 3, '2026-01-01', 'Entregue', 1100.00),
(10, 4, '2023-03-20', 'Entregue', 5000.00);
GO

INSERT INTO dbo.Shipments(OrderID, VehicleID, DriverID, RouterID, ExitDate, EstimatedDeliveryDate, RealDeliveryDate, OrderStatus) VALUES
(1, 1, 1, 1, '2026-07-02', '2026-07-25', '2026-07-23', 'Entregue'),
(2, 2, 2, 2, '2026-04-23', '2026-06-10', NULL, 'Cancelado'),
(3, 3, 3, 3, '2026-07-22', '2026-08-05', '2026-08-15', 'Atrasado'),
(4, 4, 4, 4, '2025-05-12', '2026-06-26', '2026-06-26', 'Entregue'),
(5, 5, 5, 5, '2026-02-09', '2026-03-18', '2026-03-18', 'Entregue'),
(6, 6, 6, 6, '2026-01-02', '2026-01-10', '2026-01-12', 'Atrasado'),
(7, 7, 7, 7, '2024-05-15', '2024-06-20', '2024-06-20', 'Entregue'),
(8, 8, 8, 8, '2024-06-10', '2024-07-20', NULL, 'Cancelado'),
(9, 9, 9, 9, '2026-01-02', '2026-01-12', '2026-01-11', 'Entregue'),
(10, 10, 10, 10, '2023-03-23', '2023-04-21', '2023-04-19', 'Entregue');
GO

INSERT INTO dbo.Occurrences(ShipmentID, OccurrenceType, Description, DateTime) VALUES
(1, 'Cliente ausente', 'Cliente não estava disponível para recebimento', '2026-07-23 12:00:00'),
(3, 'Atraso na entrega', 'Entrega realizada após a data prevista', '2026-08-15 14:30:00'),
(5, 'Avaria no produto', 'Produto chegou com embalagem danificada', '2026-03-18 09:20:00'),
(8, 'Entrega cancelada', 'Pedido cancelado antes da conclusão', '2024-07-18 10:00:00');
GO

INSERT INTO dbo.Tracking(ShipmentID, DateTime, Lat, Long, ActuallyStatus) VALUES
(1, '2026-07-23 08:00:00', -23.5505, -46.6333, 'Em rota'),
(1, '2026-07-23 12:00:00', -23.5200, -46.6200, 'Chegando ao destino'),
(3, '2026-08-15 10:00:00', -22.9056, -47.0608, 'Atrasado'),
(5, '2026-03-18 09:00:00', -23.1791, -45.8872, 'Entregue'),
(8, '2024-06-15 15:30:00', -22.9056, -47.0608, 'Cancelado');
GO

INSERT INTO dbo.OrderItem(OrderID, ProductID, Quantity, UnityPrice) VALUES
(1, 2, 3, 210.00),
(1, 5, 1, 39.90),
(2, 3, 2, 65.50),
(3, 6, 1, 349.90),
(3, 1, 10, 45.90),
(4, 4, 20, 18.90),
(5, 10, 5, 79.90),
(6, 8, 30, 8.50),
(7, 7, 15, 42.00),
(10, 9, 50, 28.90);
GO
