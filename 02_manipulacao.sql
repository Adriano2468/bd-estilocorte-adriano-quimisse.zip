-- ============================================================
-- Projecto de Base de Dados: Estilo & Corte — Gestão de Salão de Beleza e Barbearia
-- Autor: Adriano Quimisse Júnior
-- Ficheiro 2: manipulação dos dados (executar depois do ficheiro 1)
-- ============================================================

USE estilo_corte;

-- ------------------------------------------------------------
-- SELECT SIMPLES (3)
-- ------------------------------------------------------------

-- S1. Esperado: clientes registados desde 01/09/2025, por ordem alfabética (6 linhas)
SELECT id_cliente, nome, telefone, data_registo
FROM cliente
WHERE data_registo >= '2025-09-01'
ORDER BY nome ASC;

-- S2. Esperado: serviços de Barbearia com preço até 200 MZN, do mais barato ao mais caro (4 linhas)
SELECT nome, preco, duracao_min
FROM servico
WHERE categoria = 'Barbearia' AND preco <= 200
ORDER BY preco ASC, nome ASC;

-- S3. Esperado: marcações ainda por realizar (estado Agendada), por data e hora (2 linhas)
SELECT id_marcacao, id_cliente, data_marcacao, hora_inicio, estado
FROM marcacao
WHERE estado = 'Agendada'
ORDER BY data_marcacao, hora_inicio;

-- ------------------------------------------------------------
-- SELECT com JOIN (2)
-- ------------------------------------------------------------

-- J1. Esperado: para cada serviço prestado numa marcação concluída, o cliente,
-- o serviço, o funcionário que o executou e o preço (26 linhas)
SELECT m.id_marcacao, m.data_marcacao, c.nome AS cliente,
       s.nome AS servico, f.nome AS funcionario, i.preco_aplicado
FROM marcacao m
JOIN cliente c        ON c.id_cliente = m.id_cliente
JOIN item_marcacao i  ON i.id_marcacao = m.id_marcacao
JOIN servico s        ON s.id_servico = i.id_servico
JOIN funcionario f    ON f.id_funcionario = i.id_funcionario
WHERE m.estado = 'Concluída'
ORDER BY m.data_marcacao, m.id_marcacao, i.num_item;

-- J2. Esperado: total facturado por funcionário (só marcações concluídas),
-- do que mais facturou para o que menos facturou (18 linhas)
SELECT f.nome AS funcionario, f.funcao,
       COUNT(*) AS servicos_prestados,
       SUM(i.preco_aplicado) AS total_facturado
FROM funcionario f
JOIN item_marcacao i ON i.id_funcionario = f.id_funcionario
JOIN marcacao m      ON m.id_marcacao = i.id_marcacao
WHERE m.estado = 'Concluída'
GROUP BY f.id_funcionario, f.nome, f.funcao
ORDER BY total_facturado DESC;

-- ------------------------------------------------------------
-- UPDATE (2)
-- ------------------------------------------------------------

-- U1. Esperado: 1 linha alterada. O cliente 5 mudou de número de telefone.
UPDATE cliente
SET telefone = '845550101'
WHERE id_cliente = 5;

-- U2. Esperado: 3 linhas alteradas (Manicure, Pedicure e Unhas de gel).
-- Aumento de 10% nos serviços da categoria Unhas.
UPDATE servico
SET preco = preco * 1.10
WHERE categoria = 'Unhas';

-- ------------------------------------------------------------
-- DELETE (1) — respeitando as chaves estrangeiras
-- ------------------------------------------------------------

-- D1. Esperado: eliminar a marcação cancelada n.º 22. Primeiro apagam-se os itens
-- (tabela filha) e só depois a marcação (tabela pai). 1 linha + 1 linha.
DELETE FROM item_marcacao WHERE id_marcacao = 22;
DELETE FROM marcacao      WHERE id_marcacao = 22;

-- ------------------------------------------------------------
-- TESTE DE INTEGRIDADE (1)
-- ------------------------------------------------------------

-- T1. Esperado: ERRO. O cliente 999 não existe, por isso o MySQL rejeita a inserção
-- (Error 1452: Cannot add or update a child row: a foreign key constraint fails).
INSERT INTO marcacao (id_cliente, data_marcacao, hora_inicio, estado)
VALUES (999, '2026-11-01', '10:00:00', 'Agendada');