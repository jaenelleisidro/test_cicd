#this prevent error "permission denied while trying to connect to the Docker daemon"
sudo chmod 666 /var/run/docker.sock

echo "$DOCKER_PASSWORD" | docker login --username jaenelleisidro --password-stdin

docker pull jaenelleisidro/test_cicd_nodejs:main



docker stop container_test_cicd_nodejs
docker rm container_test_cicd_nodejs

docker run -p 3000:3000 -d --name container_test_cicd_nodejs jaenelleisidro/test_cicd_nodejs:main
