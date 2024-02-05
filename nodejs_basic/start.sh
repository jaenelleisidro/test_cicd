# docker build -t node-app-image .
# docker rm node-app -fv
# docker run -d -p 3000:3000 --name node-app node-app-image
# docker run -v $(pwd):/app -d -p 3000:3000 --name node-app node-app-image
# docker run -v $(pwd):/app -v /app/node_modules -d -p 3000:3000 --name node-app node-app-image
# docker run -v $(pwd):/app:ro -v /app/node_modules -d -p 3000:3000 --name node-app node-app-image
# docker run -v $(pwd):/app:ro -v /app/node_modules --env PORT=4000 -d -p 3000:4000 --name node-app node-app-image
# docker run -v $(pwd):/app:ro -v /app/node_modules --env-file ./.env -d -p 3000:4000 --name node-app node-app-image



docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
