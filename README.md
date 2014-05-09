# Libraclips

## Heroku Dataclips 2 Librato Tracker

![](https://dl.dropboxusercontent.com/s/19mxjz04a96z4tw/libraclips.png?token_hash=AAFGAxyAaL9DKbnVFWTNwO4fKhqpZsb7E6uVK8okPqlPQg)

This project aims to allow you to follow dataclips to be tracked on Librato.
You can specify the base librato namespace of the metric and also the interval in which it has to be measured.


**DISCLAIMER** If you are not lucky enough to have your database hosted at Heroku, Please take a look to [@mmcgrana](https://github.com/mmcgrana) Go implementation to attack directly the database and export to librato : [mmcgrana/pg2librato](https://github.com/mmcgrana/pg2librato)
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

## Example of possible dataclips output that work actually

### Simple value

![](https://dl.dropboxusercontent.com/s/3gik7c7i6u4cpre/Screenshot%202014-05-09%2018.32.57.png?token_hash=AAGZzwi2Yeo3jjAKUySyHpgHQVlDr_l7_EL32YJuGHCDRw&expiry=1399656842)

#### Metrics created

One named by the metric name. Here:
- random

### Column with name + value

![](https://dl.dropboxusercontent.com/s/iuzhm4kgc4e8jl4/Screenshot%202014-05-09%2018.33.20.png?token_hash=AAGt4eTNBY_B1YMkkndPQQaWZ2F4D2UANcZ2G4Jlbmp8tw&expiry=1399656891)

#### Metrics created

One for each line. Here: 
- os.Linux
- os.Windows
- os.OSX

### Matching based on column name (Here we export each column to a separate metric)

![](https://dl.dropboxusercontent.com/s/xdjoniuf9xvvh0m/Screenshot%202014-05-09%2018.33.33.png?token_hash=AAEdX0MqdgDxsfTHh3Ni0dg8nzN_vu9vcbty407Ywo8SIg&expiry=1399656939)

#### Metrics created

One of each per line. Named `<metric_name>.<line_title>.<metric_type>`
- count
- average
- min
- max
- median
- perc90
- perc95
- perc99

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
* ~~Rename project to libraclips~~





