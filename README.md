# Server Manager

Este projeto é uma API de gerenciador de contêineres destinada à gerenciar múltiplos hosts em contêineres gerenciados por arquivos que seguem o padrão `docker-compose`.

## Como isso funciona?

Você vai instalar este projeto no seu servidor.
Depois de instalado ele irá disponibilizar para você um conjunto de comandos e endpoints para que você possa adicionar e remover `sites` do seu servidor de forma automatizada.

### O Servidor

A API Rest para gerenciar o servidor contém os endpoints:

| METHOD | URL                        |
|--------|----------------------------|
| POST   | /v1/domains                |
| GET    | /v1/domains/<domain>       |
| DELETE | /v1/domains/<domain>       |
| PATCH  | /v1/domains/<domain>/down  |
| PATCH  | /v1/domains/<domain>/up    |
| POST   | /v1/domains/<domain>/env   |
 
 E conta com os seguintes comandos:
 
 | COMMAND               | OUTPUT                           |
 |-----------------------|----------------------------------|
 | install <host> <port> | generated key                    |
 | info                  | <host>, <port> and generated key |
 | ls                    | domains list                     |
 | add <domain>          | docker-compose.yml & git remote  |
 | rm <domain>           | docker output                    |
 | up <domain>           | docker output                    |
 | down <domain>         | docker output                    |

### O Cliente

O Cliente disponibiliza os seguintes comandos:

 | COMMAND               | INPUT | OUTPUT                           |
 |-----------------------|-------|----------------------------------|
 | pair <host> <port>    | key   | pair confirmation
 | unpair <host> <port>  |       | hosts list                       |
 | paired                |       | hosts list                       |
 | use <host>            |       | selection confirmation           |
 | ls                    |       | domains list                     |
 | add <domain>          |       | docker-compose.yml & git remote  |
 | rm <domain>           |       | docker output                    |
 | up <domain>           |       | docker output                    |
 | down <domain>         |       | docker output                    |
