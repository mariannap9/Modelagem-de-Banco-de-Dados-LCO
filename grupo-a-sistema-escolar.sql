-- =========================================================
-- Banco de Dados: Sistema Escolar (Grupo A)
-- Trabalho de Banco de Dados - 4º período
-- =========================================================
-- Ordem de criação respeita as dependências de chave estrangeira:
-- curso e forma_ingresso primeiro (não dependem de ninguém),
-- depois aluno, instrucao_basica, professor, disciplina,
-- depois turma, e por último matricula.

CREATE TABLE curso (
    id_curso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    carga_horaria_total INTEGER
);

CREATE TABLE forma_ingresso (
    id_forma_ingresso SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL UNIQUE
        CHECK (tipo IN ('ENEM', 'VESTIBULAR PROPRIO', 'TRANSFERENCIA', 'PORTADOR DE DIPLOMA'))
);

CREATE TABLE aluno (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    email VARCHAR(150),
    id_curso INTEGER NOT NULL REFERENCES curso(id_curso)
);

-- 1:1 com aluno (o UNIQUE em id_aluno garante que cada aluno
-- só pode ter UM registro de instrução básica)
CREATE TABLE instrucao_basica (
    id_instrucao SERIAL PRIMARY KEY,
    id_aluno INTEGER NOT NULL UNIQUE REFERENCES aluno(id_aluno),
    instituicao_origem VARCHAR(150),
    ano_conclusao_em INTEGER NOT NULL,
    id_forma_ingresso INTEGER NOT NULL REFERENCES forma_ingresso(id_forma_ingresso)
);

CREATE TABLE professor (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    titulacao VARCHAR(50)
);

CREATE TABLE disciplina (
    id_disciplina SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INTEGER NOT NULL,
    id_curso INTEGER NOT NULL REFERENCES curso(id_curso)
);

-- Turma = oferta de uma disciplina, por um professor, em um semestre
CREATE TABLE turma (
    id_turma SERIAL PRIMARY KEY,
    id_disciplina INTEGER NOT NULL REFERENCES disciplina(id_disciplina),
    id_professor INTEGER NOT NULL REFERENCES professor(id_professor),
    semestre VARCHAR(10) NOT NULL,
    capacidade_maxima INTEGER NOT NULL CHECK (capacidade_maxima BETWEEN 10 AND 25)
);

-- Entidade associativa entre aluno e turma (resolve o N:M)
CREATE TABLE matricula (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INTEGER NOT NULL REFERENCES aluno(id_aluno),
    id_turma INTEGER NOT NULL REFERENCES turma(id_turma),
    data_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVA'
        CHECK (status IN ('ATIVA', 'CANCELADA', 'CONCLUIDA')),
    UNIQUE (id_aluno, id_turma) -- impede matricular o mesmo aluno 2x na mesma turma
);

-- =========================================================
-- Dados de exemplo (opcional, ajuda a testar as consultas)
-- =========================================================
INSERT INTO curso (nome, carga_horaria_total) VALUES
    ('Ciência da Computação', 3200),
    ('Engenharia de Software', 3200);

INSERT INTO forma_ingresso (tipo) VALUES
    ('ENEM'), ('VESTIBULAR PROPRIO'), ('TRANSFERENCIA'), ('PORTADOR DE DIPLOMA');
