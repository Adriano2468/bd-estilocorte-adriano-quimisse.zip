# bd-estilocorte-adriano-quimisse.zip
Estilo & Corte — Base de Dados de um Salão de Beleza e Barbearia

Autor: Adriano Quimisse Júnior
Curso: Licenciatura em Informática, 2.º ano — Universidade Licungo
Disciplina: Tecnologias de Base de Dados
Título: Estilo & Corte
Tema: Gestão de um Salão de Beleza e Barbearia
SGBD: MySQL 8 (InnoDB)
Vídeo de apresentação: (colar aqui o link do YouTube)


1. Descrição do problema

Um salão de beleza e barbearia atende clientes que pedem serviços de cabelo, barba, unhas, estética e maquilhagem. Hoje, as marcações e os pagamentos são anotados em cadernos e mensagens de telemóvel. Isso provoca marcações sobrepostas, esquecimento de clientes, preços diferentes para o mesmo serviço e dificuldade em saber quanto cada profissional facturou no mês.


Este projecto propõe uma base de dados que organiza toda a operação. O salão regista os seus funcionários (cabeleireiros, barbeiros, manicures, esteticistas, maquilhadoras, recepção e gerência) e o respectivo utilizador de acesso ao sistema. Guarda também os clientes e o catálogo de serviços com preço e duração.


Quando um cliente marca uma visita, cria-se uma marcação com data, hora e estado (Agendada, Concluída ou Cancelada). Cada marcação tem um ou mais itens: cada item é um serviço executado por um funcionário concreto, com o preço aplicado nesse dia. Uma marcação concluída é paga com um pagamento (dinheiro, M-Pesa, e-Mola ou cartão). Assim, o salão consegue consultar a agenda, o histórico dos clientes e a facturação por funcionário ou por serviço.


2. Regras de negócio


Cada funcionário tem um telefone único e uma função (por exemplo, Barbeiro ou Manicure).

Cada funcionário pode ter no máximo uma conta de utilizador, e cada utilizador pertence a um só funcionário.

O perfil do utilizador é Administrador, Recepcionista ou Funcionario.

Cada cliente tem um telefone único; o e-mail é opcional, mas, se existir, é único.

Um cliente pode fazer muitas marcações; cada marcação pertence a um só cliente.

Uma marcação tem de ter pelo menos um item; os itens só existem dentro de uma marcação (entidade fraca).

Cada item refere um serviço e o funcionário que o executa, e guarda o preço aplicado (o preço do catálogo pode mudar depois).

O estado de uma marcação é Agendada, Concluída ou Cancelada.

Cada marcação tem no máximo um pagamento, e o valor deve corresponder à soma dos preços dos seus itens.

O método de pagamento é Dinheiro, M-Pesa, e-Mola ou Cartão.

Preços, salários, valores e durações têm de ser maiores que zero.


3. Sistema web previsto (Programação Web)

A mesma base de dados servirá de suporte a um sistema web de gestão do salão:



Utilizadores: gerente (administração), recepcionista (agenda e caixa) e funcionários (consulta da sua agenda). Cada um entra com username e palavra-passe.

Registar: clientes, serviços, marcações e pagamentos, através de formulários.

Listar e pesquisar: agenda do dia, clientes por nome ou telefone, serviços por categoria.

Alterar e eliminar: reagendar ou cancelar marcações, actualizar preços e contactos.

Relatórios: facturação por funcionário, por serviço e por método de pagamento.


4. Diagrama ER

Diagrama ER


5. Conteúdo do repositório

bd-estilocorte-adriano-quimisse/
  README.md
  diagrama_er.png
  modelo_relacional.md
  01_criacao_e_insercao.sql
  02_manipulacao.sql

6. Como executar

mysql -u root -p < 01_criacao_e_insercao.sql
mysql -u root -p < 02_manipulacao.sql

O ficheiro 01 cria a base estilo_corte, as 7 tabelas e insere pelo menos 20 registos em cada uma. O ficheiro 02 contém os comandos de manipulação; o último (teste de integridade) falha de propósito, para mostrar a chave estrangeira em acção.

