## Containerized Deployment ##

Using containers ([Docker](https://www.docker.com)) enables the complete development or production environment to follow the code itself. Apps using docker can be pushed to Amazon Elastic Beanstalk directly, and used as a basis for auto-scaling load-balanced environments. The Docker setup of this app is broken into two parts: a local configuration using docker-compose, and a production configuration designed for use by Elastic Beanstalk in production.

[Local (Development) Container Setup Instructions](./container_development.md)
[Deployment (Production) Container Setup Instructions](./container_production.md)
