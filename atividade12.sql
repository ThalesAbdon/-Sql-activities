-- Criação do schema
CREATE SCHEMA IF NOT EXISTS `escola_informatica` DEFAULT CHARACTER SET utf8;
USE `escola_informatica`;

-- Criação da tabela PROFESSOR
CREATE TABLE IF NOT EXISTS `PROFESSOR` (
  `cpf` VARCHAR(11) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `titulacao` VARCHAR(100) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`cpf`)
) ENGINE = InnoDB;

-- Criação da tabela ALUNO
CREATE TABLE IF NOT EXISTS `ALUNO` (
  `codigo_matricula` INT NOT NULL AUTO_INCREMENT,
  `data_matricula` DATE NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `endereco` TEXT NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `altura` DECIMAL(5,2) NOT NULL,
  `peso` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`codigo_matricula`)
) ENGINE = InnoDB;

-- Criação da tabela TURMA
CREATE TABLE IF NOT EXISTS `TURMA` (
  `id_turma` INT NOT NULL AUTO_INCREMENT,
  `quantidade_alunos` INT NOT NULL,
  `horario_aula` TIME NOT NULL,
  `duracao_aula` INT NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NOT NULL,
  `tipo_curso` VARCHAR(100) NOT NULL,
  `cpf_professor` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`id_turma`),
  FOREIGN KEY (`cpf_professor`) REFERENCES `PROFESSOR`(`cpf`)
) ENGINE = InnoDB;

-- Criação da tabela MONITOR
CREATE TABLE IF NOT EXISTS `MONITOR` (
  `codigo_matricula` INT NOT NULL,
  `id_turma` INT NOT NULL,
  PRIMARY KEY (`codigo_matricula`, `id_turma`),
  FOREIGN KEY (`codigo_matricula`) REFERENCES `ALUNO`(`codigo_matricula`),
  FOREIGN KEY (`id_turma`) REFERENCES `TURMA`(`id_turma`)
) ENGINE = InnoDB;

-- Criação da tabela FALTA
CREATE TABLE IF NOT EXISTS `FALTA` (
  `codigo_falta` INT NOT NULL AUTO_INCREMENT,
  `codigo_matricula` INT NOT NULL,
  `id_turma` INT NOT NULL,
  `data_falta` DATE NOT NULL,
  PRIMARY KEY (`codigo_falta`),
  FOREIGN KEY (`codigo_matricula`) REFERENCES `ALUNO`(`codigo_matricula`),
  FOREIGN KEY (`id_turma`) REFERENCES `TURMA`(`id_turma`)
) ENGINE = InnoDB;

-- Inserção de dados na tabela PROFESSOR
INSERT INTO `PROFESSOR` (cpf, nome, data_nascimento, titulacao, telefone) 
VALUES ('12345678901', 'Carlos Silva', '1980-05-20', 'Mestre', '9999-1234'),
       ('23456789012', 'Ana Pereira', '1975-10-30', 'Doutora', '9999-5678'),
       ('34567890123', 'João Santos', '1985-02-15', 'Doutor', '9999-9012');

-- Inserção de dados na tabela ALUNO
INSERT INTO `ALUNO` (data_matricula, nome, endereco, telefone, data_nascimento, altura, peso) 
VALUES ('2024-01-10', 'Lucas Oliveira', 'Rua A, 123', '9888-1234', '2000-01-01', 1.75, 70.5),
       ('2024-01-11', 'Maria Fernandes', 'Rua B, 456', '9888-5678', '1999-02-02', 1.60, 55.0),
       ('2024-01-12', 'Carlos Alberto', 'Rua C, 789', '9888-9012', '1998-03-03', 1.80, 75.0),
       ('2024-01-13', 'Ana Lima', 'Rua D, 159', '9888-3456', '1995-04-04', 1.70, 65.0);

-- Inserção de dados na tabela TURMA
INSERT INTO `TURMA` (quantidade_alunos, horario_aula, duracao_aula, data_inicio, data_fim, tipo_curso, cpf_professor) 
VALUES (20, '09:00:00', 2, '2024-02-01', '2024-06-30', 'Programação Básica', '12345678901'),
       (25, '10:30:00', 3, '2024-02-01', '2024-06-30', 'Design Gráfico', '23456789012'),
       (15, '14:00:00', 2, '2024-02-01', '2024-06-30', 'Marketing Digital', '34567890123');

-- Inserção de dados na tabela MONITOR
INSERT INTO `MONITOR` (codigo_matricula, id_turma) 
VALUES (1, 1),  -- Lucas Oliveira é monitor na turma de Programação Básica
       (2, 2);  -- Maria Fernandes é monitor na turma de Design Gráfico

-- Inserção de dados na tabela FALTA
INSERT INTO `FALTA` (codigo_matricula, id_turma, data_falta) 
VALUES (1, 1, '2024-02-05'),  -- Lucas Oliveira teve falta
       (3, 1, '2024-02-05'),  -- Carlos Alberto teve falta
       (4, 3, '2024-02-06');  -- Ana Lima teve falta

-- Consultas para responder às perguntas:

-- 1) Listar os dados dos alunos
SELECT * FROM ALUNO;

-- 2) Listar os dados dos alunos e as turmas que eles estão matriculados
SELECT 
    a.codigo_matricula, 
    a.nome AS nome_aluno, 
    t.id_turma, 
    t.tipo_curso
FROM ALUNO a
INNER JOIN MONITOR m ON a.codigo_matricula = m.codigo_matricula
INNER JOIN TURMA t ON m.id_turma = t.id_turma;

-- 3) Listar os alunos que não possuem faltas
SELECT a.* 
FROM ALUNO a
WHERE a.codigo_matricula NOT IN (SELECT DISTINCT codigo_matricula FROM FALTA);

-- 4) Listar os professores e a quantidade de turmas que cada um leciona
SELECT 
    p.nome AS nome_professor, 
    COUNT(t.id_turma) AS quantidade_turmas
FROM PROFESSOR p
LEFT JOIN TURMA t ON p.cpf = t.cpf_professor
GROUP BY p.cpf;

-- 5) Listar nome dos professores, telefone, dados das turmas que leciona, curso da turma e alunos matriculados
SELECT 
    p.nome AS nome_professor, 
    p.telefone, 
    t.id_turma, 
    t.data_inicio, 
    t.data_fim, 
    t.horario_aula,
    t.tipo_curso,
    a.nome AS nome_aluno
FROM PROFESSOR p
INNER JOIN TURMA t ON p.cpf = t.cpf_professor
INNER JOIN MONITOR m ON t.id_turma = m.id_turma
INNER JOIN ALUNO a ON m.codigo_matricula = a.codigo_matricula
ORDER BY p.nome, t.id_turma, a.nome;

-- Alterações nas tabelas

-- 1) Alterar o nome de todos os professores para maiúsculo
UPDATE PROFESSOR 
SET nome = UPPER(nome);

-- 2) Colocar o nome de todos os alunos que estão na turma com o maior número de alunos em maiúsculo
UPDATE ALUNO 
SET nome = UPPER(nome) 
WHERE codigo_matricula IN (
    SELECT m.codigo_matricula
    FROM MONITOR m
    INNER JOIN TURMA t ON m.id_turma = t.id_turma
    WHERE t.quantidade_alunos = (SELECT MAX(quantidade_alunos) FROM TURMA)
);

-- 3) Excluir as ausências dos alunos nas turmas que estes são monitores
DELETE FROM FALTA 
WHERE (codigo_matricula, id_turma) IN (
    SELECT m.codigo_matricula, m.id_turma
    FROM MONITOR m
);
