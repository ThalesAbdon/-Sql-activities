-- Criação do schema
CREATE SCHEMA IF NOT EXISTS `exercicio01` DEFAULT CHARACTER SET utf8;
USE `exercicio01`;

-- Criação da tabela ALUNO
CREATE TABLE IF NOT EXISTS `ALUNO` (
  `aluno_id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `curso` VARCHAR(100) NOT NULL,
  `nivel` INT NOT NULL,
  `idade` INT NOT NULL,
  PRIMARY KEY (`aluno_id`)
) ENGINE = InnoDB;

-- Criação da tabela TURMA
CREATE TABLE IF NOT EXISTS `TURMA` (
  `turma_id` INT NOT NULL AUTO_INCREMENT,
  `nometurma` VARCHAR(255) NOT NULL,
  `sala` INT NOT NULL,
  `horario` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`turma_id`)
) ENGINE = InnoDB;

-- Criação da tabela MATRÍCULA
CREATE TABLE IF NOT EXISTS `MATRICULA` (
  `matricula_id` INT NOT NULL AUTO_INCREMENT,
  `aluno_id` INT NOT NULL,
  `turma_id` INT,
  `nota_1` DOUBLE NOT NULL,
  `nota_2` DOUBLE NOT NULL,
  `nota_3` DOUBLE NOT NULL,
  `nota_final` DOUBLE NOT NULL,
  `nr_faltas` INT NOT NULL,
  PRIMARY KEY (`matricula_id`),
  FOREIGN KEY (`aluno_id`) REFERENCES `ALUNO` (`aluno_id`),
  FOREIGN KEY (`turma_id`) REFERENCES `TURMA` (`turma_id`)
) ENGINE = InnoDB;

-- Inserção de dados na tabela ALUNO
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'Israel', 'JEEEVA', 2, 19);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'Dênis', 'JEEEVA AND PHYTARAM', 3, 22);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'Ale', 'JEEEVA', 2, 30);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'Vitti', 'FULL STACK', 4, 21);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'Henrique', 'FULL STACK', 5, 30);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'PERNA LONGA', 'CORREDOR', 5, 30);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'PATOLINO', 'CORREDOR', 4, 28);
INSERT INTO `ALUNO` (nome, curso, nivel, idade) VALUES( 'PERNA BAMBA', 'BAMBO', 7, 100);

-- Inserção de dados na tabela TURMA
INSERT INTO `TURMA` (nometurma, sala, horario) VALUES ("Turma 1", 1, "09:00 - 12:00");
INSERT INTO `TURMA` (nometurma, sala, horario) VALUES ("Turma 2", 2, "14:00 - 17:00");
INSERT INTO `TURMA` (nometurma, sala, horario) VALUES ("Turma 3", 3, "08:00 - 10:00");
INSERT INTO `TURMA` (nometurma, sala, horario) VALUES ("Turma Do ID 30", 6, "09:00 - 12:00");

-- Inserção de dados na tabela MATRÍCULA
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (1, 1, 8.5, 9.0, 8.0, 8.5, 0);  -- Thales matriculado na Turma 1
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (2, 2, 8.5, 9.0, 8.0, 8.7, 0);  -- Jacques matriculado na Turma 2
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (3, 1, 8.5, 9.0, 8.0, 7.5, 0);  -- Mayara matriculado na Turma 1
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (4, 3, 8.5, 9.0, 8.0, 9.5, 0);  -- Vanessa matriculado na Turma 3
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (5, 3, 8.5, 9.0, 8.0, 8.5, 0);  -- Carlos matriculado na Turma 3
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (6, 1, 8.5, 9.0, 8.0, 6, 0);  -- PERNA LONGA matriculado na Turma 1
INSERT INTO `MATRICULA` (aluno_id, turma_id, nota_1, nota_2, nota_3, nota_final, nr_faltas) 
VALUES (7, 6, 8.5, 9.0, 8.0, 9.25, 0);  -- PATOLINO matriculado na Turma de ID 6


-- Consultas para responder às perguntas

-- 1: Quais os nomes de todos os alunos ?
SELECT nome FROM ALUNO;

-- 2: Quais os números das matrículas dos alunos ?
SELECT m.matricula_id, a.nome
FROM ALUNO a
INNER JOIN MATRICULA m ON a.aluno_id = m.aluno_id;

-- 3: Quais os números das matrículas dos alunos que não estão matriculados em uma turma ?
SELECT m.matricula_id
FROM MATRICULA m
WHERE m.turma_id IS NULL;

-- 4: Quais os números dos alunos matriculados em uma turma de número '30' ?
SELECT m.aluno_id 
FROM MATRICULA m 
WHERE m.turma_id = 30;

-- 5: Qual o horário da turma do aluno 'PATOLINO' ?
SELECT t.horario 
FROM ALUNO a
INNER JOIN MATRICULA m ON a.aluno_id = m.aluno_id
INNER JOIN TURMA t ON m.turma_id = t.turma_id
WHERE a.nome = 'PATOLINO';
