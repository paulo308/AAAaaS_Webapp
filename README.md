## AAAaaS_Webapplication

AAAaaS Websapp is a RESTful application that provides authentication, authorisation and accounting. The service is offered in a Graphical User Interface (GUI) and a REST API. It connects to the Web Server of the AAA service and ensures secure communications by using SSL certificates. It also connects to the Database of the AAA service.

In this repository it is possible to find two ways of deployment using Docker containers. One way recurring to Marathon and another as standalone. Both ways demand a consequent deployment of the complementary services: web server and database).


Docker Hub link (for built images):
https://hub.docker.com/r/paulo308/aaaaas_webapp/

# Master (or envVar) branch 

It is to be used with Marathon. The JSON file inserted in marathon to launch the container must contain the database's IP address and port, and the domain name where the service is to be deployed. The latter is necessary to configure the application's email settings (to create account, reset password, etc). 

Example: 
`"parameters": [
        {
          "key": "env",
          "value": "DOMAIN_NAME=http://exampledomain:1234"
        },
        {
          "key": "env",
          "value": "AUTH_DB_PORT=12345"
        },
        {
          "key": "env",
          "value": "AUTH_DB_HOST=10.20.30.40"
        }`
        

# DockerNetwork branch

It is to be used when manual container deployment is made. It is pre-configured to be used with a custom Docker Network described in the documentation.

In this case, the user neeeds to create a Docker network (if not created yet) such as the following example:
`docker network create --driver=bridge --subnet=172.250.0.0/24 --gateway=172.250.0.1 aaanet`

Next, it is necessary to launch the container attached to the previously created network with the tag "dockerNetwork":
`docker run --name webapp --ip=172.250.0.85 --net=aaanet -p 9000:9000 -ti paulo308/aaaaas_webapp:dockerNetwork`

Note that it is necessary to deploy the remaing containers of the AAA service to complete instalation. Please refer to the following repositories:
* Web Server (https://github.com/paulo308/AAAaaS_Webserver)
* Database (https://github.com/paulo308/AAAaaS_Mongodb)

Obs: this version of the application connects to the Database without certificates. If you do not own the infrastrucutre where the services are deployed or it does not meet your security standards, it is advisable to connect to database using certificates please refere to branch: DockerNetworkSSL_DB (https://github.com/paulo308/AAAaaS_Webapp/tree/dockerNetworkSSL_DB)

 Please note that if you choose to use this versions, you should manually modify the configuration files provided before deployment and building Docker images. Namelly, Nginx configuration file for domain, ports and certificates location and Web App for email domain and database IP and Port.

