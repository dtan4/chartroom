# Chartroom

[![Build Status](https://travis-ci.org/dtan4/chartroom.svg?branch=master)](https://travis-ci.org/dtan4/chartroom)

Look down the structure of Docker images and containers.

## Run as a Docker container

```shell
$ docker run -p 9292:9292 -v /var/run/docker.sock:/var/run/docker.sock dtan4/chartroom
```

Please do not forget `-v /var/run/docker.sock:/var/run/docker.sock` option!

## Run on the local machine

```shell
$ git clone https://github.com/dtan4/chartroom.git
$ cd chartroom
$ bundle install
$ bundle exec rackup
```

## Screenshot

![screenshot](docs/images/screenshot.png)

## License

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
