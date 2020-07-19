FROM tevun/server:1.0

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    curl \
    build-base \
    && pip install awscli --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/* \
    && ln -s /root/.local/bin/aws /usr/bin/aws
