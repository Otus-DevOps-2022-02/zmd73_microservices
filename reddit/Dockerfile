FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y wget ruby-full ruby-dev build-essential gnupg ruby-bundler && \
    wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    mkdir reddit

COPY ./ /reddit
COPY mongod.conf /etc/mongod.conf
COPY start.sh /start.sh

RUN cd /reddit && rm Gemfile.lock && bundle install && chmod 0777 /start.sh

CMD ["/start.sh"]
