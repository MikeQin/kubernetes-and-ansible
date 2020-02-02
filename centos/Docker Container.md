# Docker Container Commands

* Stop all containers
```
docker container stop $(docker container ls -aq)
```

* Remove all containers
```
docker container rm $(docker container ls -aq)
```