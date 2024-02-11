FROM node:lts-alpine3.18

WORKDIR /app

COPY package.json .
ARG NODE_ENV
RUN if [ "$NODE_ENV" = "development" ]; \
    then npm install; \
    else npm install --only=production; \
    fi
# RUN npm install
#needed for production
COPY . ./

ENV PORT 80
EXPOSE $PORT

CMD ["node", "index.js"]
