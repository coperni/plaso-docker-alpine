FROM python:3.10-alpine3.16


ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV CFLAGS="$CFLAGS -D_GNU_SOURCE"

# Install dependencies
RUN apk update \
  && apk add xz-dev \
             zeromq \
             \
  # Install dependencies
  && apk add --virtual .temp \
                       build-base \
                       git \
                       linux-headers \
  && rm -rf /var/cache/apk/* \
  \
  # Add new user
  && adduser -D plaso \
  \
  # Install plaso
  && git clone --branch=main \
               --depth=1 \
               https://github.com/log2timeline/plaso.git \
               /plaso \
  && cd /plaso \
  && pip install -r requirements.txt \
  && pip install elasticsearch \
  && python setup.py install \
  \
  # Clean up
  && apk del .temp \
  && rm -rf /root/.cache \
  && rm -rf /plaso

VOLUME /data

USER plaso

ENTRYPOINT ["log2timeline.py"]
