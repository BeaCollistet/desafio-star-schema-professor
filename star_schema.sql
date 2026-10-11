-- Star Schema: análise de Professores (Universidade)
-- Campos marcados com (*) não existem no diagrama relacional original:
-- foram supostos, como pede o enunciado do desafio.

CREATE SCHEMA IF NOT EXISTS dw_universidade;
USE dw_universidade;

-- ---------- DIMENSÕES ----------

CREATE TABLE dim_professor (
    sk_professor     INT AUTO_INCREMENT PRIMARY KEY,
    id_professor     INT NOT NULL,             -- id no banco relacional
    nome_professor   VARCHAR(60),              -- (*)
    titulacao        VARCHAR(30),              -- (*)
    e_coordenador    CHAR(1)                   -- 'S' ou 'N' (vem de Departamento.idProfessor_coordenador)
);

CREATE TABLE dim_departamento (
    sk_departamento          INT AUTO_INCREMENT PRIMARY KEY,
    id_departamento          INT NOT NULL,
    nome                     VARCHAR(45),
    campus                   VARCHAR(45),
    id_professor_coordenador INT
);

CREATE TABLE dim_curso (
    sk_curso    INT AUTO_INCREMENT PRIMARY KEY,
    id_curso    INT NOT NULL,
    nome_curso  VARCHAR(60),                   -- (*)
    nivel       VARCHAR(20)                    -- (*) ex.: graduação, pós
);

CREATE TABLE dim_disciplina (
    sk_disciplina      INT AUTO_INCREMENT PRIMARY KEY,
    id_disciplina      INT NOT NULL,
    nome_disciplina    VARCHAR(60),            -- (*)
    qtd_prerequisitos  INT DEFAULT 0           -- vem de "Pré-requisitos das disciplinas"
);

CREATE TABLE dim_data (
    sk_data    INT PRIMARY KEY,                -- formato AAAAMMDD, ex.: 20250310
    data       DATE NOT NULL,
    dia        TINYINT,
    mes        TINYINT,
    nome_mes   VARCHAR(12),
    trimestre  TINYINT,
    semestre   TINYINT,
    ano        SMALLINT
);

-- ---------- FATO ----------
-- Granularidade: 1 linha por professor x disciplina x curso x data de oferta

CREATE TABLE fato_oferta_disciplina (
    sk_professor        INT NOT NULL,
    sk_departamento     INT NOT NULL,
    sk_curso            INT NOT NULL,
    sk_disciplina       INT NOT NULL,
    sk_data_oferta      INT NOT NULL,
    qtd_ofertas         INT NOT NULL DEFAULT 1,  -- sempre 1, serve para contar
    carga_horaria_horas INT,                     -- (*)
    PRIMARY KEY (sk_professor, sk_departamento, sk_curso, sk_disciplina, sk_data_oferta),
    FOREIGN KEY (sk_professor)    REFERENCES dim_professor (sk_professor),
    FOREIGN KEY (sk_departamento) REFERENCES dim_departamento (sk_departamento),
    FOREIGN KEY (sk_curso)        REFERENCES dim_curso (sk_curso),
    FOREIGN KEY (sk_disciplina)   REFERENCES dim_disciplina (sk_disciplina),
    FOREIGN KEY (sk_data_oferta)  REFERENCES dim_data (sk_data)
);
