### Development Container Setup ###

#### Background ####

- Development environment uses mysql
- Development is done primarily on Mac OS X
- Environment should be simple to launch & configurable

#### Setup Instructions ####

**Prerequisites**

- [homebrew](http://brew.sh)
- [git](https://git-scm.com)
- [docker](https://www.docker.com)
- [boot2docker](https://github.com/boot2docker/osx-installer/releases)
- [docker-compose](https://docs.docker.com/compose/)
- [The app](https://github.com/ctacdev/openfda_rfq) checked out and ready to run

**Configuration**

Development setup consists of three primary parts:

1. *Dockerfile* - Defines how container is setup, configured, and app is installed
2. *docker-compose.yml* - Defines the local docker container stack, links containers, and provides environment variables
3. *.env.<name>*  - where environment variables are stored.

The *Dockerfile* provides details on how to build the image

Since it is necessary to have slightly different configurations in dev vs prod (environment is different, asset pre-compilation should be enabled for prod, etc...) we can define two different Dockerfiles and distinguish between them in the docker-compose.yml (see below). The Dockerfile for the local development environment looks like this:

    FROM library/ruby:2.2.2

    RUN apt-get update -qq && apt-get install -y build-essential

    # for nokogiri
    RUN apt-get install -y libxml2-dev libxslt1-dev

    # for a JS runtime
    RUN apt-get install -y nodejs

    ENV APP_HOME /openfda
    RUN mkdir $APP_HOME
    WORKDIR $APP_HOME

    ADD Gemfile* $APP_HOME/
    RUN bundle install

    ADD . $APP_HOME

    CMD ["foreman", "start", "-e", ".env.web", "web"]

The container inherits the base ruby 2.2.2 image, which comes preconfigured with everything needed to run a started rails app. There are a few more container requirements (libraries, frameworks) and those are installed using apt-get from within the container at build time. After defining the app home directory, creating it, and declaring it the WORKDIR, the Gemfile is added and bundle is invoked to install app dependencies. Then the app code itself is added to the home directory. A default command is provided to enable running the app without docker-compose (straight docker).

The *docker-compose.yml* file defines the individual containers, and looks something like this:

	db:
      image: mysql
      ports:
        - "13306:3306"
      environment:
        - MYSQL_ROOT_PASSWORD=ABC123def

    web:
      dockerfile: Dockerfile-development
      build: .
      command: foreman start web
      ports:
        - "80:3000"
      links:
        - db
      volumes:
        - .:/openfda
      env_file:
        - '.env.web'

There are two containers defined, "db" and "web". In db, image defines which image the container is based (official mysql latest), ports exposes the mysql database port to the host (via port 13306 as not to conflict with any local 3306 mysql instances on host), and the environment key contains the initial root password for mysql.

The web container specifies an alternate Dockerfile (Dockerfile-development) on which build upon in development. This Dockerfile omits some of the production only procedures, like compiling static assets. The web container also specifies the location to find build files (local directory), the command to run when starting the container (in this case overriding the Dockerfile), the port bindings (listen on 80 and forward to 3000), other containers to link to (the database), which volumes to link to (for outside <-> inside container file linking), and which environment file to include. The env_file includes database connection details, and other settings for rails/puma.

**Running the App**

Starting up is simple, assuming all the prerequisites are installed, cd into the project directory, and fire up docker-compose:

    $ cd path/to/project
    $ docker-compose pull && docker-compose build && docker-compose up

If this is the first time the app has been run, or if you have recently updated the app and need to update the data model, make sure to run the appropriate rake tasks. This can be done from a second terminal session while the docker containers are running (with docker-compose).

    # create the database, and run a migration
    $ docker-compose run web bundle exec rake db:create db:migrate RAILS_ENV=development

    # import the initial data set:
    $ docker-compose run web bundle exec rake import_active_ingredients RAILS_ENV=development

The app will run until the session is closed or ctrl-c is input. If you want to run the app as a daemon, include the -d flag when running docker-compose up.

**Interacting with the App**
If using boot2docker (on Mac OS X or Windows), then the container stack itself is running on a virtual machine. To interact with the app, the IP of the machine is needed.

    $ boot2docker ip

This command will print the ip of the local container vm. Use it to interact with the app, for instance, in the browser we might navigate to: http://192.168.59.103

You can add an entry to your /etc/hosts file or use DNSmasq to create a host name for convenience.
