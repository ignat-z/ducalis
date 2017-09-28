FROM alpine:3.5

ARG token
EXPOSE 8090
ENV APP_ROOT /ducalis
ENV GITHUB_TOKEN=$token

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

RUN mkdir -p "$APP_ROOT"
WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN bundle install

COPY . $APP_ROOT
CMD bundle exec puma -p 8090 -e production
