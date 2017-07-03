# WordPress in Docker

This setup helps you get started with WordPress development with Docker as local environment.

*WordPress in Docker* uses Bedrock as moderm boilerplate of WordPress. [Bedrock](https://roots.io/bedrock/) is a modern WordPress stack that helps you get started with the best development tools and project structure.

[Docker](https://docs.docker.com/get-started/) is the most popular container solutions. It is easy to learn, light and an enough documented project.

## Requirements

* Docker 1.13.0+ [Install](https://docs.docker.com/engine/installation/)
* Docker Compose 1.10+ [Install](https://docs.docker.com/compose/install/)

## Installation

1. Create a new project in a new folder for your project:

  `mkdir your-project-folder-name`

2. Init a new repository:

  `git init your-project-folder-name`

3. Copy this repository into the new one:

```bash
$ cd your-project-folder-name
$ git pull https://github.com/ismael-benitez/wordpress-in-docker.git master
```

4. Copy the `docker-compose.yml` to the root and personalize the WordPress installation:

  ```bash
  $ cp docker/docker-compose.yml .
  $ vi docker-compose.yml
        TITLE: My Blog
        URL: http://localhost:8080
        ADMIN_USER: user
        ADMIN_PASSWORD: user
        ADMIN_EMAIL: email@domain.com
  ```
If you choose a different URL instead of `localhost`, you ensure that your computer can to resolve 
the hostname in the container, for example, editing `/etc/hosts` and adding the new hostname con IP `0.0.0.0`.

If you change the default public port `8080` to another, you must to edit the URL with the new port. For example:

```bash
    ports:
      - "8000:80"
    environment:
        URL: http://localhost:8000
```

If you need to initialize the database with a dump, save it in `docker/mysql/data` with `.sh` or `.sql` or `.sql.gz` 
format before doing the next step.

5. Start your containerized local environment:

```bash
$ docker-compose up -d
$ docker exec -it apache ant up
```

Wait for about 2 minutes! :)

6. Add theme(s) in `web/app/themes` as you would for a normal WordPress site.

7. Access WP admin at `http://localhost:8080/wp/wp-admin`

## Documentation

Bedrock documentation is available at [https://roots.io/bedrock/docs/](https://roots.io/bedrock/docs/).

Docker documentation is available at [https://docs.docker.com/](https://docs.docker.com/).

