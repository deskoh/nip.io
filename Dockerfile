FROM alpine:3.7

RUN apk add --no-cache pdns pdns-backend-pipe  pdns-backend-bind bind python2

ENV DOMAIN=local

EXPOSE 53/tcp 53/udp

COPY nipio/backend.py /usr/local/bin
RUN chmod +x /usr/local/bin/backend.py
COPY nipio/backend.conf /usr/local/bin
COPY pdns/ /etc/pdns/

ADD entrypoint.sh /
RUN chmod +x entrypoint.sh

CMD ["/entrypoint.sh", "--disable-syslog", "--write-pid=no"]
