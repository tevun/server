<p align="center">
  <img
    src="https://raw.githubusercontent.com/tevun/server/master/badge.png"
    height="150px"
    alt="logo"
  />
</p>

# Tevun ~ WIP

### Disclaimer
----
> No momento não há ainda como fazer os procedimentos abaixo.
> 
> Para entender o estado do projeto atualmente clique [aqui](https://github.com/tevun/server#versões-iniciais) 
----

# O Projeto

Este projeto é uma API para gerenciamento de contêineres destinada à gerenciar múltiplos hosts em contêineres gerenciados por arquivos que seguem o padrão `docker-compose`.
Utilizando ele você transforma seu VPS em um ambiente simples e rápido para deploy de aplicações.

Para publicar uma aplicação basta executar um comando para criação de um `git remote` com um hook `post-receive` configurado para parar e subir seu projeto `docker-compose`.
Com essa estratégia você pode instalar bancos de dados, criar volumes e manipular todo o ambiente remoto do seu servidor apenas com um comando `git push`.

## Objetivo do Projeto

Se você tem trabalhado no seu ambiente de desenvolvimento com Docker deve ter encontrado pelo caminho alguns desafios na hora de publicar sua aplicação no ambiente de homologação, ou mesmo em produção. Costumeiramente deve ter sido preciso publicar sua aplicação em um ambiente não homogêneo ao seu, como servidores de hospedagem, ou mesmo em VPS's onde é tudo instalado diretamente na máquina e é complicado ficar mudando as versões dos serviços. Provavelmente você precisa fazer vários acessos via ssh para poder obter as configurações necessárias.

O Tevun atua justamente nesse ponto: integrar seu ambiente de desenvolvimento aos seus ambientes remotos. O processo é simples e não há nenhum milagre. Ao criar uma entrada no servidor que tem o Docker, Docker-Compose e Tevun instalados você recebe um `docker-compose.yml` básico e a URL de um repositório remoto para o Git. Quando faz um `git push` para esse **remote** um script _post-receive_, previamente configurado, no repositório se encarrega de fazer checkout do seu código para a pasta do projeto no servidor e parar e subir os containers.

Sendo assim ao usar o Tevun você passa a ter um gerenciador de sites que cria os domínios e vhosts para você (inclusive com a parte do ssl - https - fornecido pelo Let's Encrypt) de forma automatizada e roda seus projetos através de seus containers. Ao fazer um `git push` ou usar `webhooks` (e incluir as devidas configurações) você pode reconfigurar tudo o que você tinha de infra no seu projeto remoto, replicando o mesmo ambiente que você tinha em desenvolvimento.

### Acompanhe
- [Telegram](https://t.me/tevun)
- [Twitter](https://twitter.com/tevunapp)
- [Site](https://tevun.com)

## Como isso funciona?

Você vai instalar este projeto no seu servidor.
Durante a instalação será gerada uma `server key`, guarde-a.
Depois de instalado ele irá disponibilizar para você um conjunto de comandos e endpoints para que você possa adicionar e remover `sites` do seu servidor de forma automatizada.

A topologia do projeto é semelhante à imagem abaixo.
<p align="center">
  <img 
    src="https://github.com/tevun/server/raw/master/images/topology.jpg" 
    alt="Pairing"
  >
</p>

Para garantir a identidade do cliente é preciso pareá-lo antes de rodar os primeiros comandos.
Para fazer este processo é preciso informar o `server key`, que será validado para ativação do cliente que fez o pedido como apto a se comunicar com o servidor.
<p align="center">
  <img 
    src="https://github.com/tevun/server/raw/master/images/pair.jpg" 
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
    src="https://github.com/tevun/server/raw/master/images/works.png" 
    alt="Pairing"
  >
</p>

Da mesma forma você pode usar o CLI para remover o domínio
```
$ tevun rm example.com
```

Você pode ver os arquivos que são gerados para esse setup inicial [aqui](https://github.com/tevun/server/tree/master/samples)

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
 | start `<domain>`          | docker output                        |
 | stop `<domain>`           | docker output                        |

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
Dê uma olha [nesta pasta](https://github.com/tevun/server/tree/master/installers) para ver se encontra seu sitema na lista.
Obtenha Mais informações sobre uso do nossos instaladores [aqui](https://github.com/tevun/server#instalação-de-requisitos).

Para instalar o projeto em suas versões iniciais é preciso fazer os passos abaixo:

##### Instalação

Instale o tevun no seu servidor
```
$ ssh root@<ip>
# mkdir -p /usr/share/tevun/bin
# cd /usr/share/tevun/bin 
# git clone https://github.com/tevun/server.git .
# ln -s $(pwd)/tevun.sh /usr/local/bin/tevun
```

Configure as credenciais adequadamente
```
# tevun password (gere uma senha para usar adiante)
# passwd [opcional] (use para ter uma senha do seu root para usar como SU)
# tevun user {user}
```

Reinicie seu servidor e entre com o usuário sem privilégios para fazer o setup do Tevun
```
# tevun ubuntu/locale [opcional] (use para configurar o locale do Ubuntu)
# reboot
$ ssh {user}@<ip>
$ sudo tevun setup {user}
```

#### Gerenciando os Domínios

Para gerencias os domínios você tem os seguintes comandos:

- `tevun create <domain>`: Add one domain to the list of domains
- `tevun destroy <domain>`: Remove the domain of list of domains
- `tevun start <domain>`: Start the domain execution
- `tevun stop <domain>`: Stop the domain execution
- `tevun up <domain>`: Puts the domain up
- `tevun down <domain>`: Puts the domain down
- `tevun live`: Make all sites available
- `tevun die`: Stop all containers

##### Configurando o projeto

```
$ git remote add deploy ssh://<user>@<ip>/domains/<domain>/repo
$ git fetch deploy +refs/heads/setup:refs/remotes/deploy/setup
$ git branch --no-track setup refs/remotes/deploy/setup
$ git branch --set-upstream-to=deploy/setup setup
$ git merge --no-ff deploy/setup --allow-unrelated-histories 
```

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
