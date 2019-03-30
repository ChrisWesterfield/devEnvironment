FROM node:8.15-alpine
LABEL maintainer="chris@spectware.com"
RUN apk --no-cache add bash

ENV APP_ROOT /app

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

RUN npm i -g @angular/cli \
    && npm i -g typescript

EXPOSE 4200

VOLUME /app
COPY init.sh /init.sh

CMD ["bash", "/init.sh"]