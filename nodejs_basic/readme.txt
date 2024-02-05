https://www.youtube.com/watch?v=9zUHg7xjIqQ

//creates an image named node-app-image
docker build -t node-app-image .

//run the image by creating a container named node-app using image node-app-image 
docker run -d -p 3000:3000 --name node-app node-app-image
//with shared folder
//windows cmd
docker run -d -p 3000:3000 --name node-app node-app-image -v %cd%:/app
//windows powershell
docker run -d -p 3000:3000 --name node-app node-app-image -v ${pwd}:/app
//mac or linux
docker run -v $(pwd):/app -d -p 3000:3000 --name node-app node-app-image
//prevent container's node_modules on being overwritten by mounted volume
docker run -v $(pwd):/app -v /app/node_modules -d -p 3000:3000 --name node-app node-app-image
//make it read only so container can't write host's mounted folder
docker run -v $(pwd):/app:ro -v /app/node_modules -d -p 3000:3000 --name node-app node-app-image
//add environment variable port 
docker run -v $(pwd):/app:ro -v /app/node_modules --env PORT=4000 -d -p 3000:4000 --name node-app node-app-image
//add environment variable from file
docker run -v $(pwd):/app:ro -v /app/node_modules --env-file ./.env -d -p 3000:4000 --name node-app node-app-image


//run docker-compose.yml file
docker-compose up
//run it even if terminal is closed
docker-compose up -d
//merge overwrite docker-compose.yml with docker-compose.dev.yml
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
//check help
docker-compose up --help
//rebuild image
docker-compose up -d --build

//stop container from running
docker-compose down
//include removing volumes
docker-compose down -v
//merged yaml
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v

//removes container
docker rm node-app -f 
//include volume
docker rm node-app -fv


//list containers that are running
docker ps 
//all containers
docker ps -a

//container's details like ip address
docker inspect node-app

docker network ls

//enter container terminal for windows
//for windows
docker exec -it node-app bash
//for ubuntu
docker exec -it node-app sh
//after entering container terminal, execute mongo u command.
docker exec -it node-app mongo u "root" -p "test101"

//to exit container terminal
exit
//print container terminal env
printenv

//check for container logs 
docker logs node-app


//volumes
//list all volumes
docker volume ls
//delete volumes
//unused
docker volume prune


//dockerfile
//npm install in prod mode which prevent dev dependencies from getting installed
RUN npm install --only=production

//embedded bash script
RUN if [ "$NODE_ENV" = "development" ]; \
    then npm install; \
    else npm install --only=production; \



//terminal
//list all files and folders
ls
//list vertically
ls -l
