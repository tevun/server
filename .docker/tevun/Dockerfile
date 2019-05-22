# small is beautiful
FROM docker:18.06.3-ce

# The container listens on port 8110, map as needed
EXPOSE 80
EXPOSE 443

# This is where the repositories will be stored, and
# should be mounted from the host (or a volume container)
VOLUME ["/app"]

# We need the following:
# - git, because that gets us the git-http-backend CGI script
# - fcgiwrap, because that is how nginx does CGI
# - spawn-fcgi, to launch fcgiwrap and to create the unix socket
# - nginx, because it is our frontend
RUN apk add --update nginx && \
    apk add --update bash && \
    apk add --update git && \
    apk add --update git-daemon && \
    apk add --update fcgiwrap && \
    apk add --update spawn-fcgi && \
    apk add --update apache2-utils && \
    apk add --update py-pip && \
    apk add --update python-dev libffi-dev openssl-dev gcc libc-dev make && \
    rm -rf /var/cache/apk/*

COPY ./etc/nginx/.users /etc/nginx/.users
COPY ./etc/nginx/tevun.conf /etc/nginx/tevun.conf
COPY ./etc/nginx/ssl /etc/nginx/ssl
COPY ./etc/nginx/nginx.conf /etc/nginx/nginx.conf

RUN pip install docker-compose

RUN addgroup -S tevun && adduser -u 1000 -S tevun -G tevun

# launch fcgiwrap via spawn-fcgi; launch nginx in the foreground
# so the container doesn't die on us; supposedly we should be
# using supervisord or something like that instead, but this
# will do
CMD spawn-fcgi -s /run/fcgi.sock /usr/bin/fcgiwrap && \
    nginx -g "daemon off;"