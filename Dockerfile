FROM ruby:2.5.3

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle install 
RUN bundle exec ruby -I lib bin/hiptest-publisher --config-file=hiptest-publisher.conf --test-run-id=230449 && ls

ENTRYPOINT ["hiptest-publisher"]

# RUN chmod 777 .
WORKDIR /app
VOLUME /app
