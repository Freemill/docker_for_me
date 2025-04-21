FROM node:alpine

WORKDIR /home/app

COPY /devops-docker/my-nodejs/package.json ./package.json
COPY /devops-docker/my-nodejs/app.js ./app.js

RUN npm install

CMD ["node", "app.js"]