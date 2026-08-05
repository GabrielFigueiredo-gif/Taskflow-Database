create database TaskFLow;
use TaskFLow;

create table Usuarios (
       ID INT PRIMARY KEY,
       Nome VARCHAR(100) NOT NULL,
       Email VARCHAR(50) NOT NULL,
       Senha_hash VARCHAR(50) NOT NULL,
       Foto VARCHAR(50),
       Cargo VARCHAR(50),
       Bio VARCHAR(100),
       Notificacao_ativa BIT,
       Criado_em DATETIME,
       Atualizado_em DATETIME
);

create table Notificacao (
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Destinatario_id INT NOT NULL,
       Referencia_ID INT,
       tipo VARCHAR(50),
       Conteudo VARCHAR(MAX),
       Lido BIT DEFAULT 0,
       Criado_em DATETIME DEFAULT GETDATE(),
       FOREIGN KEY (Destinatario_id) REFERENCES Usuarios(ID)
);

create table Equipes(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Dono_ID INT NOT NULL,
       Nome VARCHAR(100) NOT NULL,
       Descricao VARCHAR(MAX),
       Criado_em DATETIME DEFAULT GETDATE(),
       FOREIGN KEY (Dono_ID) REFERENCES Usuarios(ID)
);

create table Mensagens(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Remetente_ID INT NOT NULL,
       Destinatario_ID INT NOT NULL,
       Equipe_ID INT,
       Conteudo VARCHAR(MAX),
       Midia_path VARCHAR(255),
       Enviado_em DATETIME DEFAULT GETDATE(),
       Tipo VARCHAR(50),
       FOREIGN KEY (Remetente_ID) REFERENCES Usuarios(ID),
       FOREIGN KEY (Destinatario_ID) REFERENCES Usuarios(ID),
       FOREIGN KEY(Equipe_ID) REFERENCES Equipes(ID)
);

create table Projetos (
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Criado_por INT NOT NULL,
       Nome VARCHAR(150) NOT NULL,
       Descricao VARCHAR(MAX),
       Cor VARCHAR(7),
       img_capa VARCHAR(255),
       Data_inicio DATETIME,
       Data_estimada DATETIME,
       Arquivado BIT DEFAULT 0,
       Status VARCHAR(30) DEFAULT 'Planejado',
       Criado_em DATETIME DEFAULT GETDATE(),
       FOREIGN KEY (Criado_por) REFERENCES Usuarios(ID),
       CONSTRAINT CHK_Projeto_Status CHECK (Status IN ('Planejado', 'Em Andamento', 'Pausado', 'Concluido'))
);

create table Tarefas(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Projeto INT NOT NULL,
       Responsavel INT,
       Titulo VARCHAR(150) NOT NULL,
       Descricao VARCHAR(MAX),
       Prazo DATETIME,
       Criado_em DATETIME DEFAULT GETDATE(),
       Atualizado_em DATETIME DEFAULT GETDATE(),
       Prioridade VARCHAR(20) DEFAULT 'Media',
       [Status] VARCHAR(30) DEFAULT 'A Fazer',
       FOREIGN KEY (Projeto) REFERENCES Projetos(ID),
       FOREIGN KEY (Responsavel) REFERENCES Usuarios(ID),
       CONSTRAINT CHK_Tarefa_Prioridade CHECK (Prioridade IN ('Baixa', 'Media', 'Alta', 'Urgente'))
);

create table Historico_atividade(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Usuario_ID INT NOT NULL,
       Projeto_ID INT NOT NULL,
       Tarefa_ID INT NOT NULL,
       Detalhe VARCHAR(MAX),
       Ocorreu_em DATETIME DEFAULT GETDATE(),
       Acao VARCHAR(100),
       FOREIGN KEY (Usuario_ID) REFERENCES Usuarios(ID),
       FOREIGN KEY (Projeto_ID) REFERENCES Projetos(ID),
       FOREIGN KEY (Tarefa_ID) REFERENCES Tarefas(ID)
);

create table Comentarios(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Tarefa_ID INT NOT NULL,
       Autor_ID INT NOT NULL,
       Conteudo VARCHAR(MAX) NOT NULL,
       Criado_em DATETIME DEFAULT GETDATE(),
       FOREIGN KEY (Tarefa_ID) REFERENCES Tarefas(ID),
       FOREIGN KEY (Autor_ID) REFERENCES Usuarios(ID)
);

create table Checklist(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Tarefa_ID INT NOT NULL,
       Descricao VARCHAR(255) NOT NULL,
       Concluido BIT DEFAULT 0,
       Ordem INT,
       Criado_em DATETIME DEFAULT GETDATE(),
       FOREIGN KEY (Tarefa_ID) REFERENCES Tarefas(ID)
);

create table Depende(
       Tarefa_ID INT NOT NULL,
       Tarefa_dependente INT NOT NULL,
       CONSTRAINT PK_Depende PRIMARY KEY(Tarefa_ID),
       CONSTRAINT FK_Depende_Tarefa FOREIGN KEY(Tarefa_ID) REFERENCES Tarefas(ID),
       CONSTRAINT FK_Depende_TarefaDependente FOREIGN KEY (Tarefa_dependente) REFERENCES Tarefas (ID)
);

create table Projeto_equipe(
       Projeto_ID INT NOT NULL,
       Equipe_ID INT NOT NULL,
       FOREIGN KEY(Projeto_ID) REFERENCES Projetos(ID),
       FOREIGN KEY(Equipe_ID) REFERENCES Equipes(ID)
);

create table Equipe_usuario(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Equipes_ID INT NOT NULL,
       Usuario_ID INT NOT NULL,
       Papel VARCHAR(50) NOT NULL,
       Entrou_em DATETIME NOT NULL DEFAULT GETDATE(),
       FOREIGN KEY(Equipes_ID) REFERENCES Equipes(ID),
       FOREIGN KEY(Usuario_ID) REFERENCES Usuarios(ID),
       CONSTRAINT CHK_EquipeUsuario_Papel CHECK (Papel IN ('Dono', 'Administrador', 'Membro', 'Convidado'))
);

use TaskFLow

create table Eventos_calendario(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Titulo VARCHAR(255) NOT NULL,
       Descricao VARCHAR(MAX),
       Inicio_em DATETIME NOT NULL,
       Fim DATETIME NOT NULL,
       Criado_em DATETIME DEFAULT GETDATE()
);

create table Associado(
       idEventos_calendario INT NOT NULL,
       idProjetos INT NOT NULL,
       CONSTRAINT PK_Associado PRIMARY KEY (idEventos_calendario, idProjetos),
       FOREIGN KEY(idEventos_calendario) REFERENCES Eventos_calendario(ID),
       FOREIGN KEY(idProjetos) REFERENCES Projetos(ID)
);

create table Cria(
       idEventos_calendario INT NOT NULL,
       idUsuarios INT NOT NULL,
       CONSTRAINT PK_Cria PRIMARY KEY (idEventos_calendario, idUsuarios),
       FOREIGN KEY(idEventos_calendario) REFERENCES Eventos_calendario(ID),
       FOREIGN KEY(idUsuarios) REFERENCES Usuarios(ID)
);

create table Relatorio(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Tipo VARCHAR(50) NOT NULL,
       Arquivo_caminho VARCHAR(MAX) NOT NULL,
       Gerado_em DATETIME DEFAULT GETDATE()
);

create table Gera(
       Usuarios_ID INT NOT NULL,
       Relatorio_ID INT NOT NULL,
       CONSTRAINT PK_Gera PRIMARY KEY (Usuarios_ID, Relatorio_ID),
       FOREIGN KEY(Usuarios_ID) REFERENCES Usuarios(ID),
       FOREIGN KEY(Relatorio_ID) REFERENCES Relatorio(ID)
);

create table Origina(
       Projetos_ID INT NOT NULL,
       Relatorio_ID INT NOT NULL,
       CONSTRAINT PK_Origina PRIMARY KEY (Projetos_ID, Relatorio_ID),
       FOREIGN KEY(Projetos_ID) REFERENCES Projetos(ID),
       FOREIGN KEY(Relatorio_ID) REFERENCES Relatorio(ID)
);

create table Tags(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Nome VARCHAR(100) NOT NULL
);

create table Tags_projeto(
       ID INT IDENTITY(1,1) PRIMARY KEY,
       Tag INT NOT NULL,
       Projeto INT NOT NULL,
       Cor VARCHAR(50) NOT NULL,
       FOREIGN KEY(Tag) REFERENCES Tags(ID),
       FOREIGN KEY(Projeto) REFERENCES Projetos(ID)
);

create table Classifica(
       Tarefa_ID INT NOT NULL,
       Tags_ID INT NOT NULL,
       FOREIGN KEY(Tarefa_ID) REFERENCES Tarefas(ID),
       FOREIGN KEY(Tags_ID) REFERENCES Tags_projeto(ID)
);

use TaskFLow

INSERT INTO Usuarios (ID, Nome, Email, Senha_hash, Foto, Cargo, Bio, Notificacao_ativa, Criado_em, Atualizado_em) VALUES
(1, 'Gabriel Figueiredo', 'gabriel@taskflow.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3f', 'perfil_gabriel.png', 'Tech Lead / Dev', 'Criador do TaskFlow. Focado em interfaces neon e performance.', 1, GETDATE(), GETDATE()),
(2, 'Lucas Silva', 'lucas@taskflow.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'perfil_lucas.png', 'UI/UX Designer', 'Especialista em Dark Mode e paletas vibrantes.', 1, GETDATE(), GETDATE()),
(3, 'Mariana Costa', 'mariana@taskflow.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', 'perfil_mari.png', 'Backend Developer', 'Apaixonada por modelagem de dados e APIs escaláveis.', 0, GETDATE(), GETDATE());

INSERT INTO Notificacao (Destinatario_id, Referencia_ID, tipo, Conteudo, Lido) VALUES
(1, NULL, 'Sistema', 'Bem-vindo ao TaskFlow! Seu workspace neon está pronto.', 0),
(2, 1, 'Projeto', 'Você foi adicionado ao projeto do Dashboard Principal.', 1);

INSERT INTO Equipes (Dono_ID, Nome, Descricao) VALUES
(1, 'Core Team', 'Equipe principal responsável pelo desenvolvimento e design do ecossistema TaskFlow.'),
(1, 'Alpha Testers', 'Grupo focado em testes de usabilidade e feedback da interface escura.');

INSERT INTO Mensagens (Remetente_ID, Destinatario_ID, Equipe_ID, Conteudo, Midia_path, Tipo) VALUES
(1, 2, 1, 'Fala Lucas, consegue ajustar o brilho do neon roxo no layout do chat?', NULL, 'Texto'),
(2, 1, 1, 'Consigo sim! Vou subir a imagem com a nova paleta.', 'uploads/chat/nova_paleta.png', 'Midia');

INSERT INTO Projetos (Criado_por, Nome, Descricao, Cor, img_capa, Data_inicio, Data_estimada, Arquivado, Status) VALUES
(1, 'TaskFlow Webapp', 'Desenvolvimento da plataforma web principal com foco na experiência fluida.', '#00FFFF', 'capa_taskflow.png', GETDATE(), DATEADD(month, 3, GETDATE()), 0, 'Em Andamento'),
(1, 'Landing Page Institucional', 'Site estático para divulgação do TaskFlow e captação de leads.', '#FF00FF', 'capa_landing.png', GETDATE(), DATEADD(day, 15, GETDATE()), 0, 'Planejado');

INSERT INTO Tarefas (Projeto, Responsavel, Titulo, Descricao, Prazo, Prioridade, [Status]) VALUES
(1, 1, 'Estruturar Banco de Dados', 'Criar as 21 tabelas no SQL Server e validar relacionamentos.', DATEADD(day, 7, GETDATE()), 'Urgente', 'A Fazer'),
(1, 2, 'Finalizar UI do Dashboard', 'Refinar os componentes gráficos, gráficos neon e responsividade.', DATEADD(day, 14, GETDATE()), 'Alta', 'A Fazer'),
(1, 3, 'Configurar Rotas da API', 'Criar os endpoints para autenticação e manipulação das tarefas.', DATEADD(day, 10, GETDATE()), 'Media', 'A Fazer');

INSERT INTO Historico_atividade (Usuario_ID, Projeto_ID, Tarefa_ID, Detalhe, Acao) VALUES
(1, 1, 1, 'Gabriel criou a tarefa de estruturação das tabelas principais.', 'Criar Tarefa');

INSERT INTO Comentarios (Tarefa_ID, Autor_ID, Conteudo) VALUES
(1, 3, 'Já validei as chaves estrangeiras, a ordem de inserção precisa começar por Usuários e Equipes.'),
(2, 1, 'Achei o contraste fantástico, Lucas!');

INSERT INTO Checklist (Tarefa_ID, Descricao, Concluido, Ordem) VALUES
(1, 'Mapear tabelas de relacionamentos N:N', 1, 1),
(1, 'Validar os CHECK constraints de Status', 1, 2),
(1, 'Gerar script de carga inicial (Inserts)', 0, 3);

INSERT INTO Depende (Tarefa_ID, Tarefa_dependente) VALUES
(2, 1);

INSERT INTO Projeto_equipe (Projeto_ID, Equipe_ID) VALUES
(1, 1),
(2, 1);

INSERT INTO Equipe_usuario (Equipes_ID, Usuario_ID, Papel) VALUES
(1, 1, 'Dono'),
(1, 2, 'Administrador'),
(1, 3, 'Membro');

INSERT INTO Eventos_calendario (Titulo, Descricao, Inicio_em, Fim) VALUES
('Sprint Planning 01', 'Alinhamento inicial das features do TaskFlow e divisão de tarefas.', GETDATE(), DATEADD(hour, 2, GETDATE())),
('Review de Design', 'Apresentação do protótipo de alta fidelidade em Dark Mode.', DATEADD(day, 3, GETDATE()), DATEADD(day, 3, DATEADD(hour, 1, GETDATE())));

INSERT INTO Associado (idEventos_calendario, idProjetos) VALUES
(1, 1),
(2, 1);

INSERT INTO Cria (idEventos_calendario, idUsuarios) VALUES
(1, 1),
(2, 2);

INSERT INTO Relatorio (Tipo, Arquivo_caminho) VALUES
('Produtividade', 'exports/reports/produtividade_maio_2026.pdf'),
('Progresso de Projeto', 'exports/reports/status_taskflow_v1.pdf');

INSERT INTO Gera (Usuarios_ID, Relatorio_ID) VALUES
(1, 1),
(1, 2);

INSERT INTO Origina (Projetos_ID, Relatorio_ID) VALUES
(1, 1),
(1, 2);

INSERT INTO Tags (Nome) VALUES
('Frontend'),
('Backend'),
('Design'),
('Bug');

INSERT INTO Tags_projeto (Tag, Projeto, Cor) VALUES
(1, 1, '#00FF00'),
(3, 1, '#FF00FF'),
(2, 1, '#0000FF');

INSERT INTO Classifica (Tarefa_ID, Tags_ID) VALUES
(1, 3),
(2, 2);

SELECT 
    P.Nome AS Projeto,
    T.Titulo AS Tarefa,
    T.Prioridade,
    T.[Status],
    U.Nome AS Responsavel
FROM Tarefas T
INNER JOIN Projetos P ON T.Projeto = P.ID
LEFT JOIN Usuarios U ON T.Responsavel = U.ID;

SELECT 
    T.Titulo AS Tarefa,
    C.Descricao AS Item_Checklist,
    CASE WHEN C.Concluido = 1 THEN 'Concluído' ELSE 'Pendente' END AS Status_Item
FROM Checklist C
INNER JOIN Tarefas T ON C.Tarefa_ID = T.ID
ORDER BY C.Ordem;

SELECT 
    E.Nome AS Equipe,
    U.Nome AS Membro,
    EU.Papel
FROM Equipe_usuario EU
INNER JOIN Equipes E ON EU.Equipes_ID = E.ID
INNER JOIN Usuarios U ON EU.Usuario_ID = U.ID
ORDER BY E.Nome;

SELECT 
    E.Nome AS Equipe,
    U.Nome AS Remetente,
    M.Conteudo,
    M.Enviado_em
FROM Mensagens M
INNER JOIN Equipes E ON M.Equipe_ID = E.ID
INNER JOIN Usuarios U ON M.Remetente_ID = U.ID
ORDER BY M.Enviado_em ASC;

SELECT 
    P.Nome AS Projeto,
    T.[Status],
    COUNT(T.ID) AS Total_Tarefas
FROM Tarefas T
INNER JOIN Projetos P ON T.Projeto = P.ID
GROUP BY P.Nome, T.[Status];

SELECT * FROM Usuarios;

SELECT * FROM Usuarios 
WHERE Nome LIKE 'G%';





