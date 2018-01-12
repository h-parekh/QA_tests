FROM ruby:alpine
RUN apk --no-cache add \
 curl \
 fontconfig \
 g++ \
 gcc \
 libgcrypt-dev \
 libxml2-dev \
 libxslt-dev \
 make \
 pkgconf
# add phantomjs
RUN mkdir -p /usr/share && \
  cd /usr/share \
  && curl -sL https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/2.11/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
  && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs \
  && phantomjs --version
ADD Gemfile* ./
RUN bundle install --deployment
