# README
![Ruby Version](https://img.shields.io/badge/Ruby-3.1.2-red.svg)
![Rails Version](https://img.shields.io/badge/Rails-7.1.3.4-orange.svg)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Postman](https://img.shields.io/static/v1?style=for-the-badge&message=Postman&color=FF6C37&logo=Postman&logoColor=FFFFFF&label=)

# Checkers_API

Este projeto é uma API RESTful que implementa um jogo de damas, permitindo que duas pessoas joguem. A API é projetada para fornecer  endpoits de simples implementação para criar e gerenciar jogos de damas, seguindo as regras tradicionais.

## Funcionalidades Principais

### Criação e Participação em Jogos
- **Criação de Jogo**: Permite a criação de um novo jogo de damas, onde o usuário que cria o jogo se torna automaticamente o player 1. A API retorna um `game_id` e um token de acesso para o player 2 se juntar ao jogo.
- **Entrada no Jogo**: Um segundo jogador pode entrar no jogo utilizando um token de acesso válido para se tornar o player 2.

### Gerenciamento do Jogo
- **Estado do Tabuleiro**: Permite que os jogadores consultem o estado atual das peças no tabuleiro a qualquer momento.
- **Movimentos Permitidos**: Permite que os jogadores consultem quais são os movimentos permitidos para uma peça específica, de acordo com as regras do jogo.
- **Status do Jogo**: Permite verificar o status atual do jogo.
- **Movimentação de Peças**: Permite que os jogadores movam suas peças no tabuleiro, assegurando que todos os movimentos respeitem as regras do jogo de damas.







## Requisitos

Certifique-se de ter as seguintes dependências instaladas:

- Ruby 3.1.2;
- Ruby on Rails 7.1.3.4.
- PostgreSQL
- Postman

  ## Instalação

1. Clone este repositório para o seu ambiente local:

```bash
git clone git@github.com:CaioBrasetti/checkers_api.git
cd checkers_api
```

2. Instale as gems necessárias:

```bash
bundle install
```

3. Crie o banco e rode o seeds:

```bash
rails db:create db:migrate db:seed
```

4. Inicie o servidor Rails:

```bash
rails server
```
