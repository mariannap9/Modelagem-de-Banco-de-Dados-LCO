# Trabalho de Banco de Dados — Sistema Escolar

**Disciplina:** Banco de Dados, 4º período
**Domínio:** Sistema Escolar, matrícula de alunos em disciplinas oferecidas por professores
**Alunos:** Marianna Castro, Vanessa Toledo

---

##  Sumário

* [1. Contexto e decisões da entrevista de requisitos](#1-contexto-e-decisões-da-entrevista-de-requisitos)
* [2. Entidades e atributos](#2-entidades-e-atributos)
* [3. Chaves](#3-chaves)
* [4. Relacionamentos e cardinalidades](#4-relacionamentos-e-cardinalidades)
* [5. Regras de negócio](#5-regras-de-negócio)
* [6. Dicionário de dados](#6-dicionário-de-dados)
* [7. Diagrama](#7-diagrama)
* [8. Implementação](#8-implementação)

---

## 1. Contexto e decisões da entrevista de requisitos

Durante a entrevista com o professor, foram levantadas as seguintes regras que orientaram a construção do modelo de dados:

| Pergunta                       | Resposta                                                                | Impacto no modelo                                                 |
| ------------------------------ | ----------------------------------------------------------------------- | ----------------------------------------------------------------- |
| Quantos cursos são oferecidos? | 10, com nome único                                                      | Entidade `Curso`, atributo `nome` com restrição `UNIQUE`          |
| Quantos alunos por turma?      | Mínimo 10, máximo 25                                                    | Entidade `Turma`, com `CHECK` de capacidade                       |
| Forma de ingresso              | ENEM, Vestibular Próprio (2x/ano), Transferência, Portador de Diploma   | Entidade `Forma_Ingresso`                                         |
| Matrícula                      | Chave estrangeira obrigatória / relação total                           | `Matricula` sempre referencia um `Aluno` e uma `Turma` existentes |
| Identificação do aluno         | CPF                                                                     | Atributo `cpf` do `Aluno`, único e obrigatório                    |
| Instrução básica               | Relação 1:1 com forma de ingresso; apresentar conclusão do Ensino Médio | Entidade `Instrucao_Basica`, com relação 1:1 com `Aluno`          |

---

## 2. Entidades e atributos

###  Curso

| Campo                 | Descrição                    |
| --------------------- | ---------------------------- |
| `id_curso`            | Chave primária               |
| `nome`                | Nome único do curso          |
| `carga_horaria_total` | Carga horária total do curso |

###  Forma_Ingresso

| Campo               | Descrição        |
| ------------------- | ---------------- |
| `id_forma_ingresso` | Chave primária   |
| `tipo`              | Tipo de ingresso |

Tipos previstos:

* ENEM
* Vestibular Próprio
* Transferência
* Portador de Diploma

### Aluno

| Campo             | Descrição               |
| ----------------- | ----------------------- |
| `id_aluno`        | Chave primária          |
| `nome`            | Nome completo           |
| `cpf`             | CPF único e obrigatório |
| `data_nascimento` | Data de nascimento      |
| `email`           | E-mail de contato       |
| `id_curso`        | FK para `Curso`         |

###  Instrucao_Basica

| Campo                | Descrição                                               |
| -------------------- | ------------------------------------------------------- |
| `id_instrucao`       | Chave primária                                          |
| `id_aluno`           | FK para `Aluno`, com `UNIQUE` para garantir relação 1:1 |
| `instituicao_origem` | Instituição de ensino de origem                         |
| `ano_conclusao_em`   | Ano de conclusão do Ensino Médio                        |
| `id_forma_ingresso`  | FK para `Forma_Ingresso`                                |

###  Professor

| Campo          | Descrição              |
| -------------- | ---------------------- |
| `id_professor` | Chave primária         |
| `nome`         | Nome completo          |
| `cpf`          | CPF único              |
| `titulacao`    | Titulação do professor |

###  Disciplina

| Campo           | Descrição                   |
| --------------- | --------------------------- |
| `id_disciplina` | Chave primária              |
| `nome`          | Nome da disciplina          |
| `carga_horaria` | Carga horária da disciplina |
| `id_curso`      | FK para `Curso`             |

###  Turma

A entidade `Turma` representa a oferta de uma disciplina por um professor em determinado semestre.

Ela também é utilizada para controlar a quantidade de alunos matriculados.

| Campo               | Descrição                                   |
| ------------------- | ------------------------------------------- |
| `id_turma`          | Chave primária                              |
| `id_disciplina`     | FK para `Disciplina`                        |
| `id_professor`      | FK para `Professor`                         |
| `semestre`          | Semestre da oferta, por exemplo `2026/2`    |
| `capacidade_maxima` | Capacidade da turma, limitada entre 10 e 25 |

###  Matricula

A entidade `Matricula` funciona como entidade associativa entre `Aluno` e `Turma`, resolvendo o relacionamento **N:N**.

| Campo            | Descrição                   |
| ---------------- | --------------------------- |
| `id_matricula`   | Chave primária              |
| `id_aluno`       | FK obrigatória para `Aluno` |
| `id_turma`       | FK obrigatória para `Turma` |
| `data_matricula` | Data da matrícula           |
| `status`         | Situação da matrícula       |

Status possíveis:

* `ATIVA`
* `CANCELADA`
* `CONCLUIDA`

---

## 3. Chaves

###  Chaves Primárias (PK)

Cada entidade possui uma chave primária formada por um identificador `id_*` autoincrementável:

* `Curso.id_curso`
* `Forma_Ingresso.id_forma_ingresso`
* `Aluno.id_aluno`
* `Instrucao_Basica.id_instrucao`
* `Professor.id_professor`
* `Disciplina.id_disciplina`
* `Turma.id_turma`
* `Matricula.id_matricula`

###  Chaves Estrangeiras (FK)

As seguintes chaves estrangeiras estabelecem os relacionamentos entre as entidades:

```text
Aluno.id_curso
    → Curso.id_curso

Instrucao_Basica.id_aluno
    → Aluno.id_aluno

Instrucao_Basica.id_forma_ingresso
    → Forma_Ingresso.id_forma_ingresso

Disciplina.id_curso
    → Curso.id_curso

Turma.id_disciplina
    → Disciplina.id_disciplina

Turma.id_professor
    → Professor.id_professor

Matricula.id_aluno
    → Aluno.id_aluno

Matricula.id_turma
    → Turma.id_turma
```

###  Chaves candidatas / alternativas

Os seguintes atributos possuem restrição `UNIQUE`:

* `Aluno.cpf`
* `Professor.cpf`
* `Curso.nome`
* `Forma_Ingresso.tipo`

---

## 4. Relacionamentos e cardinalidades

| Relacionamento                        | Cardinalidade | Leitura                                                                             |
| ------------------------------------- | ------------: | ----------------------------------------------------------------------------------- |
| `Curso` — `Aluno`                     |       **1:N** | Um curso possui vários alunos; um aluno pertence a um único curso                   |
| `Curso` — `Disciplina`                |       **1:N** | Um curso possui várias disciplinas                                                  |
| `Aluno` — `Instrucao_Basica`          |       **1:1** | Todo aluno possui exatamente um registro de instrução básica                        |
| `Instrucao_Basica` — `Forma_Ingresso` |       **N:1** | Vários alunos podem utilizar a mesma forma de ingresso                              |
| `Professor` — `Turma`                 |       **1:N** | Um professor pode lecionar várias turmas                                            |
| `Disciplina` — `Turma`                |       **1:N** | Uma disciplina pode possuir várias turmas                                           |
| `Aluno` — `Turma`                     |       **N:M** | Um aluno pode se matricular em várias turmas e uma turma pode possuir vários alunos |

### Relacionamento N:M

O relacionamento entre `Aluno` e `Turma` é resolvido pela entidade associativa `Matricula`:

```text
Aluno
  1
  │
  │
  N
Matricula
  N
  │
  │
  1
Turma
```

Dessa forma:

> Um aluno pode possuir várias matrículas e uma turma pode possuir vários alunos matriculados.

---

## 5. Regras de negócio

1. Todo aluno deve possuir um **CPF único e obrigatório**.
2. Toda matrícula deve estar obrigatoriamente vinculada a um **aluno e a uma turma existentes**.
3. Uma turma deve possuir capacidade entre **10 e 25 alunos**.
4. Todo aluno deve possuir um registro de `Instrucao_Basica`, contendo o **ano de conclusão do Ensino Médio** e a **forma de ingresso**.
5. O nome de cada curso deve ser único.
6. O tipo de cada forma de ingresso deve ser único.
7. O CPF de cada professor deve ser único.

---

# 6. Dicionário de dados

O dicionário de dados apresenta as tabelas, campos, tipos de dados, restrições e suas respectivas descrições.

## 6.1 Tabela `curso`

| Campo                 | Tipo           | Restrição            | Descrição                    |
| --------------------- | -------------- | -------------------- | ---------------------------- |
| `id_curso`            | `INTEGER`      | `PK`                 | Identificador do curso       |
| `nome`                | `VARCHAR(100)` | `UNIQUE`, `NOT NULL` | Nome do curso                |
| `carga_horaria_total` | `INTEGER`      | —                    | Carga horária total do curso |

---

## 6.2 Tabela `forma_ingresso`

| Campo               | Tipo          | Restrição            | Descrição                          |
| ------------------- | ------------- | -------------------- | ---------------------------------- |
| `id_forma_ingresso` | `INTEGER`     | `PK`                 | Identificador da forma de ingresso |
| `tipo`              | `VARCHAR(50)` | `UNIQUE`, `NOT NULL` | Tipo de ingresso                   |

**Valores previstos:**

```text
ENEM
VESTIBULAR PROPRIO
TRANSFERENCIA
PORTADOR DE DIPLOMA
```

---

## 6.3 Tabela `aluno`

| Campo             | Tipo           | Restrição            | Descrição                      |
| ----------------- | -------------- | -------------------- | ------------------------------ |
| `id_aluno`        | `INTEGER`      | `PK`                 | Identificador do aluno         |
| `nome`            | `VARCHAR(150)` | `NOT NULL`           | Nome completo                  |
| `cpf`             | `CHAR(11)`     | `UNIQUE`, `NOT NULL` | CPF do aluno                   |
| `data_nascimento` | `DATE`         | —                    | Data de nascimento             |
| `email`           | `VARCHAR(150)` | —                    | E-mail de contato              |
| `id_curso`        | `INTEGER`      | `FK`, `NOT NULL`     | Curso ao qual o aluno pertence |

**FK:** `id_curso` → `curso.id_curso`

---

## 6.4 Tabela `instrucao_basica`

| Campo                | Tipo           | Restrição                  | Descrição                        |
| -------------------- | -------------- | -------------------------- | -------------------------------- |
| `id_instrucao`       | `INTEGER`      | `PK`                       | Identificador                    |
| `id_aluno`           | `INTEGER`      | `FK`, `UNIQUE`, `NOT NULL` | Aluno relacionado; garante 1:1   |
| `instituicao_origem` | `VARCHAR(150)` | —                          | Escola de origem                 |
| `ano_conclusao_em`   | `INTEGER`      | `NOT NULL`                 | Ano de conclusão do Ensino Médio |
| `id_forma_ingresso`  | `INTEGER`      | `FK`, `NOT NULL`           | Forma de ingresso                |

**FKs:**

```text
id_aluno
    → aluno.id_aluno

id_forma_ingresso
    → forma_ingresso.id_forma_ingresso
```

---

## 6.5 Tabela `professor`

| Campo          | Tipo           | Restrição            | Descrição                  |
| -------------- | -------------- | -------------------- | -------------------------- |
| `id_professor` | `INTEGER`      | `PK`                 | Identificador do professor |
| `nome`         | `VARCHAR(150)` | `NOT NULL`           | Nome completo              |
| `cpf`          | `CHAR(11)`     | `UNIQUE`, `NOT NULL` | CPF do professor           |
| `titulacao`    | `VARCHAR(50)`  | —                    | Ex.: Mestre, Doutor        |

---

## 6.6 Tabela `disciplina`

| Campo           | Tipo           | Restrição        | Descrição                   |
| --------------- | -------------- | ---------------- | --------------------------- |
| `id_disciplina` | `INTEGER`      | `PK`             | Identificador da disciplina |
| `nome`          | `VARCHAR(100)` | `NOT NULL`       | Nome da disciplina          |
| `carga_horaria` | `INTEGER`      | `NOT NULL`       | Carga horária em horas      |
| `id_curso`      | `INTEGER`      | `FK`, `NOT NULL` | Curso ao qual pertence      |

**FK:** `id_curso` → `curso.id_curso`

---

## 6.7 Tabela `turma`

| Campo               | Tipo          | Restrição        | Descrição                         |
| ------------------- | ------------- | ---------------- | --------------------------------- |
| `id_turma`          | `INTEGER`     | `PK`             | Identificador da turma            |
| `id_disciplina`     | `INTEGER`     | `FK`, `NOT NULL` | Disciplina ofertada               |
| `id_professor`      | `INTEGER`     | `FK`, `NOT NULL` | Professor responsável             |
| `semestre`          | `VARCHAR(10)` | `NOT NULL`       | Semestre da oferta, ex.: `2026/2` |
| `capacidade_maxima` | `INTEGER`     | `CHECK (10–25)`  | Limite de alunos na turma         |

**FKs:**

```text
id_disciplina
    → disciplina.id_disciplina

id_professor
    → professor.id_professor
```

---

## 6.8 Tabela `matricula`

| Campo            | Tipo          | Restrição        | Descrição                  |
| ---------------- | ------------- | ---------------- | -------------------------- |
| `id_matricula`   | `INTEGER`     | `PK`             | Identificador da matrícula |
| `id_aluno`       | `INTEGER`     | `FK`, `NOT NULL` | Aluno matriculado          |
| `id_turma`       | `INTEGER`     | `FK`, `NOT NULL` | Turma da matrícula         |
| `data_matricula` | `DATE`        | `NOT NULL`       | Data da matrícula          |
| `status`         | `VARCHAR(20)` | `CHECK`          | Situação da matrícula      |

**Valores permitidos para `status`:**

```text
ATIVA
CANCELADA
CONCLUIDA
```

**FKs:**

```text
id_aluno
    → aluno.id_aluno

id_turma
    → turma.id_turma
```

---

# 7. Diagrama Entidade-Relacionamento

O diagrama entidade-relacionamento foi desenvolvido utilizando o **DrawDB**.

### Modelo do banco de dados

![Diagrama do Sistema Escolar](./diagrama.png)

> **Arquivo editável:** `diagrama.ddb`
> **Imagem:** `diagrama.png`

O arquivo `.ddb` contém o modelo desenvolvido no DrawDB, enquanto a imagem apresenta uma versão visual do diagrama para consulta rápida.

---

# 8.  Implementação

O arquivo [`schema.sql`](./schema.sql) contém a implementação do banco de dados, incluindo:

* Criação das tabelas;
* Chaves primárias (`PK`);
* Chaves estrangeiras (`FK`);
* Restrições `UNIQUE`;
* Restrições `NOT NULL`;
* Restrições `CHECK`;
* Relacionamentos entre as entidades.

O script foi desenvolvido para execução no **SQL Editor do Supabase (PostgreSQL)**.

###  Estrutura do repositório

```text
sistema-escolar/
│
├── README.md
├── diagrama.png
├── diagrama.ddb
└── schema.sql
```

---

##  Integrantes

**Marianna Castro**
**Vanessa Toledo**

---

###  Onde encontrar?
* drawDB: https://www.drawdb.app/share/Yxsw7V015e-5ZGQk5YphQUmX
* Supabase: https://supabase.com/dashboard/project/ucrwerkcelhdcocstcia/settings/general  **OR** PROJECT ID: ucrwerkcelhdcocstcia
