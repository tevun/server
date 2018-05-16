# Tevun

Este projeto é uma API de gerenciador de contêineres destinada à gerenciar múltiplos hosts em contêineres gerenciados por arquivos que seguem o padrão `docker-compose`.
Utilizando ele você transforma seu VPS em um ambiente simples e rápido para deploy de aplicações.

Para publicar uma aplicação basta executar um comando para criação de um `git remote` com um hook `post-receive` configurado para parar e subir seu projeto `docker-compose`.
Com essa estratégia você pode instalar bancos de dados, criar volumes e manipular todo o ambiente remoto do seu servidor apenas com um comando `git push`.

## Como isso funciona?

Você vai instalar este projeto no seu servidor.
Durante a instalação será gerada uma `server key`, guarde-a.
Depois de instalado ele irá disponibilizar para você um conjunto de comandos e endpoints para que você possa adicionar e remover `sites` do seu servidor de forma automatizada.

A topologia do projeto é semelhante à imagem abaixo.
<p align="center">
  <img 
    src="https://github.com/brasil-php/server-manager/raw/master/images/topology.jpg" 
    alt="Pairing"
  >
</p>

Para garantir a identidade do cliente é preciso pareá-lo antes de rodar os primeiros comandos.
Para fazer este processo é preciso informar o `server key`, que será validado para ativação do cliente que fez o pedido como apto a se comunicar com o servidor.
<p align="center">
  <img 
    src="https://github.com/brasil-php/server-manager/raw/master/images/pair.jpg" 
    alt="Pairing"
  >
</p>

Depois de feitas essas configurações você vai rodar o comando:
```bash
$ tevun add example.com
```
E quando acessar no navegador verá:
<p align="center">
  <img 
    src="https://github.com/brasil-php/server-manager/raw/master/images/works.png" 
    alt="Pairing"
  >
</p>

Você pode ver os arquivos que são gerados para esse setup inicial [aqui](https://github.com/brasil-php/server-manager/tree/master/samples)

### O Servidor

A API Rest para gerenciar o servidor contém os endpoints:

| METHOD | URL                          |
|--------|------------------------------|
| GET    | /v1/domains                  |
| POST   | /v1/domains                  |
| GET    | /v1/domains/`<domain>`       |
| DELETE | /v1/domains/`<domain>`       |
| PATCH  | /v1/domains/`<domain>`/down  |
| PATCH  | /v1/domains/`<domain>`/up    |
| PUT    | /v1/domains/`<domain>`/env   |
| GET    | /v1/domains/`<domain>`/env   |
 
 E conta com os seguintes comandos:
 
 | COMMAND                   | OUTPUT                               |
 |---------------------------|--------------------------------------|
 | install `<host>` `<port>` | generated key                        |
 | info                      | `<host>`, `<port>` and generated key |
 | ls                        | domains list                         |
 | add `<domain>`            | docker-compose.yml & git remote      |
 | rm `<domain>`             | docker output                        |
 | up `<domain>`             | docker output                        |
 | down `<domain>`           | docker output                        |

### O Cliente

O Cliente disponibiliza os seguintes comandos:

 | COMMAND                   | INPUT | OUTPUT                           |
 |---------------------------|-------|----------------------------------|
 | pair `<host>` `<port>`    | key   | pair confirmation                |
 | unpair `<host>` `<port>`  |       | hosts list                       |
 | paired                    |       | hosts list                       |
 | use `<host>`              |       | selection confirmation           |
 | ls                        |       | domains list                     |
 | add `<domain>`            |       | docker-compose.yml & git remote  |
 | rm `<domain>`             |       | docker output                    |
 | up `<domain>`             |       | docker output                    |
 | down `<domain>`           |       | docker output                    |
