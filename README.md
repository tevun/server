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
After setting up tevun on your server you can upload an environment that applies your development docker-compose and configures a virtualhost for your LetsEncrypt SSL-enabled domain quickly and simply.
Each created project generates a remote git that is already preconfigured to publish the application to the destination directory.
That way we can configure the scripts to publish our changes in our stage or production environments.

## Getting Started

### Requirements

To run the instructions
- Git (git --version): git version +2.10.x
- Docker (docker -v): Docker version +18.0x.x-ce, build xxxxxxx
- Docker Compose (docker-compose -v): docker-compose version +1.2x.x, build xxxxxxxxx

### Download

Access your server using ssh
```
$ ssh root@<ip>
```

Then create the instalation dir, clone repository and create the symlink to use command `tevun` in terminal
```
# mkdir -p /usr/share/tevun
# git clone https://github.com/tevun/server.git /usr/share/tevun
# ln -s $(pwd)/tevun.sh /usr/bin/tevun
```

### Setting up Tevun

Let's configure Tevun on your server. First, let's check the user settings and permissions, and then let's configure Tevun.

#### Users and permissions

It is important that you avoid using your root user via SSH.
It is recommended that you create a user that is limited in order to be able to access your server via SSH.
Since we are dealing with docker, we need to have a local user with the same UID that the images will use. Usually this UID is the 1000.
To facilitate this operation you can **optionally** use the command below, where <name> is the name you want to assign to the new user.
```
# tevun user <name>
```
  * this command will also add the new user to the docker group and sudoers group

> if you already have a user with the necessary permissions to run your containers or this is not relevant to your scenario you can disregard this topic.

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

After perform this command you can access the your server in port 8110 to see if it works.
<p align="center">
  <img
    src="https://raw.githubusercontent.com/tevun/server/master/images/setup.png"
  />
</p>

Setup command will create 3 containers:
 - nginx-proxy: a ngix instance to make the reverse proxy and allow we up various containers to the same port
 - nginx-letsencrypt: a listener to docker socket that run LetsEncrypt bot to VIRTUAL_HOST property of containers environment
 - tevun: nginx server configured to run CGI and communicate with docker of host

