# Source search

* Source code - [Github][10]
* Author - Gavin Noronha - <gavinln@hotmail.com>

[10]: https://github.com/gavinln/source-search-vm

## About

This project provides a [Ubuntu (18.04)][20] [Vagrant][30] Virtual Machine
(VM) with source code search tools.

[20]: http://releases.ubuntu.com/18.04/
[30]: http://www.vagrantup.com/

1. [OpenGrok][40]

[40]: https://github.com/oracle/opengrok

2. [SourceGraph][50]

[50]: https://about.sourcegraph.com/

## OpenGrok

1. Start the virtual machine

```
vagrant up
```

2. Login to the virtual machine

```
vagrant ssh
```

3. Change to the project root directory

```
cd /vagrant
```

### Setup OpenGrok

1. Create directories

```
mkdir src data dist etc log
```

2. Download opengrok

```
curl -L -O https://github.com/oracle/opengrok/releases/download/1.3.7/opengrok-1.3.7.tar.gz
```

3. Unpack the tarball

```
tar -C ./dist --strip-components=1 -xzf opengrok-1.3.7.tar.gz
```

4. Copy the logging configuration file

```
cp ./dist/doc/logging.properties ./etc
```

### Setup the source code

1. Change to the source directory

```
cd ./src
```

2. use one of the training modules at GitHub as an example small app

```
git clone https://github.com/githubtraining/hellogitworld.git
```

3. Use a large app example

```
git clone https://github.com/OpenGrok/OpenGrok
```

### Setup Tomcat

1. Download Tomcat

```
curl -L -O https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz
```

2. Expand Tomcat

```
tar xvfz apache-tomcat-9.0.30.tar.gz
```

3. Copy the opengrok web app

```
cp ./dist/lib/source.war ./apache-tomcat-9.0.30/webapps/
```

3. Start Tomcat

```
./apache-tomcat-9.0.30/bin/startup.sh
```

4. Stop Tomcat

```
./apache-tomcat-9.0.30/bin/shutdown.sh
```

### Install universal-ctags

1. Install tools to build universal-ctags. Automatically run in `ctags-setup.yml`

2. Build and install ctags

```
cd ~
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh 
./configure
make
sudo make install
```

### Setup Indexing

1. Run the indexing

```
java \
    -Djava.util.logging.config.file=/mnt/c/ws/opengrok/etc/logging.properties \
    -jar ./dist/lib/opengrok.jar \
    -c /usr/local/bin/ctags \
    -s ./src \
    -d ./data -H -P -S -G \
    -W ./etc/configuration.xml \
    -U http://localhost:8080/source
```

### API

1. Get list of projects

```
curl http://localhost:8080/source/api/v1/projects
```

2. Search for definition in project

```
curl http://localhost:8080/source/api/v1/search?projects=dbutil&def=get_engine_data
```

## Source search

1. Login to virtual machine

```
vagrant ssh
```

2. Change to the project root directory

```
cd /vagrant
```

### Start source search

1. Start the Docker container

```
./scripts/sourcegraph-start.sh
```

### Setup Gogs git server

1. Get the gogs archive

```
curl -L -O https://dl.gogs.io/0.11.91/gogs_0.11.91_linux_amd64.tar.gz
```

2. Expand the gogs archive

```
tar xvfz gogs_0.11.91_linux_amd64.tar.gz
```

3. Change to the gogs directory

```
cd gogs
```

4. Run gogs

```
./gogs web
```

#### Push to the git server

```
git remote add alt http://192.168.33.10:3000/gavinln/OpenGrok.git
```
### Setup a local repository

https://docs.sourcegraph.com/admin/repo/add_from_local_disk

1. Change to the home directory

```
cd ~
```

2. Clone a test repository

```
git clone https://github.com/OpenGrok/OpenGrok
```

Use the gogs server to connect to Sourcegraph
