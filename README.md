# knowrob_docker
Dockerfile for KnowRob with Ubuntu 20.04 and ROS noetic

## Build docker image

Build knowrob image:

```bash
docker build -t knowrob .
```

## Start containers

Start knowrob and mongodb:

```Bash
docker-compose up
```

Then start your extra nodes, for example rosprolog_commandline:

```Bash
docker run -it --rm --net knowrob_network --name rosprolog_cli --env ROS_MASTER_URI=http://knowrob:11311 knowrob rosrun rosprolog rosprolog_commandline.py
```
