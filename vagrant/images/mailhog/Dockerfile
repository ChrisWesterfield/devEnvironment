FROM alpine:3.5
LABEL maintainer="chris@spectware.com"
#updating alpine
RUN apk update
RUN apk upgrade
# adding ca-certificates
RUN apk --no-cache add ca-certificates
#adding go, git and other dependencies, installing mailhog, removing unneded packages
RUN apk --no-cache add --virtual build-dependencies go git musl-dev \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go get github.com/mailhog/MailHog \
  && mv /root/gocode/bin/MailHog /usr/local/bin \
  && rm -rf /root/gocode \
  && apk del --purge build-dependencies
#adding mailhog user
RUN adduser -D -u 1000 mailhog
#setting standart user
USER mailhog
#setting working directory
WORKDIR /home/mailhog
#defining entry point on console entry
ENTRYPOINT ["MailHog"]
#setting exposed ports
EXPOSE 1025
EXPOSE 8025
