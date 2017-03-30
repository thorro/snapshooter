FROM node:7

ENV NODE_AWS_BUCKET=GTFO
ENV NODE_AWS_KEY=GTFO
ENV NODE_AWS_SECRET=GTFO

COPY . /usr/app
WORKDIR /usr/app

RUN apt-get update \
    && apt-get -y install vim

RUN npm install -g pm2@latest coffee-script \
  && pm2 install coffeescript \
  && npm install

CMD ["pm2", "start", "src/main.coffee", "--no-daemon"]
