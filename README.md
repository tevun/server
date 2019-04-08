<p align="center">
  <img
    src="https://raw.githubusercontent.com/tevun/server/master/badge.png"
    height="150px"
    alt="logo"
  />
</p>

# Tevun ~ WIP

Tevun is a set of scripts intended to make life easier for developers and sysadmins in general.
It combines docker, docker-compose and git to automate tasks such as uploading containers, configuring reverse proxy, configuring SSL, and more.
After setting up tevun on your server you can upload an environment that applies your development docker-compose and configures a virtual host for your LetsEncrypt SSL-enabled domain quickly and simply.
Each created project generates a remote git that is already preconfigured to publish the application to the destination directory.
That way we can configure the scripts to publish our changes in our stage or production environments.

### Follow
- [Telegram](https://t.me/tevun)
- [Twitter](https://twitter.com/tevunapp)
- [Site](https://tevun.com)

## Getting Started

### Requirements

Verify that your server has the following requirements:
- Git (git --version): git version +2.10.x
- Docker (docker -v): Docker version +18.0x.x-ce, build xxxxxxx
- Docker Compose (docker-compose -v): docker-compose version +1.2x.x, build xxxxxxxxx

### Download

Access your server using ssh
```
$ ssh root@<server>
```

Then create the installation dir, clone repository and create the symlink to use command `tevun` in terminal
```
# mkdir -p /usr/share/tevun
# git clone https://github.com/tevun/server.git /usr/share/tevun
# ln -s $(pwd)/tevun.sh /usr/bin/tevun
```

### Setting up Tevun

Let's configure Tevun on your server. First, let's check the user settings and permissions, and then let's configure Tevun.

#### Users and permissions

> if you already have an user with the necessary permissions to run your containers or this is not relevant to your scenario you can disregard this topic.

It is important that you avoid using your root user via SSH.
It is recommended that you create an user that is limited in order to be able to access your server via SSH.
Since we are dealing with docker, we need to have a local user with the same UID that the images will use. Usually this UID is the 1000.
To facilitate this operation you can **optionally** use the command below, where <name> is the name you want to assign to the new user.

```
# tevun user <name>
```
  * this command will also add the new user to the docker group and sudoers group

#### Access policy via SSH 

You can use a single Tevun command to configure a less privileged user to access SSH and disable root access by using the command below.

> Just use it if you know what it's doing!

```
# tevun ssh <name>
```

#### Tevun setup

To perform the setup use the following command in the terminal, replacing <user> with the name of the user that will be used to manipulate the containers.
```
# tevun setup <user>
```
<p align="center">
  <img src="https://raw.githubusercontent.com/tevun/server/master/images/output-setup.png"/>
</p>

After perform this command you can access the your server in port 8110 to see if it works.
<p align="center">
  <img src="https://raw.githubusercontent.com/tevun/server/master/images/setup.png"/>
</p>

Setup command will create 3 containers:
 - nginx-proxy: a ngix instance to make the reverse proxy and allow we up various containers to the same port
 - nginx-letsencrypt: a listener to docker socket that run LetsEncrypt bot to VIRTUAL_HOST property of containers environment
 - tevun: nginx server configured to run CGI and communicate with docker of host

### Using Tevun

Before start the usage you can edit the .env file to configure the properties of your server.
Open the `.env` file with your favorite editor and change the properties to suit your needs.  

#### Create a new project

```
$ tevun create <project> <template>
```
This command will add a new project in projects dir.
Where <project> is the name of project and <template> can be `php` or `html`. We can add other templates too.
The main idea is to have skeletons to most common structures used.  

Example:
```
$ tevun create site.com html
```
In this example tevun will create `site.com` project, initialize a git remote repository, configure post-receive, generate a docker-compose.yml and show the git remote URL in terminal.
<p align="center">
  <img src="https://raw.githubusercontent.com/tevun/server/master/images/output-create.png"/>
</p>

#### Register users

Once the projects have been created we can make a local clone of them, but for that we need an user with access permission.
To register users in Tevun use the command below:
```
$ tevun register <user>
```
This is a short hand to http basic auth and the file with permissions is in file `/etc/nginx/.users` of tevun container.

#### Destroy a project

```
$ tevun destroy <project>
```
The command destroy will stop your docker-compose project and erase the project dir.
The command will not erase the docker volumes, but is important to be careful with this instruction.
<p align="center">
  <img src="https://raw.githubusercontent.com/tevun/server/master/images/output-destroy.png"/>
</p>
