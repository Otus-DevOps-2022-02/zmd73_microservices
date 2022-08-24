FROM ubuntu:16.04

ENV APP_HOME /app

RUN apt-get update \
    && apt-get install -y ruby-full ruby-dev build-essential \
    && gem install bundler --no-ri --no-rdoc \
    && mkdir $APP_HOME \
    && rm -rf /var/lib/apt/*

WORKDIR $APP_HOME

COPY . $APP_HOME/
RUN bundle install

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
