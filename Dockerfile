FROM ruby:2.4
MAINTAINER Caio Penhalver

RUN echo "deb http://ftp.debian.org/debian experimental main" >> /etc/apt/sources.list
RUN echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install libc6 libstdc++6 unixodbc-dev -y --force-yes
RUN apt-get install -y --no-install-recommends vim nodejs npm postgresql-client locales

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN export LC_ALL="en_US.utf8"

RUN curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2 phantomjs-2.1.1-linux-x86_64/bin/phantomjs
RUN mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN rm phantomjs-2.1.1-linux-x86_64.tar.bz2 && rm -rf phantomjs-2.1.1-linux-x86_64/bin
RUN chmod 755 /usr/local/bin/phantomjs

RUN mkdir -p /connect

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
RUN gem install bundler-audit

WORKDIR /connect
ADD . /connect
