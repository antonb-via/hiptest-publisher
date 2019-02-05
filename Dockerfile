FROM ruby:2.5.3

RUN mkdir -p /usr/src/app
RUN mkdir -p /output
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle install 

ENTRYPOINT ["bundle", "exec", "ruby", "-I", "lib", "bin/hiptest-publisher", "--config-file=hiptest-publisher.conf", "-o","/output","--test-run-id"]
