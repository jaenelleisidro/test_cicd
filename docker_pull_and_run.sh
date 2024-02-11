echo "$DOCKER_PASSWORD" | docker login --username jaenelleisidro --password-stdin

docker pull jaenelleisidro/test_cicd_nodejs:main
docker run  -p 3000:3000 jaenelleisidro/test_cicd_nodejs:main
pause