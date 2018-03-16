FROM ruby:2.5

USER root

ARG RAILS_VERSION

ENV RAILS_VERSION=$RAILS_VERSION \
    APP_HOME=/usr/src/pdf-service \
    PATH=$APP_HOME/bin:$PATH \
    DEV_UID=1000 \
    DEV_USER=rails \
    EXPOSE_PORT=3000

COPY entrypoint.sh /usr/src/

RUN set -ex \
  && chmod +x /usr/src/entrypoint.sh \
  && apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs \
  && adduser -u $DEV_UID $DEV_USER \
  && mkdir -p $APP_HOME \
  && cd $APP_HOME \
  && chown -R $(id $DEV_USER -u) "$GEM_HOME" "$BUNDLE_BIN" "$APP_HOME" '/usr/src/entrypoint.sh' \
  && cd /usr/src

USER $DEV_USER
WORKDIR $APP_HOME
EXPOSE $EXPOSE_PORT
ENTRYPOINT ["../entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
