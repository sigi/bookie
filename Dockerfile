ARG RUBY_VERSION=2.7.3
FROM ruby:$RUBY_VERSION-slim-buster as runtime

RUN mkdir -p /srv
WORKDIR /srv

# APT settings
ENV DEBIAN_FRONTEND=noninteractive
ENV APT_CONFIG=/etc/apt/local-apt.conf
COPY .dockerdev/apt.conf ${APT_CONFIG}
# Mirror for Debian packages
RUN sed -i 's,http\://deb\.debian\.org,http\://ftp.de.debian.org,g' /etc/apt/sources.list

# Common dependencies
RUN apt-get update \
&& apt-get dist-upgrade \
&& apt-get install build-essential gnupg2 curl less git tmux vim-tiny tzdata shared-mime-info \
&& cp /usr/share/mime/packages/freedesktop.org.xml ./ \
&& apt-get remove shared-mime-info \
&& apt-get clean \
&& rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/* && truncate -s 0 /var/log/*log \
&& mkdir -p /usr/share/mime/packages && mv ./freedesktop.org.xml /usr/share/mime/packages/

# Add PostgreSQL to sources list
ARG PG_MAJOR=12
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
&& echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Add NodeJS to sources list
ARG NODE_MAJOR=14
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Application dependencies
# We use an external Aptfile for that, stay tuned
COPY .dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update \
&& apt-get install nodejs yarn $(grep -Ev '^\s*#' /tmp/Aptfile | xargs) \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && truncate -s 0 /var/log/*log

# Configure bundler
ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Uncomment this line if you store Bundler settings in the project's root
# ENV BUNDLE_APP_CONFIG=.bundle

# Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
ENV PATH /srv/bin:$PATH

ARG BUNDLER_VERSION=2.2.15
# Upgrade RubyGems and install required Bundler version
RUN gem update --system && gem install bundler:$BUNDLER_VERSION


FROM runtime as production
WORKDIR /srv

# Configure bundler
ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Create empty directories necessary for Rails
RUN mkdir -p log tmp/pids

COPY Gemfile Gemfile.lock ./
RUN bundle install --frozen --without development test

# Assets precompilation
COPY ./Rakefile ./
COPY ./postcss.config.js ./
COPY ./bin ./bin
COPY ./lib ./lib
COPY ./app/models/application_record.rb ./app/models/
COPY ./app/models/user.rb ./app/models/
COPY ./config ./config
COPY ./app/assets ./app/assets
COPY ./app/controllers ./app/controllers

RUN bundle exec rake assets:precompile RAILS_ENV=production NODE_ENV=production \
&& yarn cache clean \
&& rm -rf node_modules

# Copy application
COPY . .
