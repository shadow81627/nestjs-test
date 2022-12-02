FROM node:fermium-alpine as dev
RUN apk --update add postgresql-client

WORKDIR /usr/src/app
COPY package.json ./
COPY yarn.lock ./

RUN yarn install

COPY . .

RUN yarn run build

FROM node:fermium-alpine as prod
RUN apk --update add postgresql-client

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./

RUN yarn install

COPY . .

COPY --from=dev /usr/src/app/dist ./dist

CMD ["node", "dist/main"]