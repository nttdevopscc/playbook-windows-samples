# 1. playbook-samples

These are test playbooks tested on Ansible/AWX.

<!-- TOC -->

- [1. playbook-samples](#1-playbook-samples)
    - [1.1. Test Environment](#11-test-environment)
- [2. Install](#2-install)
    - [2.1. Prerequisites](#21-prerequisites)
    - [2.2. AWX](#22-awx)
- [3. Setting](#3-setting)
    - [3.1. AUTHENTICATION](#31-authentication)
    - [3.2. SYSTEM](#32-system)
    - [3.3. LDAP Authentication](#33-ldap-authentication)
- [Setting up a Windows Host](#setting-up-a-windows-host)
- [4. playbook sample](#4-playbook-sample)
    - [4.1. create domain user ( extra vars )](#41-create-domain-user--extra-vars-)
    - [4.2. create gsuite user  ( extra vars )](#42-create-gsuite-user---extra-vars-)

<!-- /TOC -->

## 1.1. Test Environment

* CentOS 7.5
* Python 3.6.6
* Ansible 2.8.2
* Docker version 18.09.7
* Docker-Compose 1.24.1
* Node v10.16.0 / NPM 6.9.0
* AWX 6.0.0.0

# 2. Install

Install awx with docker compose

https://github.com/ansible/awx/blob/devel/INSTALL.md#docker-compose 


## 2.1. Prerequisites

* python

```sh
yum install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel -y
yum -y install patch gcc make git
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'test -r ~/.bashrc && . ~/.bashrc' >> ~/.bash_profile
. ~/.bash_profile
pyenv install 3.6.6
pyenv global 3.6.6
python -V # 3.6.6
```

* ansible

```sh
pip install ansible
pip install --upgrade pip
```

* docker

https://docs.docker.com/install/linux/docker-ce/centos/

```sh
yum install -y yum-utils  device-mapper-persistent-data  lvm2
yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl enable docker 
systemctl start docker 
```

```sh
docker -v
Docker version 18.09.7, build 2d0083d
```

* docker-py

```sh
pip install docker
```

* Node 10.x / NPM 6.x

https://github.com/nodesource/distributions/blob/master/README.md 
 
```sh
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
yum install -y nodejs
npm -v #6.9.0
```

*  Docker-Compose 

```sh
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
pip install docker-compose
```

## 2.2. AWX

https://github.com/ansible/awx/blob/devel/INSTALL.md#docker-or-docker-compose

* modify inventory

```sh
git clone https://github.com/ansible/awx
cd awx/installer
vi  inventory

project_data_dir=/var/lib/awx/projects
postgres_data_dir=/var/lib/awx/pgdocker
```

* install

```sh
ansible-playbook -i inventory install.yml
```

```sh
cd /var/lib/awx/awxcompose/
docker-compose ps
     Name                    Command               State                               Ports
------------------------------------------------------------------------------------------------------------------------
awx_memcached_1   docker-entrypoint.sh memcached   Up      11211/tcp
awx_postgres_1    docker-entrypoint.sh postgres    Up      5432/tcp
awx_rabbitmq_1    docker-entrypoint.sh /bin/ ...   Up      15671/tcp, 15672/tcp, 25672/tcp, 4369/tcp, 5671/tcp, 5672/tcp
awx_task_1        /tini -- /bin/sh -c /usr/b ...   Up      8052/tcp
awx_web_1         /tini -- /bin/sh -c /usr/b ...   Up      0.0.0.0:80->8052/tcp
```

# 3. Setting

## 3.1. AUTHENTICATION

[google oauth2](https://docs.ansible.com/ansible-tower/latest/html/administration/social_auth.html#google-oauth2-settings)

```
GOOGLE OAUTH2 CALLBACK URL:
GOOGLE OAUTH2 KEY: <your key>
GOOGLE OAUTH2 SECRET: <your secret>
GOOGLE OAUTH2 WHITELISTED DOMAINS: <your domain>
```

## 3.2. SYSTEM

```
BASE URL OF THE TOWER HOST: https://<fqdn>
ENABLE ADMINISTRATOR ALERTS: OFF
ALL USERS VISIBLE TO ORGANIZATION ADMINS: ON
ORGANIZATION ADMINS CAN MANAGE USERS AND TEAMS: ON
IDLE TIME FORCE LOG OUT: 1800
MAXIMUM NUMBER OF SIMULTANEOUT LOGGED IN SETTIONS: -1
ENABLE HTTP BASIC AUTH: ON
ALLOW EXTERNAL USERS TO CREATE OAUTH2 TOKES: OFF
REMOTE HOST HEADERS: REMOTE_ADDR, REMOTE_HOST, HTTP_X_FORWARDED_FOR
```

## 3.3. LDAP Authentication

[active directory](https://docs.ansible.com/ansible-tower/latest/html/administration/ldap_auth.html)

```
LDAP SERVER URI : ldap://<ip address or hostname>:389
LDAP BIND DN: CN=Administrator,CN=Users,DC=x,DC=kodamap,DC=net
LDAP BIND PASSWORD:
LDAP USER DN TEMPLATE: <>
LDAP GROUP TYPE: ActiveDirectoryGroupType
LDAP REQUIRE GROUP: CN=Tower Users,CN=Users,DC=x,DC=kodamap,DC=net
LDAP DENY GROUP] <>
LDAP USER SEARCH:
[
 "OU=Test,DC=x,DC=kodamap,DC=net",
 "SCOPE_SUBTREE",
 "(sAMAccountName=%(user)s)"
]
LDAP GROUP SEARCH:
[
 "DC=x,DC=kodamap,DC=net",
 "SCOPE_SUBTREE",
 "(objectClass=group)"
]
LDAP USER ATTRIBUTE MAP
{
 "first_name": "givenName",
 "last_name": "sn",
 "email": "mail"
}
LDAP GROUP TYPE PARAMETERS
{}
```

# Setting up a Windows Host

https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html

* ansible

```sh
pip install "pywinrm>=0.3.0"
```

* WinRM setup (Tested with Windows Server 2012R2, 2016)

```powershell
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file
```

verify

```powershell
winrm enumerate winrm/config/Listener
Listener
    Address = *
    Transport = HTTP
    Port = 5985
    Hostname
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint
    ListeningOn = 127.0.0.1, 172.25.5.11, ::1, fe80::6db0:a8dd:1276:da54%12

Listener
    Address = *
    Transport = HTTPS
    Port = 5986
    Hostname
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint = 1f742be3bf238379120763469879aed5148929db
    ListeningOn = 127.0.0.1, 172.25.5.11, ::1, fe80::6db0:a8dd:1276:da54%12
```


# 4. playbook sample

## 4.1. create domain user ( extra vars )

```txt
---
# user infomain
user:  foo
firstname: xxx
surname: zzz
group: Tower Users
domain: x.kodamap.net
maildomain: kodamap.net
path: OU=Test,DC=x,DC=kodamap,DC=net
profilepath: \\profilesrv\Users\%UserName%
company: boo
# notificaton setting
smtp_server: x.x.x.x
smtp_port: 25
sender: foo@kodamap.net
recipient: foo@kodamap.net
# ansible config
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
```

You may get an error below:
```
AttributeError: 'ShellModule' object has no attribute 'ECHO'
```
->  Disable "Enable Previlige escalation"

## 4.2. create gsuite user  ( extra vars )

```txt
---
user: foo
givenname: foo
familyname: kodamap
maildomain: kodamap.net
groupkey: group1@kodamap.net
smtp_server: x.x.x.x.x
smtp_port: 25
sender: foo@kodamap.net
recipient: foo@kodamap.net
```