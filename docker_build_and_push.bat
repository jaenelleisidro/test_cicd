@REM login using linux
@REM cat ~/docker_pat.txt | docker login --username jaenelleisidro --password-stdin

@REM login using windows
docker login --username jaenelleisidro --password-stdin < docker_pat.txt

@REM login using environment variable
@REM echo "$DOCKER_PASSWORD" | docker login --username jaenelleisidro --password-stdin

docker build -t test_cicd_nodejs ./nodejs_basic
docker tag test_cicd_nodejs jaenelleisidro/test_cicd_nodejs:v1.0


@REM docker images

docker push jaenelleisidro/test_cicd_nodejs:v1.0
pause