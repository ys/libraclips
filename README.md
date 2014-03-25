# Libraclips

## Heroku Dataclips 2 Librato Tracker

![](https://dl.dropboxusercontent.com/s/19mxjz04a96z4tw/libraclips.png?token_hash=AAFGAxyAaL9DKbnVFWTNwO4fKhqpZsb7E6uVK8okPqlPQg)

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

## How to extend the possible transformations

Adding a new class under D2L::TransformFunctions.
This class just needs to implements two methods

* `#accepts?(dataclip)` This method permits to find a transform function for current dataclip
* `#call(dataclip, options)` This is the actual transformation method. It should returns the metrics ready for Librato.

## TODO

* Write tests
* Analyse needs to write new and accurate transform functions.
* Add Logging and better error handling
* Add Dependency Injection to be able to be compliant with other services than Librato
* Rename project to libraclips





