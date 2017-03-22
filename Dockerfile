FROM node:7.0.0

# RUN apt-get update && \
#     apt-get install -y -qq

RUN npm install -g pm2@latest coffee-script

COPY . /usr/app
WORKDIR /usr/app
RUN npm install

ENV NODE_AWS_BUCKET=GTFO
ENV NODE_AWS_KEY=GTFO
ENV NODE_AWS_SECRET=GTFO

CMD ["npm", "start"]
