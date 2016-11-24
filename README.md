# SKELETON

This repository contains whole local setup for Skeleton. This documentation will explain how to download the skeleton code and build with docker. Docker functionalities are explained [here](https://docs.google.com/document/d/1F_FpwoRZtkJtyVVWAPPbsx3kTsleCWy3F_IJi2FBFKo/edit), so this document will not go into detail about docker commands.

1. [GOALS](#goals)
2. [PULL CODE](#pull-code)
3. [BUILDING AND RUNNING](#building-and-running)
4. [UPDATING SUBMODULES](#updating-submodules)
5. [UPDATING CODE](#updating-code)
6. [WORKING WITH SUBMODULES](#working-with-submodules)
7. [SETUP S3](#setup-s3)
8. [CONTINUOUS DEPLOYMENT](#continuous-deployment)
  - [Integrate github with circleci](#integrate-github-with-circleci)
  - [Setup Heroku](#setup-heroku)
  - [Integrate circleci with heroku](#integrate-circleci-with-heroku)
9. [STATIC FILES](#static-files)
10. [API DOCUMENTATION](#api-documentation)
11. [DEPLOYED SKELETON](#deployed-skeleton)
  - [API_URL](#api_url)
  - [SUPERADMIN_URL](#superadmin_url)
  - [WEB_URL](#web_url)


## GOALS

1. Explain how to pull the code
2. Explain how to build and run the skeleton
3. Explain how to update submodules
4. Explain how to update code
5. Explain how to work with submodules
6. Explain how to setup S3
7. Explain how to setup continuous deployment
8. Explain static files


## PULL CODE

The **skeleton** has 4 main applications:

* API
* WEB
* SUPERADMIN
* STATIC_FILES

All three are repositories and connected into one single repository **skeleton**. The proper way to pull the skeleton repo is using the command below:

    git clone --recursive https://github.com/EastCoastProduct/skeleton.git

This will pull the skeleton repository and all three repositories. If we remove the --recursive flag then it would just pull the skeleton and API, WEB, SUPERADMIN empty folders.


## BUILDING AND RUNNING

With the **skeleton** code downloaded we can build our containers. Navigate to the **skeleton** folder and run:

    docker-compose build --no-cache

After the build run the application with:

    docker-compose up

All three applications are listening on localhost.

* API - [http://localhost:3000](http://localhost:3000)
* WEB - [http://localhost:7000](http://localhost:7000)
* SUPERADMIN - [http://localhost:9000](http://localhost:9000)
* STATIC_FILES - [http://localhost:4000](http://localhost:4000)

_*Note: Docker containers are explained in the other “Local Setup with Docker” documentation._


## UPDATING SUBMODULES

When we pull the **skeleton** repository its submodules (API, WEB, SUPERADMIN) will point to one specific commit. It will not check github for changes and pull the latest to the skeleton, you need to do this yourself and keep the skeleton up to date with the **master** of the submodules.

There is a simple command to go through each submodule and update it to its **master**. You need to be in the root repository of the **skeleton** to run this command.

    git submodule update --remote

This command will update all the submodules to the remote branch we defined in our _.gitmodules_ file (_this file is explained in the “Working with submodules” chapter_).


## UPDATING CODE

All submodules that are updated with the command for updating submodules will point to a specific commit. This means that it will be detached from the repository and needs to be connected again when adding new code. To connect it simply **git checkout** a new branch or **master**. Updating code is done the same way as a normal github repository.

* navigate to the github repository
* add your new code
* commit
* push to your branch


## WORKING WITH SUBMODULES

Creating new submodules can be a bit confusing, so I will try to explain how to add a new submodule to an existing github repository.

1. Create a new repository that will be your submodule
2. Run ```git submodule add GITHUB_REPOSITORY_URL```
3. The command above should have created a file _.gitmodules_, this file is used to track individual submodules in your repository. All we need to do now is point our submodule to always pull the **master** branch when we run the update command.

 ```git config -f .gitmodules submodule.REPOSITORY_NAME.branch master```

 An example how we could switch our API to point to a development branch.

 ```git config -f .gitmodules submodule.api-skeleton.branch development```

 Now if we run ```git submodule update --remote``` it would update the api repository to the latest commit on the development branch.

_If you have any more questions, check out the git documentation on submodules [here](https://git-scm.com/book/en/v2/Git-Tools-Submodules)._


## SETUP S3

All the files uploaded with the application are stored on AWS S3. You will need to log into your AWS and create a new bucket. After creating the bucket you will need to copy the **bucket name** and set it inside of the config file. The config file is located in _/config/env/development.js_.

After creating the bucket you will need to add your AWS credentials into the **docker-compose.yml**. There are two environment variables for **ecp_api**:

* **AWS_ACCESS_KEY_ID**
* **AWS_SECRET_ACCESS_KEY**

***Never upload your credentials to a public repository!***


## CONTINUOUS DEPLOYMENT

For continuous deployment we are using [circleci](https://circleci.com/) and [heroku](https://www.heroku.com/). To setup continuous deployment you need to:

* Register an account on circleci
* Integrate github with circleci
* Setup heroku
* Integrate circleci with heroku
* Deploy to heroku using circleci

### Integrate github with circleci

To integrate circleci with github you need to have a repository setup. If you already have a repository setup you can navigate to the circleci dashboard and simply add your project to the builds.

* Click on the **ADD PROJECTS** button
* Select your project and click **Build Project** button

### Setup Heroku

To setup heroku we first need to register an account (_link to the [heroku homepage](https://www.heroku.com/)_). Once you have an account you need to create an application on heroku. The application name needs to be unique since it will be used for the url (_Example: https://ecp-api.herokuapp.com_). Now that we have our application setup we can configure circleci to deploy changes to heroku.

Navigate to your heroku profile and search for the **API KEY**. This key will enable circleci to deploy new changes to our application. Copy the key for now.

### Integrate circleci with heroku

To integrate circleci with heroku we need to do a couple of things.

* Add the **API KEY** from heroku
* Create or update our **circle.yml** file to know where to deploy our changes

Adding the api key:

* Navigate to the circleci dashboard
* Locate the **Account Settings** button
* Click on Heroku
* Paste the **API KEY** we copied in the section before to the keys

**circle.yml** changes:

* This file is used by circleci to know which commands to run, which services we are using etc. ( A detailed explanation for this file can be found here )
* We need to add this part at the bottom of the file:

  ```yaml
  deployment:
    staging:
      branch: master
      heroku:
        appname: skeleton-api
  ```
 * **deployment** - we set the deployment section of the file
 * **staging** - this is the environment we defined (_it can also be production or whatever we want to call it_)
 * **branch** - we define which branch should be pushed to the heroku application
 * **appname** - the heroku part just starts the heroku section of the file. We only defined the name of the application. (_The name we setup with heroku_)

_*Note: More detailed information can be found on the circleci [site](https://circleci.com/docs/continuous-deployment-with-heroku/)._


## STATIC FILES

This application is only used for testing files we use in our application. We have AWS S3 setup to store all user uploaded files. Things this container will contain:

* Logs - rsyslog is installed for this **container** and the configuration file is setup to send logs to the _src/logs_ folder. _Currently logs are only logged in the terminal. If you want to enable log forwarding to this container you will need to change the API code in the logger file. Rsyslog is not run by default and if you want to run it you can uncomment the line in static_files/docker-start.sh file_.
* Images - all images used on web (_uploaded / not uploaded by users_)
* Favicon
* Templates...


## API DOCUMENTATION

Steps to generate the API documentation:

1. Navigate to the api-documentation folder
2. Run the generate-docs.sh script:

 ```shell
 $ ./generate-docs.sh
 ```


## DEPLOYED SKELETON
Skeleton is already deployed to heroku for testing purposes, it is good chance deployed instances are going to be outdated.

### API_URL
https://skeleton-api.herokuapp.com

### SUPERADMIN_URL
https://skeleton-superadmin.herokuapp.com

### WEB_URL
https://skeleton-web.herokuapp.com
