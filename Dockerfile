FROM alpine:3.5

EXPOSE 8090
ENV APP_ROOT /ducalis

RUN apk add --no-cache bc build-base \
  ca-certificates \
  git \
  ruby \
  ruby-dev \
  ruby-irb \
  ruby-rdoc \
  ruby-io-console \
  ruby-json \
  ruby-rake \
  sudo \
  openssh \
  nodejs
RUN gem install bundler
RUN bundle config silence_root_warning 1
RUN bundle config git.allow_insecure true

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT
RUN bundle install

COPY . $APP_ROOT
CMD bundle exec puma -p 8090 -e production
