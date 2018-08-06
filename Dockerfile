FROM ruby:2.3

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
VOLUME /usr/src/app
WORKDIR /usr/src/app

EXPOSE 8001
CMD ["rails", "server","-p", "8001", "-b", "0.0.0.0"]

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY Gemfile /usr/src/app/

# Uncomment the line below if Gemfile.lock is maintained outside of build process
COPY Gemfile.lock /usr/src/app/


RUN bundle install

COPY . /usr/src/app
