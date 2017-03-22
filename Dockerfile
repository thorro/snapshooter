FROM node:7.0.0

# RUN apt-get update && \
#     apt-get install -y -qq

RUN npm install -g pm2@latest coffee-script
RUN pm2 install coffeescript

COPY . /usr/app
WORKDIR /usr/app
RUN npm install

ENV NODE_AWS_BUCKET=GTFO
ENV NODE_AWS_KEY=GTFO
ENV NODE_AWS_SECRET=GTFO

CMD ["pm2", "start", "src/main.coffee", "--no-daemon"]
