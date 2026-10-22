-- ============================================================
-- Projecto de Base de Dados: Estilo & Corte — Gestão de Salão de Beleza e Barbearia
-- Autor: Adriano Quimisse Júnior
-- SGBD: MySQL 8 (InnoDB)
-- Ficheiro 1: criação da base de dados, tabelas e inserção de registos
-- ============================================================

DROP DATABASE IF EXISTS estilo_corte;
CREATE DATABASE estilo_corte CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE estilo_corte;

-- ---------- Criação das tabelas ----------

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(100)  NOT NULL,
  funcao         VARCHAR(40)   NOT NULL,
  telefone       VARCHAR(15)   NOT NULL UNIQUE,
  data_admissao  DATE          NOT NULL,
  salario_base   DECIMAL(10,2) NOT NULL CHECK (salario_base > 0)
) ENGINE=InnoDB;

CREATE TABLE utilizador (
  id_utilizador  INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario INT          NOT NULL UNIQUE,
  username       VARCHAR(40)  NOT NULL UNIQUE,
  palavra_passe  CHAR(64)     NOT NULL,
  perfil         VARCHAR(20)  NOT NULL
                 CHECK (perfil IN ('Administrador','Recepcionista','Funcionario')),
  activo         BOOLEAN      NOT NULL DEFAULT TRUE,
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
) ENGINE=InnoDB;

CREATE TABLE cliente (
  id_cliente    INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(100) NOT NULL,
  telefone      VARCHAR(15)  NOT NULL UNIQUE,
  email         VARCHAR(100) UNIQUE,
  data_registo  DATE         NOT NULL
) ENGINE=InnoDB;

CREATE TABLE servico (
  id_servico  INT AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(60)   NOT NULL UNIQUE,
  categoria   VARCHAR(20)   NOT NULL
              CHECK (categoria IN ('Cabelo','Barbearia','Unhas','Estética','Maquilhagem')),
  preco       DECIMAL(10,2) NOT NULL CHECK (preco > 0),
  duracao_min INT           NOT NULL CHECK (duracao_min > 0)
) ENGINE=InnoDB;

CREATE TABLE marcacao (
  id_marcacao   INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente    INT         NOT NULL,
  data_marcacao DATE        NOT NULL,
  hora_inicio   TIME        NOT NULL,
  estado        VARCHAR(15) NOT NULL DEFAULT 'Agendada'
                CHECK (estado IN ('Agendada','Concluída','Cancelada')),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB;

-- Entidade fraca: um item só existe dentro de uma marcação
CREATE TABLE item_marcacao (
  id_marcacao    INT           NOT NULL,
  num_item       INT           NOT NULL,
  id_servico     INT           NOT NULL,
  id_funcionario INT           NOT NULL,
  preco_aplicado DECIMAL(10,2) NOT NULL CHECK (preco_aplicado > 0),
  PRIMARY KEY (id_marcacao, num_item),
  FOREIGN KEY (id_marcacao)    REFERENCES marcacao(id_marcacao),
  FOREIGN KEY (id_servico)     REFERENCES servico(id_servico),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
) ENGINE=InnoDB;

CREATE TABLE pagamento (
  id_pagamento   INT AUTO_INCREMENT PRIMARY KEY,
  id_marcacao    INT           NOT NULL UNIQUE,
  valor          DECIMAL(10,2) NOT NULL CHECK (valor > 0),
  metodo         VARCHAR(15)   NOT NULL
                 CHECK (metodo IN ('Dinheiro','M-Pesa','e-Mola','Cartão')),
  data_pagamento DATE          NOT NULL,
  FOREIGN KEY (id_marcacao) REFERENCES marcacao(id_marcacao)
) ENGINE=InnoDB;

-- ---------- Inserção de registos (ordem imposta pelas chaves estrangeiras) ----------

INSERT INTO funcionario (id_funcionario, nome, funcao, telefone, data_admissao, salario_base) VALUES
  (1, 'Aurora Machava', 'Cabeleireira', '841037311', '2022-02-01', 12000.00),
  (2, 'Celso Mabunda', 'Barbeiro', '841074622', '2022-03-15', 11000.00),
  (3, 'Dulce Cossa', 'Manicure', '841111933', '2022-05-02', 9500.00),
  (4, 'Elton Tembe', 'Barbeiro', '841149244', '2022-06-20', 11000.00),
  (5, 'Fátima Sitoe', 'Esteticista', '841186555', '2022-08-01', 13000.00),
  (6, 'Gilberto Nhaca', 'Barbeiro', '841223866', '2022-09-12', 10500.00),
  (7, 'Helena Chongo', 'Cabeleireira', '841261177', '2023-01-09', 12000.00),
  (8, 'Inácio Matsinhe', 'Barbeiro', '841298488', '2023-02-13', 10500.00),
  (9, 'Jéssica Mondlane', 'Maquilhadora', '841335799', '2023-03-27', 12500.00),
  (10, 'Kelvin Bila', 'Barbeiro', '841373110', '2023-05-08', 10000.00),
  (11, 'Lúcia Zandamela', 'Manicure', '841410421', '2023-06-19', 9500.00),
  (12, 'Mário Cumbe', 'Cabeleireiro', '841447732', '2023-08-14', 12000.00),
  (13, 'Neusa Guambe', 'Esteticista', '841485043', '2023-10-02', 13000.00),
  (14, 'Osvaldo Langa', 'Barbeiro', '841522354', '2024-01-15', 10000.00),
  (15, 'Patrícia Muchanga', 'Cabeleireira', '841559665', '2024-02-26', 11500.00),
  (16, 'Quitéria Maculuve', 'Pedicure', '841596976', '2024-04-08', 9000.00),
  (17, 'Rui Massingue', 'Barbeiro', '841634287', '2024-06-03', 10000.00),
  (18, 'Sandra Uamusse', 'Maquilhadora', '841671598', '2024-07-22', 12500.00),
  (19, 'Tomás Cuinica', 'Recepcionista', '841708909', '2024-09-09', 8500.00),
  (20, 'Vânia Mavie', 'Gerente', '841746220', '2022-01-10', 25000.00);

INSERT INTO utilizador (id_utilizador, id_funcionario, username, palavra_passe, perfil, activo) VALUES
  (1, 1, 'aurora.machava', 'a991e84c62a25c5a972f67c47cd81f31063c2dde905a8428977b0458073465cd', 'Funcionario', 1),
  (2, 2, 'celso.mabunda', '02a3e1fc659a693124e09cc25a8b49249e126cbfa0dddf8f45d4dee4895bf81e', 'Funcionario', 1),
  (3, 3, 'dulce.cossa', '503ae5403efc54b676a4b551f30d9439e42aa4c362e8d21dc37a4250cfa19e17', 'Funcionario', 1),
  (4, 4, 'elton.tembe', 'f4f08752af7e13674acd6ec40c91e4eb069e7e0e92cf1af5dc34876bf26364d9', 'Funcionario', 1),
  (5, 5, 'fatima.sitoe', '8c55ae6c438eb7bc74c65aa600e4bebc93c61916b9f3eb2977b414fbc551359c', 'Funcionario', 1),
  (6, 6, 'gilberto.nhaca', 'f1cff19d391ece0c73a5647ecdba9eb87b15c63f7d2b7116bfc773e6ee52344a', 'Funcionario', 1),
  (7, 7, 'helena.chongo', '7c33eef555ebfd3fe805d1e44b058bae852b191939297bffff78ffc2b29dd9f6', 'Funcionario', 1),
  (8, 8, 'inacio.matsinhe', 'e842b2b00245276406b4feae75355d1721d92f0269044a58eff8149b29de82de', 'Funcionario', 1),
  (9, 9, 'jessica.mondlane', 'b8afb457ed08ad91126d628cafda8f8dfd5d2a0b270fddf3c255345c264a45ff', 'Funcionario', 1),
  (10, 10, 'kelvin.bila', 'b8ea280a518d1b835e32564f18846274e2a3ba6fd38d1562647b0f693113fa1c', 'Funcionario', 1),
  (11, 11, 'lucia.zandamela', '922197c7482f2dd40727759f399482b085a3b3ad79c1d61cb6c96163f42720b8', 'Funcionario', 1),
  (12, 12, 'mario.cumbe', '41d0b37c0667da36948f2822e16ed54692371bb846103968b4bb25e8c7af8d54', 'Funcionario', 1),
  (13, 13, 'neusa.guambe', '27ad6f0e72ea55c1675a824b48d4558d70d442b37e4d0750fa45c64e28658769', 'Funcionario', 1),
  (14, 14, 'osvaldo.langa', 'f09ce8610dc3035e35ca718c7c726c55745e70cdef47bcaa0d5b91a36b0a5ee4', 'Funcionario', 1),
  (15, 15, 'patricia.muchanga', 'f5b5709027e5e61970411edfd809dd8fddd81049b9d5c5c76e0cad1076b995b8', 'Funcionario', 1),
  (16, 16, 'quiteria.maculuve', '123a9a40dc88c6079b3b6e7da4ea21383a8b613cde19cbf3cedff62f87c5fdfe', 'Funcionario', 1),
  (17, 17, 'rui.massingue', 'cc01fd786df85d79703621b3a790cba974e723ca826fb05fb77eb47a52c631b3', 'Funcionario', 1),
  (18, 18, 'sandra.uamusse', '8f842a2a963ef72fdef48cba95ad2136cb87e03e754a9ce2ea0ddbf9c96bc518', 'Funcionario', 1),
  (19, 19, 'tomas.cuinica', '5b2254372b2523e8986c22776dfac4fff8c05c52e80f43dbe41c23da225c74bd', 'Recepcionista', 1),
  (20, 20, 'vania.mavie', 'e008472366b06ff86d962f0508480fe71be7353c4a3db727fffdf6f0faecba27', 'Administrador', 1);

INSERT INTO cliente (id_cliente, nome, telefone, email, data_registo) VALUES
  (1, 'Ana Beatriz Nhantumbo', '822048713', 'ana.nhantumbo@gmail.com', '2025-01-14'),
  (2, 'Bernardo Chilaule', '843103814', 'bernardo.chilaule@gmail.com', '2025-01-22'),
  (3, 'Carla Muianga', '822146139', 'carla.muianga@gmail.com', '2025-02-03'),
  (4, 'Daniel Macamo', '843207628', NULL, '2025-02-18'),
  (5, 'Eva Mucavele', '822243565', 'eva.mucavele@gmail.com', '2025-03-05'),
  (6, 'Fernando Tivane', '843311442', 'fernando.tivane@gmail.com', '2025-03-19'),
  (7, 'Graça Mabjaia', '822340991', NULL, '2025-04-02'),
  (8, 'Hélio Manhiça', '843415256', 'helio.manhica@gmail.com', '2025-04-25'),
  (9, 'Isabel Cuamba', '822438417', 'isabel.cuamba@gmail.com', '2025-05-11'),
  (10, 'João Sumbana', '843519070', 'joao.sumbana@gmail.com', '2025-06-01'),
  (11, 'Karina Mandlate', '822535843', 'karina.mandlate@gmail.com', '2025-06-17'),
  (12, 'Leonel Bambo', '843622884', NULL, '2025-07-08'),
  (13, 'Maria da Luz Fumo', '822633269', 'maria.fumo@gmail.com', '2025-07-29'),
  (14, 'Nelson Come', '843726698', 'nelson.come@gmail.com', '2025-08-14'),
  (15, 'Olga Chissano', '822730695', 'olga.chissano@gmail.com', '2025-09-02'),
  (16, 'Paulo Nhambirre', '843830512', NULL, '2025-09-23'),
  (17, 'Quézia Mazive', '822828121', 'quezia.mazive@gmail.com', '2025-10-10'),
  (18, 'Rafael Zimba', '843934326', 'rafael.zimba@gmail.com', '2025-11-05'),
  (19, 'Salvador Dimande', '822925547', 'salvador.dimande@gmail.com', '2025-12-01'),
  (20, 'Telma Cuna', '844038140', 'telma.cuna@gmail.com', '2026-01-12');

INSERT INTO servico (id_servico, nome, categoria, preco, duracao_min) VALUES
  (1, 'Corte feminino', 'Cabelo', 350.00, 45),
  (2, 'Corte masculino', 'Barbearia', 150.00, 30),
  (3, 'Barba', 'Barbearia', 100.00, 20),
  (4, 'Corte e barba', 'Barbearia', 220.00, 50),
  (5, 'Pentear', 'Cabelo', 300.00, 40),
  (6, 'Tranças', 'Cabelo', 800.00, 180),
  (7, 'Coloração', 'Cabelo', 900.00, 90),
  (8, 'Alisamento', 'Cabelo', 1500.00, 150),
  (9, 'Hidratação capilar', 'Cabelo', 500.00, 60),
  (10, 'Manicure', 'Unhas', 250.00, 45),
  (11, 'Pedicure', 'Unhas', 300.00, 50),
  (12, 'Unhas de gel', 'Unhas', 700.00, 90),
  (13, 'Maquilhagem social', 'Maquilhagem', 900.00, 60),
  (14, 'Maquilhagem de noiva', 'Maquilhagem', 2500.00, 120),
  (15, 'Limpeza de pele', 'Estética', 600.00, 60),
  (16, 'Design de sobrancelhas', 'Estética', 120.00, 20),
  (17, 'Massagem facial', 'Estética', 450.00, 40),
  (18, 'Risco e desenho', 'Barbearia', 100.00, 20),
  (19, 'Corte infantil', 'Barbearia', 100.00, 25),
  (20, 'Pigmentação de barba', 'Barbearia', 350.00, 40);

INSERT INTO marcacao (id_marcacao, id_cliente, data_marcacao, hora_inicio, estado) VALUES
  (1, 1, '2026-09-02', '09:00:00', 'Concluída'),
  (2, 2, '2026-09-03', '10:30:00', 'Concluída'),
  (3, 3, '2026-09-05', '14:00:00', 'Concluída'),
  (4, 4, '2026-09-07', '08:30:00', 'Concluída'),
  (5, 5, '2026-09-09', '09:00:00', 'Concluída'),
  (6, 6, '2026-09-10', '15:30:00', 'Concluída'),
  (7, 7, '2026-09-12', '11:00:00', 'Concluída'),
  (8, 8, '2026-09-14', '13:00:00', 'Concluída'),
  (9, 9, '2026-09-16', '10:00:00', 'Concluída'),
  (10, 10, '2026-09-18', '16:00:00', 'Concluída'),
  (11, 11, '2026-09-21', '09:30:00', 'Concluída'),
  (12, 12, '2026-09-23', '08:00:00', 'Concluída'),
  (13, 13, '2026-09-25', '14:30:00', 'Concluída'),
  (14, 14, '2026-09-27', '07:30:00', 'Concluída'),
  (15, 15, '2026-09-29', '17:00:00', 'Concluída'),
  (16, 16, '2026-10-01', '10:00:00', 'Concluída'),
  (17, 17, '2026-10-03', '11:30:00', 'Concluída'),
  (18, 18, '2026-10-06', '12:00:00', 'Concluída'),
  (19, 19, '2026-10-09', '15:00:00', 'Concluída'),
  (20, 20, '2026-10-12', '09:00:00', 'Concluída'),
  (21, 3, '2026-10-14', '10:00:00', 'Cancelada'),
  (22, 8, '2026-10-16', '16:30:00', 'Cancelada'),
  (23, 1, '2026-10-24', '09:00:00', 'Agendada'),
  (24, 11, '2026-10-25', '11:00:00', 'Agendada');

INSERT INTO item_marcacao (id_marcacao, num_item, id_servico, id_funcionario, preco_aplicado) VALUES
  (1, 1, 1, 1, 350.00),
  (1, 2, 5, 1, 300.00),
  (2, 1, 4, 2, 220.00),
  (3, 1, 10, 3, 250.00),
  (3, 2, 11, 16, 300.00),
  (4, 1, 2, 4, 150.00),
  (5, 1, 6, 7, 800.00),
  (6, 1, 13, 9, 900.00),
  (7, 1, 3, 6, 100.00),
  (8, 1, 8, 12, 1500.00),
  (9, 1, 15, 5, 600.00),
  (9, 2, 16, 5, 120.00),
  (10, 1, 2, 8, 150.00),
  (10, 2, 3, 8, 100.00),
  (11, 1, 12, 11, 700.00),
  (12, 1, 19, 10, 100.00),
  (13, 1, 7, 15, 900.00),
  (14, 1, 14, 18, 2500.00),
  (15, 1, 20, 14, 350.00),
  (15, 2, 2, 14, 150.00),
  (16, 1, 9, 1, 500.00),
  (17, 1, 17, 13, 450.00),
  (18, 1, 18, 17, 100.00),
  (19, 1, 4, 2, 220.00),
  (20, 1, 1, 7, 350.00),
  (20, 2, 9, 7, 500.00),
  (21, 1, 5, 15, 300.00),
  (22, 1, 2, 4, 150.00),
  (23, 1, 7, 15, 900.00),
  (24, 1, 10, 3, 250.00);

INSERT INTO pagamento (id_pagamento, id_marcacao, valor, metodo, data_pagamento) VALUES
  (1, 1, 650.00, 'M-Pesa', '2026-09-02'),
  (2, 2, 220.00, 'e-Mola', '2026-09-03'),
  (3, 3, 550.00, 'Cartão', '2026-09-05'),
  (4, 4, 150.00, 'Dinheiro', '2026-09-07'),
  (5, 5, 800.00, 'M-Pesa', '2026-09-09'),
  (6, 6, 900.00, 'e-Mola', '2026-09-10'),
  (7, 7, 100.00, 'Cartão', '2026-09-12'),
  (8, 8, 1500.00, 'Dinheiro', '2026-09-14'),
  (9, 9, 720.00, 'M-Pesa', '2026-09-16'),
  (10, 10, 250.00, 'e-Mola', '2026-09-18'),
  (11, 11, 700.00, 'Cartão', '2026-09-21'),
  (12, 12, 100.00, 'Dinheiro', '2026-09-23'),
  (13, 13, 900.00, 'M-Pesa', '2026-09-25'),
  (14, 14, 2500.00, 'e-Mola', '2026-09-27'),
  (15, 15, 500.00, 'Cartão', '2026-09-29'),
  (16, 16, 500.00, 'Dinheiro', '2026-10-01'),
  (17, 17, 450.00, 'M-Pesa', '2026-10-03'),
  (18, 18, 100.00, 'e-Mola', '2026-10-06'),
  (19, 19, 220.00, 'Cartão', '2026-10-09'),
  (20, 20, 850.00, 'Dinheiro', '2026-10-12');