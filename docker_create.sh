docker_name=$USER-deep-learning
docker container stop $docker_name
docker container rm $docker_name
docker build -t deep-learning-image-torch .
docker run  -d --name $docker_name  --shm-size 16G -it  --ulimit memlock=-1 deep-learning-image-torch