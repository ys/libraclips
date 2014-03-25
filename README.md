# Heroku Dataclips 2 Librato Tracker

This project aims to allow you to follow dataclips to be tracked on Librato.  
You can specify the base librato namespace of the metric and also the interval in which it has to be measured.

## Setup


```
$ bundle install
$ mv .env.example .env
$ $EDITOR .env  # set your env variables
$ psql -d d2l # or heroku pg:psql
psql > \i db/schema.rb
psql > \q
$ foreman start
```

### Differents ENV variables

* `LIBRATO_EMAIL`: Your librato email
* `LIBRATO_TOKEN`: Your API librato token. Can be found at: [https://metrics.librato.com/account](https://metrics.librato.com/account) > Api Access Tokens.
* `DATABASE_URL`: Auto provisioned on Heroku. Local default to `postgres://localhost:5432/dataclips2librato`
* `POLL_INTERVAL`: Minimum Time Between two migrations of the measurements.



