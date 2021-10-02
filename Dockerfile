FROM node:14-alpine as build
WORKDIR /www
COPY package.json yarn.lock ./
RUN yarn install  --production --frozen-lockfile
COPY . /www/


FROM node:14-alpine as release
RUN apk --no-cache add tini
ENTRYPOINT ["tini", "--"]
USER node
ARG container_port=80
ENV PORT=80
ENV NODE_ENV=production
EXPOSE $PORT
WORKDIR /www
COPY --from=build --chown=root:root /www /www
CMD ["node", "src/web-server.js"]
