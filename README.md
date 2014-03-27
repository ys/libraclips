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
$ foreman start -p 3000
```

### Differents ENV variables

* `LIBRATO_EMAIL`: Your librato email
* `LIBRATO_TOKEN`: Your API librato token. Can be found at: [https://metrics.librato.com/account](https://metrics.librato.com/account) > Api Access Tokens.
* `DEFAULT_LIBRATO_BASE_NAME`: Default prefix for all your metrics, if not specified per measurement.
* `DATABASE_URL`: Auto provisioned on Heroku. Local default to `postgres://localhost:5432/dataclips2librato`
* `POLL_INTERVAL`: Minimum Time Between two migrations of the measurements.
* `DEFAULT_RUN_INTERVAL`: Default time before a measure is outdated.
* `BASIC_AUTH_USERNAME`: Default username for web auth
* `BASIC_AUTH_PASSWORD`: Default password for web auth


## How to extend the possible transformations

Adding a new class under D2L::TransformFunctions.
This class just needs to implements two methods

* `#accepts?(dataclip)` This method permits to find a transform function for current dataclip
* `#transform` This is the actual transformation method. It should returns the metrics ready for Librato.   
Dataclip and measurement are injected and available via `D2L::TransformFunction::Base`

#### Class skeleton


```
module D2L
  module TransformFunctions
    class MyTransform < Base
      def accepts?(dataclip)
        # check if your function can handle the clip
        true
      end

      def transform
        # do amazing stuff with the dataclip
      end
    end
  end
end
```


## Web Interface

You can browse [localhost:3000](http://localhost:3000) to have a small API over this.
Default username and password : 'changeme'

### Endpoints
* GET `/measurements` : list measurements
* POST `/measurements` : Create a new measurement by posting json. 

  ```
  {
    dataclip_reference: 'url', 
    librato_base_name: 'Base.key.for.librato', 
    run_interval: 34
  }
  ```

## TODO

* Write tests, *this is always a todo*
* Analyse needs to write new and accurate transform functions.
* Rename project to libraclips





