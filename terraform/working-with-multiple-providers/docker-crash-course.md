# A crash course on Docker

Docker run command to run the docker images locally..

`docker run nginx bash`

Docker run with interactive shell..

`docker run -it ubuntu:20.04 bash`

To get all the containers..

`docker ps -a`

For starting a container.. and attaching an interactive prompt via `-ia` flags

`docker start -ia containerID`

For running a docker container

`docker run training/webapp`

To run docker at a port

`docker run -p 5000:5000 training/webapp`

To remove a container..

`docker rm containerID`

To check all the containers

`docker ps`

For killing a container

`docker kill containerID`

