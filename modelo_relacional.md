Modelo Relacional — Estilo & Corte (Salão de Beleza e Barbearia)

Autor: Adriano Quimisse Júnior


Notação: PK = chave primária, FK = chave estrangeira (→ tabela referenciada).


Tabelas

funcionario (id_funcionario, nome, funcao, telefone, data_admissao, salario_base)


utilizador (id_utilizador, id_funcionario → funcionario [único], username, palavra_passe, perfil, activo)


cliente (id_cliente, nome, telefone, email, data_registo)


servico (id_servico, nome, categoria, preco, duracao_min)


marcacao (id_marcacao, id_cliente → cliente, data_marcacao, hora_inicio, estado)


item_marcacao (id_marcacao, num_item, id_servico → servico, id_funcionario → funcionario, preco_aplicado)
— entidade fraca: PK composta; id_marcacao é também FK → marcacao.


pagamento (id_pagamento, id_marcacao → marcacao [único], valor, metodo, data_pagamento)


Chaves estrangeiras

Tabela filha	Coluna	Tabela pai	Relação
utilizador	id_funcionario	funcionario	1:1 (funcionário possui 0 ou 1 utilizador)
marcacao	id_cliente	cliente	1:N (cliente faz 0..N marcações)
item_marcacao	id_marcacao	marcacao	1:N identificadora (marcação contém 1..N itens)
item_marcacao	id_servico	servico	1:N (serviço incide em 0..N itens)
item_marcacao	id_funcionario	funcionario	1:N (funcionário executa 0..N itens)
pagamento	id_marcacao	marcacao	1:1 (marcação é paga por 0 ou 1 pagamento)

Restrições principais


telefone único em funcionario e cliente; email único em cliente; username único em utilizador.

perfil ∈ {Administrador, Recepcionista, Funcionario}.

categoria ∈ {Cabelo, Barbearia, Unhas, Estética, Maquilhagem}.

estado ∈ {Agendada, Concluída, Cancelada}.

metodo ∈ {Dinheiro, M-Pesa, e-Mola, Cartão}.

Preços, salários, valores e durações são sempre maiores que zero.

Ordem de criação/inserção: funcionario → utilizador → cliente → servico → marcacao → item_marcacao → pagamento.

