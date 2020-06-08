FROM node:14.4.0-alpine3.11 AS appbuild
WORKDIR /usr/src/app
COPY ./src/package.json ./
RUN npm install
COPY ./src ./
RUN npm run lint
RUN npm run compile

FROM node:14.4.0-alpine3.11
WORKDIR /usr/src/app
COPY --from=appbuild /usr/src/app/package.json ./
COPY --from=appbuild /usr/src/app/node_modules ./node_modules
COPY --from=appbuild /usr/src/app/dist ./dist
EXPOSE 8080
CMD npm start