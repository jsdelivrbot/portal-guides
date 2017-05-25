FROM node:7-alpine

RUN apk add --update alpine-sdk python-dev

COPY exec.sh /exec.sh
RUN chmod +x /exec.sh

# Fix bug https://github.com/npm/npm/issues/9863
RUN cd $(npm root -g)/npm \
  && npm install fs-extra \
  && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js
  
RUN npm install npm@4 -g
RUN npm install node-gyp -g
# RUN node-gyp install

# Create & set app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app 

# Build nuxt 
RUN npm build

CMD [ "npm", "start" ]

# ENTRYPOINT ["node"]

EXPOSE 3000

