# Tevun ~ WIP

Este projeto é uma API para gerenciamento de contêineres destinada à gerenciar múltiplos hosts em contêineres gerenciados por arquivos que seguem o padrão `docker-compose`.
Utilizando ele você transforma seu VPS em um ambiente simples e rápido para deploy de aplicações.

Para publicar uma aplicação basta executar um comando para criação de um `git remote` com um hook `post-receive` configurado para parar e subir seu projeto `docker-compose`.
Com essa estratégia você pode instalar bancos de dados, criar volumes e manipular todo o ambiente remoto do seu servidor apenas com um comando `git push`.

> Disclaimer:
> No momento não há ainda como fazer os procedimentos abaixo.
> 
> Para entender o estado do projeto atualmente clique [aqui](https://github.com/brasil-php/tevun#versões-iniciais) 

## Como isso funciona?

Você vai instalar este projeto no seu servidor.
Durante a instalação será gerada uma `server key`, guarde-a.
Depois de instalado ele irá disponibilizar para você um conjunto de comandos e endpoints para que você possa adicionar e remover `sites` do seu servidor de forma automatizada.

A topologia do projeto é semelhante à imagem abaixo.
<p align="center">
  <img 
    src="https://github.com/brasil-php/tevun/raw/master/images/topology.jpg" 
    alt="Pairing"
  >
</p>

Para garantir a identidade do cliente é preciso pareá-lo antes de rodar os primeiros comandos.
Para fazer este processo é preciso informar o `server key`, que será validado para ativação do cliente que fez o pedido como apto a se comunicar com o servidor.
<p align="center">
  <img 
    src="https://github.com/brasil-php/tevun/raw/master/images/pair.jpg" 
    alt="Pairing"
  >
</p>

Para realizar essas configurações você pode usar o CLI para parear com o servidor, e, dai pra frente poderá usar esse servidor para adicionar seus domínios:
```
$ tevun pair <server-key>
$ tevun add example.com
```

E quando acessar no navegador verá:
<p align="center">
  <img 
    src="https://github.com/brasil-php/tevun/raw/master/images/works.png" 
    alt="Pairing"
  >
</p>

Da mesma forma você pode usar o CLI para remover o domínio
```
$ tevun rm example.com
```

Você pode ver os arquivos que são gerados para esse setup inicial [aqui](https://github.com/brasil-php/tevun/tree/master/samples)

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
 | install `<host>`          | generated key                        |
 | info                      | `<host>`, `<port>` and generated key |
 | ls                        | domains list                         |
 | create `<domain>`         | docker-compose.yml & git remote      |
 | destroy `<domain>`        | docker output                        |
 | live `<domain>`           | docker output                        |
 | die `<domain>`            | docker output                        |

### O Cliente

O Cliente disponibiliza os seguintes comandos:

 | COMMAND                   |     OUTPUT                           |
 |---------------------------|--------------------------------------|
 | pair `<server-key>`       | pair host confirmation               |
 | unpair `<host>`           | hosts list                           |
 | paired                    | hosts list                           |
 | use `<host>`              | selection confirmation               |
 | ls                        | domains list                         |
 | add `<domain>`            | docker-compose.yml & git remote      |
 | rm `<domain>`             | docker output                        |
 | up `<domain>`             | docker output                        |
 | down `<domain>`           | docker output                        |
 
### Versões Iniciais
 
Nestas versões iniciais ainda não temos vários recursos disponíveis, como a API e o CLI, mas temos um conjunto de comandos que já pode dar uma ideia do que está por vir.
 
Como requisitos para rodar o projeto você precisa ter o `docker` e o `docker-compose` instalados.
Caso não tenha você pode ver se o seu sistema é compatível com algum dos nossos instaladores disponíveis.
Dê uma olha [nesta pasta](https://github.com/brasil-php/tevun/tree/master/installers) para ver se encontra seu sitema na lista.
Obtenha Mais informações sobre uso do nossos instaladores [aqui](https://github.com/brasil-php/tevun#instalação-de-requisitos).

Para rodar o projeto em suas versões iniciais é preciso fazer os passos abaixo.

```
$ git clone https://github.com/brasil-php/tevun.git
$ cd tevun
$ rm -rf .git/
$ sudo ln -s $(pwd)/tevun.sh /usr/local/bin/tevun
$ tevun setup
```

#### Gerenciando os Domínios

Para gerencias os domínios você tem os seguintes comandos:

- `tevun create <domain>`: Add one domain to the list of domains
- `tevun destroy <domain>`: Remove the domain of list of domains
- `tevun up <domain>`: Start the domain execution
- `tevun down <domain>`: Stop the domain execution
- `tevun live`: Make all sites available
- `tevun die`: Stop all containers

### Instalação de Requisitos

Os comandos de instalação possuem a estrutura abaixo
```
# tevun requirement [ubuntu,debian,fedora,arch] <user> <version> <compose> <reboot> <locale>
```

Para instalar no `ubuntu`
```
# tevun requirement ubuntu
```

Para instalar no `ubuntu` o docker `17.12.0~ce-0~ubuntu` e docker-compose `1.18.0`, com a configuração de usuário direcionada para o `heimdall` e para reiniciar ao final do script e corrigir problemas de local a instrução seria como a seguir
```
# tevun requirement ubuntu heimdall 17.12.0~ce-0~ubuntu 1.18.0 yes yes
```

#### Parâmetros

1. `<user>` [optional]
O nome do usuário que terá acesso ao servidor. 
Pode ser `sysadmin` ou qualquer coisa que você quiser.
O usuário informado deverá ser usado no próximo acesso ao servidor e o usuário `root` perderá acesso ao SSH.
O valor padrão será `tevun`;

2. `<version>` [optional]
Versão do docker que você quer instalar.
Você pode usar esse parâmetro para manter homogeneidade entre seus ambientes.
Se você passar `edge` ou não informar a versão mais atual será usada;

3. `<compose>` [optional]
Versão do docker-compose.
Se você usar `edge` ou não informar a versão mais atual será usada;

4. `<reboot>` [optional]
Controle para reiniciar o sistema.
Suporta `yes` e `no`, seu valor padrão é `yes`;

5. `<locale>` [optional]
Corrige problemas relacionados à locales nos servidores.
Suporta `yes` e `no`, seu valor padrão é `yes`;
