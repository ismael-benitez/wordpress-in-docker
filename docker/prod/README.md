# WordPress in Docker

You can use this image for getting a empty WordPress setup production ready in less of 2 minutes!

*WordPress in Docker* uses Bedrock as modern boilerplate of WordPress. [Bedrock](https://roots.io/bedrock/) is 
a modern WordPress stack that helps you get started with the best development tools and project structure.


## Requirements

* Docker 1.13.0+ [Install](https://docs.docker.com/engine/installation/)
* Docker Compose 1.10+ [Install](https://docs.docker.com/compose/install/)
* Docker Machine 0.9+ [Install](https://docs.docker.com/machine/install-machine/)
* Ant 1.9+ [Install](http://ant.apache.org/manual/install.html)


## Instructions

In the first time, you have to create your Docker Swarm cluster in your favorite cluster:

- Amazon [Tutorial](http://garbe.io/blog/2017/02/20/install-docker-swarm-on-aws-via-cloudformation/)
- Azure [Tutorial](https://docs.microsoft.com/en-us/azure/container-service/dcos-swarm/container-service-deployment)
- DigitalOcean [Tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-a-cluster-of-docker-containers-with-docker-swarm-and-digitalocean-on-ubuntu-16-04)

In the *docker/prod/* folder you can find a valid template for going up the WordPress services on your 
Docker Swarm.

If you just have provided the cluster with `docker-machine` (as DigitalOcean tutorial) then type from the 
project root path:

```bash
$ mkdir wordpress-in-docker && cd wordpress-in-docker
$ git clone https://github.com/ismael-benitez/wordpress-in-docker.git .
$ ant -buildfile docker/prod -Durl=ismaelbenitez.es -Did=ismaelbenitez_es up
```

Where `-buildfile` is the folder containing the Docker Swarm templates, `-Durl` is the domain assigned for you
to the WordPress (you should have set up the DNS previously) and `-Did` is the name of the [stack](https://docs.docker.com/engine/swarm/stack-deploy/) 
what you prefer on your Docker Swarm.

Finally you can check the stack status with `docker stack ls`, the services status with `docker service ls` or 
to navigate to the given url and to find the initial WordPress setup.


## Documentation

Bedrock documentation is available at [https://roots.io/bedrock/docs/](https://roots.io/bedrock/docs/).

Docker Swarm documentation is available at [https://docs.docker.com/engine/swarm/swarm-tutorial/](https://docs.docker.com/engine/swarm/swarm-tutorial/). 
