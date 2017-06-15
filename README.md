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

  `cd your-project-folder-name`
  `git pull git@github.com:ismael-benitez/wordpress-in-docker.git master`

4. Copy the docker-compose.yml to the root:

  `cp docker/docker-compose.yml .`

5. Start the containers:

  `docker-compose up -d`

6. Create your local environment variables:

  `cp .env.example .env`

7. Install the dependencies:

  `docker exec -it apache composer install`
  
8. Generate the security keys:

  `docker exec -it apache vendor/bin/wp --allow-root dotenv salts regenerate`

  Or, you can cut and paste from the [Roots WordPress Salt Generator][roots-wp-salt].

9. Add theme(s) in `web/app/themes` as you would for a normal WordPress site.

10. Access WP admin at `http://localhost:8080/wp/wp-admin`

## Documentation

Bedrock documentation is available at [https://roots.io/bedrock/docs/](https://roots.io/bedrock/docs/).

Docker documentation is available at [https://docs.docker.com/](https://docs.docker.com/).

