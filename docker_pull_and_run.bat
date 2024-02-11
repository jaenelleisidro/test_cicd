@REM login using linux
@REM cat ~/docker_pat.txt | docker login --username jaenelleisidro --password-stdin

@REM login using windows
docker login --username jaenelleisidro --password-stdin < docker_pat.txt

@REM login using environment variable
@REM echo "$DOCKER_PASSWORD" | docker login --username jaenelleisidro --password-stdin

docker pull jaenelleisidro/test_cicd_nodejs:main
docker run  -p 3000:3000 jaenelleisidro/test_cicd_nodejs:main
pause