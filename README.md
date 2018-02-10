# Base

Docker image with basic utilities. The purpose of this image is to act as a virtualenv 

## Building

```
docker build -rm -t localrepo/virtualenv .
```

## Usage

It's as simple as:

```
docker pull localrepo/virtualenv
docker run -d localrepo/virtualenv
```

Once the container is up you can access the supervisord web interface and optionally start the SSH server.

### Customize exposed ports

By default, the ports `22` (sshd), and `9001` (supervisord) is mapped to random ports on the docker host. To customize, run:

```
docker run -p 22:22 -p 9001:9001 localrepo/virtualenv
```

### Debugging

By default, the container runs `supervisord`. If you want to start a shell in the foreground, run:

```
docker run -t -i -p 22:22 -p 9001:9001 localrepo/virtualenv /bin/bash
```

## Exposed ports

* `22` - SSH Server
* `9001` - Supervisor
