FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y build-essential linux-libc-dev

# Install chamber to get secrets from parameter store
RUN curl https://github.com/segmentio/chamber/releases/download/v2.2.0/chamber_v2.2.0_amd64.deb --output chamber.deb -L
RUN dpkg -i chamber.deb
# We are just using the account's default ssm key to encrypt the values
# If this changes, we'll need to override this alias
ENV CHAMBER_KMS_KEY_ALIAS=aws/ssm
ARG DEFAULT_ENV_SSM_PATH="all/qa/ecs-task-env/prod"
ENV ENV_SSM_PATH=$DEFAULT_ENV_SSM_PATH

ENV APP_HOME /app_root
# ENV GEM_PATH=/usr/local/lib/ruby/gems/2.6.0
# ENV GEM_HOME=/usr/local/lib/ruby/gems/2.6.0
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY ./ $APP_HOME
WORKDIR $APP_HOME

# Create a non-root user to resolve issues with bundler, gems
RUN useradd -ms /bin/bash qauser
RUN chown qauser $APP_HOME/docker/entry.sh
USER qauser

RUN gem install bundler -v 2.1.2
# # COPY Gemfile* $APP_HOME/
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=~/vendor/bundle
RUN bundle install --without test development

RUN chmod u+x docker/entry.sh

ENV SKIP_CLOUDWATCH=true
ENV RUNNING_ON_LOCAL_DEV=true


ENTRYPOINT ["bash", "docker/entry.sh"]
