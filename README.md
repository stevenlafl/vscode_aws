# Web Based VS Code with PHP extensions installed

https://github.com/cdr/code-server project with neccessary PHP extensions for XDebug to work, and Telemetry and Automatic Updates disabled

## Getting Started

These instructions will cover usage information and for the docker container

### Prerequisities

In order to run this container you'll need docker installed.

- [Windows](https://docs.docker.com/windows/started)
- [OS X](https://docs.docker.com/mac/started/)
- [Linux](https://docs.docker.com/linux/started/)

### Usage

Run

```shell
docker run -it -p 8080:8080 stevenlafl/vscode_aws -v ./:/home/coder/project
```

Need to run within docker compose?

    ide:
        container_name: '${PROJECT_NAME}_ide'
        image: stevenlafl/vscode_aws
        volumes:
          - ./:/home/coder/project
        ports:
            - '8080:8080'

#### Volumes

- `/home/coder/project` - Mount your local project into this folder

## Built With

- https://github.com/cdr/code-server latest [LICENSE-code-server.txt](LICENSE-code-server.txt)
