FROM coders51/ruby-phantomjs:latest
WORKDIR /root/
COPY Gemfile* ./
RUN bundle install --deployment
COPY bin ./bin/
COPY config ./config/
COPY logs ./logs/
COPY spec ./spec/
COPY .rspec ./
