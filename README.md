<a href="https://openfdapool2.ctacdev.com/" target="_blank">Working prototype</a>

Our Agile/Scrum certified development team followed an agile methodology to iteratively design, develop, implement, test, and improve requirements in short iterations.  Our process allowed stakeholders to provide constructive feedback and ensure transparency throughout the process.

In forming the 18F Prototype Team, CTAC’s agile/scrum coach identified resources and held an internal kickoff with team members to decide who would take the team lead responsibilities and accountability for monitoring timely completion of tasks, assessing the quality of work utilizing the Gitflow process of code commits and reviews, and ensuring adequate documentation[**(a)**](doc/Attachment E Approach Criteria Evidence.xlsx)[**(b)**](doc/Attachment E Approach Criteria Evidence.xlsx).

We established the technical vision for this project by brainstorming and made decisions based on what data the OpenFDA API made available, how the data could be visually interesting, and what could be useful to audiences that would likely be consuming the data. *Using this information as a foundation for the technical frameworks, we decided to use Ruby on Rails for its strong API-friendly framework, flexibility for reuse and sustainability*[**(c)**](doc/Attachment E Approach Criteria Evidence.xlsx).  *For the front-end we used technologies such as Handlebars.js*[**(c)**](doc/Attachment E Approach Criteria Evidence.xlsx).  Insight gathered from potential users such as nurses, healthcare providers and others illustrated a need to provide health related information in a meaningful way.  In today’s environment, social habits have changed and users want technology to help them become more knowledgeable about health conditions to make informed decisions regarding their health in a simple and intuitive way. To meet these needs and our own goals of interactivity and meaningful data display, we decided to use visualization tool D3 because it displays information in an interactive way and is flexible, reliable, and allowed us to create custom code to make the app responsive which is a main focus in any of our builds.

For this project, each sprint cycle included sprint planning (meaningful user stories, backlog prioritizations, release planning), daily 15 minute “standups” (quick reviews of tasks, flagging of impediments), and sprint reviews (demos/review of accomplishments, retrospectives/suggestions for continuous improvement). The calendar below represents a sample schedule of our daily tasks, sprint planning, and retrospectives.

<img src="doc/screenshots/pm/18f_sprint_cycle.png">

Utilizing Test Driven Development (TDD) practices is standard at CTAC as defined in our Playbook. *As part of this project, each developer began by writing a unit test, using RSpec for Ruby/Rails or QUnitJs for Javascript, for the task they picked up to ensure the goals of the task were fulfilled*[**(c)**](doc/Attachment E Approach Criteria Evidence.xlsx)[**(e)**](doc/Attachment E Approach Criteria Evidence.xlsx). Once the unit test was written, the coding effort began with the focus of passing the unit test. The code was adjusted until the test had been passed and the developer moved on to the next task.

As developers completed tasks and passed their automated tests, our GitFlow process and Code Review standards were monitored by the project lead. Commit messages were created by team members for their code as it was checked into their feature branch and a pull request within the GitHub repository was created. Automated code tools were deployed that we integrated with our Slack channel.  All team members were kept up to date and collaborated via slack and google hangouts.

*The app was “containerized” using Docker, enabling members of the team to easily check out the project and fire up a complete working instance with a simple command*[**(i)**](doc/Attachment E Approach Criteria Evidence.xlsx). Once a release was cut (tests pass, code pushed, a version number chosen, tagged, and merged into the master repository), *the Jenkins Continuous Integration server automatically deployed the container to Amazon Elastic Beanstalk*[**(d)**](doc/Attachment E Approach Criteria Evidence.xlsx)[**(f)**](doc/Attachment E Approach Criteria Evidence.xlsx)[**(i)**](doc/Attachment E Approach Criteria Evidence.xlsx). Amazon Services used the Dockerfile included in the project to *build and deploy a new production version of the application automatically in just minutes*[**(g)**](doc/Attachment E Approach Criteria Evidence.xlsx), an approach known as a *continuous delivery platform* (extremely short intervals between feature request and production release)[**(f)**](doc/Attachment E Approach Criteria Evidence.xlsx).  

As we approached the end of the sprint, *the team prepared a demo of the tasks accomplished to the Product Owner and Stakeholders to gain feedback (requirement sign-off, updated requirements, new features)*[**(j)**](doc/Attachment E Approach Criteria Evidence.xlsx). The Product Owner entered tasks into the backlog to groom and prioritize with the Stakeholders, which was the basis of the next sprint iteration.  After completing the sprint, a retrospective, facilitated by our Agile Coach, was held with the team to review the process and gain feedback from the team to continually look for process improvements.

We tested the integrity of the application by installing and running it solely using the installation *documentation and instructions provided*[**(k)**](doc/Attachment E Approach Criteria Evidence.xlsx).  Our prototype consists only of *open source or public domain licensed technologies*[**(l)**](doc/Attachment E Approach Criteria Evidence.xlsx).

**(a-l)** refers to criteria in Attachment E)