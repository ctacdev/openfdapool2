## Continuous Integration (CI) Server ##

Development Snapshot: [![Build Status](http://ec2-54-175-101-110.compute-1.amazonaws.com/buildStatus/icon?job=OpenFDA Pool2)](http://ec2-54-175-101-110.compute-1.amazonaws.com/job/OpenFDA Pool2)

[Build Radiator](http://ec2-54-175-101-110.compute-1.amazonaws.com/view/Pool%202%20Radiator)

### Reports
- [Test Report](http://ec2-54-175-101-110.compute-1.amazonaws.com/view/Pool%202/job/OpenFDA%20Pool2/lastCompletedBuild/testReport/)
- [Code Coverage Report](http://ec2-54-175-101-110.compute-1.amazonaws.com/view/Pool%202/job/OpenFDA%20Pool2/Code_Coverage_Report/)
- [Test History Analysis](http://ec2-54-175-101-110.compute-1.amazonaws.com/view/Pool%202/job/OpenFDA%20Pool2/test_results_analyzer/)

Stable Release: [![Build Status](http://ec2-54-175-101-110.compute-1.amazonaws.com/buildStatus/icon?job=OpenFDA Release Pool2)](http://ec2-54-175-101-110.compute-1.amazonaws.com/job/OpenFDA Release Pool2)

### CI Server Config ###

#### Background ####

- The CI server is [Jenkins](https://jenkins-ci.org).
- There should be separate development and production environments
- The development environment should run automated tests and report results
- The production environment should build the docker container and push to Amazon Elastic Beanstalk

#### Prerequisites ####

A public facing server with the following installed

- [JRE](http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html)
- [Jenkins](https://jenkins-ci.org)
- [EB CLI](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)
- [Git](https://git-scm.com)

#### Development Setup ####

There are several Jenkins plugins that facilitate the building, testing, and reporting of rails projects that have been installed in addition to the default plugin set:

- Build Monitor Plugin
- CloudBees Docker Build and Publish plugin
- CloudBees Docker Hub Notification
- embeddable-build-status
- HTML Publisher plugin
- Rake plugin
- rbenv plugin
- ruby-runtime
- Slack Notification Plugin
- Test Results Analyzer Plugin


---

A Freeform Jenkins project was created and configured to monitor the github repo where the project code resides. Since this was a private repo, an SSH keypair was generated on github to allow jenkins access to the repo (read-only).

The rbenv plugin was used is declare the ruby environment to use, and to preinstall the bundler and rake gems.

Then a shell script is executed to prepare the config files and install required gems.

    #!/bin/bash

    #Prepare Environment
    export PATH="/usr/local/bin:$PATH"

    #config setup
    cp ~/railsAppConfigs/fda_rfq_database.yml.test config/database.yml
    cp ~/railsAppConfigs/fda_rfq_secrets.yml.test config/secrets.yml

    #dependency install
    bundle install

Finally, execute the rake tasks that both test the application and build reports (this is done with the rake task plugin).

     bundle exec rake ci:all spec

All important build messages are reported via email and Slack to interested parties.

### Automatic Release Deployment ###

Automated deployment (continuous delivery) is implemented with a second Jenkins project targeted specifically at release duties. The setup is identical to the development project with two exceptions:

1. The project monitors the /master branch instead of develop
2. The shell script task is responsible for building the docker container and deploying it instead of simply creating test reports

The shell script can be seen here:

    #!/bin/bash

    #Prepare Environment
    export PATH="/usr/local/bin:$PATH"

    #copy env files
    rm config/database.yml
    rm config/secrets.yml
    rm -rf .elasticbeanstalk
    cp -r ~/railsAppConfigs/fda_rfq.elasticbeanstalk .elasticbeanstalk
    cp ~/railsAppConfigs/fda_rfq_database.yml.production config/database.yml
    cp ~/railsAppConfigs/fda_rfq_secrets.yml.production config/secrets.yml
    cp ~/railsAppConfigs/fda_rfq.env.production .env.production

    #cleanup
    rm -rf log && mkdir log
    find . -type f -name *.example -delete

    #make a clean git commit to deploy
    git branch -D prodDeploy
    git branch prodDeploy
    git checkout prodDeploy
    git rm .gitignore
    git add -A
    COMMIT_MESSAGE=`git log -n 1 --oneline | cut -c 9-`
    git commit -m "$COMMIT_MESSAGE"

    #deploy app to Elastic Beanstalk
    echo "Beginning AWS Deploy"
    eb deploy openfdaprod3-env --timeout 60

    #Run Migrations
    CONTAINER_ID=`ssh -t -i ~/.ssh/rfq.pem ec2-user@ec2-54-175-201-115.compute-1.amazonaws.com -t sudo docker ps | awk '/aws_beanstalk/{ print $1 }'`
    echo "Container found: $CONTAINER_ID"
    ssh -t -i ~/.ssh/rfq.pem ec2-user@ec2-54-175-201-115.compute-1.amazonaws.com -t sudo docker exec $CONTAINER_ID bundle exec rake db:migrate RAILS_ENV=production
    echo "Migration Complete"

The highlight operations include:

1. Cleaning up after a previous build
2. Copying the config files from a static location on the server (these are the config files that define how the app should work on Amazon Elastic Beanstalk)
3. The EB CLI expects to be run on a clean git commit, but we've modified the repo, so branch and commit changes temporarily, preserving previous commit message.
4. Run EB CLI deploy command (this uses git archive to zip the project and push to s3)
5. Elastic Beanstalk will deploy the uploaded project automatically into a new staging Docker container and then cascade update all load balanced instances if staging was successful (otherwise changes are rolled back)
6. Connect to primary container and initiate production rake tasks
