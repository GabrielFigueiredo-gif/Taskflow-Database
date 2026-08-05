# Taskflow-Database

# 🗄️ Taskflow - Sistema de Banco de Dados para Gerenciamento de Projetos

Este repositório contém a modelagem, a estrutura DDL e os scripts SQL para o banco de dados relacional do **Taskflow**, uma plataforma voltada para organização e acompanhamento de projetos, tarefas, equipes e prazos.

---

## 🎯 Objetivos do Banco de Dados

O banco de dados foi projetado para dar suporte ao ecossistema do Taskflow, permitindo:
- **Gestão de Usuários:** Cadastro, perfis e papéis dentro dos projetos.
- **Gerenciamento de Projetos:** Criação, status, datas de início/término e responsáveis.
- **Acompanhamento de Tarefas:** Atribuição de tarefas, definição de prioridades, status e prazos de entrega.
- **Relacionamento de Equipes:** Vínculo de membros a múltiplos projetos.

---

## 🛠️ Tecnologias e Ferramentas

* **SGBD Relacional:** MySQL / PostgreSQL *(ou outro SGBD utilizado)*
* **Linguagem:** SQL (DDL e DML)
* **Modelagem:** Modelo Entidade-Relacional (MER / DER)

---

## 📐 Estrutura e Modelagem

O modelo de dados contempla as seguintes entidades principais:

* **Usuários:** Informações de acesso, nome e e-mail.
* **Projetos:** Título, descrição, prazo, status e usuário criador.
* **Tarefas:** Descrição, prioridade (Baixa, Média, Alta), status (A Fazer, Em Andamento, Concluída) e responsável.
* **Projetos_Membros / Equipes:** Tabela associativa para gerenciamento de permissões e participação dos usuários nos projetos.

---

## 🚀 Como Executar os Scripts
- Clone o repositório: git clone [https://github.com/SeuUsuario/Projeto-BD-Taskflow.git](https://github.com/SeuUsuario/Projeto-BD-Taskflow.git)
- Acesse o seu SGBD de preferência (MySQL Workbench, pgAdmin, DBeaver, etc.).
- Execute o script de criação das tabelas:
- Execute o arquivo schema.sql para criar a base de dados e suas estruturas.
- (Opcional) Popule a base com dados de teste: Execute o arquivo seeds.sql para inserir registros de exemplo.
