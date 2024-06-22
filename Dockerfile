FROM ruby:3.0.0-alpine

ARG RAILS_ENV=production
ENV RAILS_ENV="${RAILS_ENV}"
ENV APP_VERSION=${TAG}

# Install dependencies
RUN apk update && apk add --no-cache \
  bash \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql \
  postgresql-dev \
  nodejs \
  vim \
  yarn \
  libc6-compat \
  curl \
  git \
  which \
  ffmpeg

# Install Bundler
RUN gem install bundler -v 2.4.22

# Set up the app directory
RUN mkdir /app
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY app/Gemfile* ./

# Update RubyGems and install gems
RUN gem update --system 3.2.3
RUN bundle config set --local without 'development test'
RUN bundle config https://gem.fury.io/engineerai/ nvHuX-OXxLY2OpiQkFVfgnYgd4CszdA
RUN bundle install --jobs=4 --retry=3

# Copy the rest of the application code
COPY app/ .

# Expose port 3000 and define the command to run the app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
