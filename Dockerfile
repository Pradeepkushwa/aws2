FROM ruby:3.0.0-alpine
ARG RAILS_ENV=production
ENV RAILS_ENV="${RAILS_ENV}"
ENV APP_VERSION=${TAG}
RUN apk update
RUN apk add bash build-base libxml2-dev libxslt-dev postgresql postgresql-dev nodejs vim yarn libc6-compat curl git which 
# Install system dependencies
RUN apk update && apk add --no-cache build-base

# Install Bundler 2.4.22
RUN gem install bundler -v 2.4.22

RUN mkdir /app
WORKDIR /app
COPY app/Gemfile* ./
RUN gem update --system 3.2.3
RUN apk add ffmpeg
RUN bundle install
COPY app/ .
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
