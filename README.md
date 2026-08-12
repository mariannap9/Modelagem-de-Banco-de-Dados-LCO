Repositório com a modelagem de dados de três domínios diferentes, implementados no Supabase (PostgreSQL). Este README serve como ponto de partida: explica a estrutura do repositório, as convenções adotadas e onde encontrar cada informação.

* Sumário
* Visão geral
* Estrutura do repositório
* Domínios modelados
* Convenções e regras do projeto
* Regras de negócio (resumo por domínio)
* Como executar
* Diagramas
* Glossário rápido
* Como contribuir / alterar o modelo
* Visão geral

Este projeto contém a modelagem completa (entidades, atributos, chaves, relacionamentos, regras de negócio e scripts de criação) de três sistemas independentes entre si:

Domínio	Descrição	Status
Grupo A	Sistema Escolar — matrícula de alunos em disciplinas (Modelado e implementado)
Grupo B	Comércio Eletrônico — pedidos e itens de pedido	(Modelado e implementado)
Grupo C	Clínica Veterinária Expandida — vacinas, aplicações e prescrições	(Modelado e implementado)

Cada domínio é um banco de dados independente, ou seja, não compartilham tabelas nem chaves estrangeiras entre si.

Estrutura do repositório
.
├── README.md                          # este arquivo — visão geral e regras
├── documentacao-modelagem-bd.md       # documentação técnica completa (entidades,
│                                       # atributos, chaves, cardinalidades, dicionário
│                                       # de dados e diagramas de cada domínio)
├── grupo-a-sistema-escolar.sql        # script de criação das tabelas do Grupo A
├── grupo-b-ecommerce.sql              # script de criação das tabelas do Grupo B
└── grupo-c-clinica-veterinaria.sql    # script de criação das tabelas do Grupo C

Regra de organização: toda alteração na estrutura de um domínio (nova tabela, nova coluna, nova regra de negócio) deve ser refletida em dois lugares: no arquivo .sql correspondente (a implementação) e na seção correspondente de documentacao-modelagem-bd.md (a documentação). Um sem o outro é considerado uma entrega incompleta.

Domínios modelados
Grupo A — Sistema Escolar

Entidades: Aluno, Professor, Disciplina, Matricula. Ideia central: alunos se matriculam em disciplinas oferecidas por professores; Matricula é a tabela que resolve o relacionamento N:N entre Aluno e Disciplina.

Grupo B — Comércio Eletrônico

Entidades: Cliente, Produto, Pedido, ItemPedido. Ideia central: um cliente faz pedidos; cada pedido é composto por vários itens, e cada item aponta para um produto — ItemPedido resolve o relacionamento N:N entre Pedido e Produto.

Grupo C — Clínica Veterinária Expandida

Entidades-base: Tutor, Veterinario, Animal, Consulta. Entidades da expansão: Vacina, AplicacaoVacina, Medicamento, Prescricao. Ideia central: animais pertencem a tutores e passam por consultas com veterinários; AplicacaoVacina resolve o N:N entre Animal e Vacina, e Prescricao resolve o N:N entre Consulta e Medicamento.

Descrição completa de cada entidade (atributos, tipos, chaves, cardinalidades e dicionário de dados) está em documentacao-modelagem-bd.md.

Convenções e regras do projeto

Estas são as regras que todo o modelo segue, para manter consistência entre os três domínios:

Chave primária: toda tabela usa uuid gerado por gen_random_uuid() como chave primária, nomeada id_<entidade> (ex.: id_aluno, id_produto).
Nomenclatura: nomes de tabelas e colunas em português, minúsculas, no formato snake_case (palavras separadas por _). Nunca usar espaços, acentos ou maiúsculas em nomes de tabela/coluna.
Chave estrangeira: sempre nomeada como id_<entidade_referenciada> (ex.: disciplina.id_professor aponta para professor.id_professor).
Exclusão em cascata (on delete cascade vs. on delete restrict):
cascade quando o registro "filho" não tem sentido sem o "pai" (ex.: excluir um Pedido remove seus ItemPedido).
restrict quando a exclusão deve ser bloqueada até tratamento manual (ex.: não se exclui um Produto já vendido).
Validações simples → CHECK/UNIQUE; validações que dependem de outras linhas → TRIGGER. Exemplo: nota entre 0 e 10 é CHECK; verificar vagas disponíveis contando matrículas já existentes é TRIGGER.
Enumerações de status (ex.: status de pedido, status de matrícula) são implementadas como text + CHECK, e não como ENUM nativo do PostgreSQL — isso facilita adicionar ou remover valores permitidos no futuro sem precisar de ALTER TYPE.
Segurança (RLS): toda tabela tem Row Level Security habilitado. Nenhuma tabela fica aberta por padrão — o acesso via API só é liberado pelas políticas (policy) explicitamente definidas no script.
Datas de auditoria: colunas como created_at/data_cadastro usam timestamptz (data e hora com fuso horário) com valor padrão now(), preenchidas automaticamente pelo banco.
Regras de negócio — resumo por domínio

Cada domínio tem cinco regras de negócio detalhadas na documentação completa. Resumo:

Grupo A — Sistema Escolar

Aluno não pode se matricular duas vezes na mesma disciplina.
Matrícula só é aceita se houver vagas na disciplina.
Nota final entre 0 e 10.
Frequência entre 0% e 100%.
Status da matrícula restrito a valores predefinidos.

Grupo B — Comércio Eletrônico

Todo pedido deve ter ao menos um item.
Quantidade do item não pode exceder o estoque disponível.
Valor total do pedido é sempre a soma dos subtotais dos itens.
Pedido cancelado devolve a quantidade ao estoque.
Preço unitário do item reflete o preço no momento da compra (histórico).

Grupo C — Clínica Veterinária Expandida

Dose aplicada não pode exceder o total de doses previstas na vacina.
Nova dose só é aplicada após o intervalo mínimo definido.
Não é permitido duplicar o registro da mesma dose para o mesmo animal.
Toda prescrição deve estar vinculada a uma consulta existente.
Só é possível prescrever medicamentos marcados como ativos no catálogo.

Detalhamento de como cada regra é aplicada (via CHECK, UNIQUE ou TRIGGER) está na seção correspondente de documentacao-modelagem-bd.md.

Como executar
Crie (ou acesse) um projeto no Supabase.
Abra SQL Editor no menu lateral do projeto.
Cole o conteúdo do arquivo .sql do domínio desejado e clique em Run.
Repita para os demais domínios — a ordem de execução não importa, pois são independentes.

Passo a passo detalhado, incluindo observações sobre RLS, está na seção 8 de documentacao-modelagem-bd.md.

Diagramas

Os diagramas Entidade-Relacionamento (DER) de cada domínio estão descritos em notação Mermaid dentro de documentacao-modelagem-bd.md (renderizam automaticamente no GitHub ao visualizar o arquivo). Para gerar o mesmo diagrama de forma visual no drawDB, siga o passo a passo da seção 7 do mesmo documento — a ferramenta importa o .sql diretamente e monta o diagrama sozinha.

Glossário rápido
Termo	Significado
PK	Chave primária — identifica cada linha de forma única.
FK	Chave estrangeira — vincula uma tabela a outra.
N:N	Relacionamento muitos-para-muitos, resolvido por uma tabela associativa.
RLS	Segurança em nível de linha — controla quem pode ler/alterar cada linha.
Trigger	Função executada automaticamente pelo banco antes/depois de uma alteração.
DER	Diagrama Entidade-Relacionamento.

Glossário completo, com mais termos e exemplos, na seção 2 de documentacao-modelagem-bd.md.

Como contribuir / alterar o modelo

Ao propor qualquer mudança na modelagem:

Atualize o script .sql do domínio afetado.
Atualize a seção correspondente em documentacao-modelagem-bd.md (entidades, dicionário de dados e, se necessário, o diagrama Mermaid).
Se a mudança adicionar ou alterar uma regra de negócio, atualize também a lista de "cinco regras de negócio" do domínio e o resumo neste README.
Descreva no commit/pull request o quê mudou e por quê — isso mantém o histórico do repositório como uma fonte confiável de decisões de projeto, não só de código.
