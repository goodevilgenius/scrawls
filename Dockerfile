FROM ruby:2.6.3

RUN gem install bundler:2.0.2 && \
    bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install
