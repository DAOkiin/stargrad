#! /bin/bash

echo "Starting with UID : $(id -u) in $(pwd)"

if [[ ! -f "Gemfile"  && ! -f "Gemfile.lock" ]]; then
  echo "source 'https://rubygems.org'" > Gemfile \
  && echo "gem 'rails', '~> $RAILS_VERSION'" >> Gemfile \
  && touch Gemfile.lock \
  && gem install bundler --version "$BUNDLER_VERSION" \
  && bundle i
fi

rm -rf tmp/pids

exec "$@"
