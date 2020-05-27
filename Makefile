.PHONY: all serve clean deploy

export PATH := $(HOME)/bin:$(PATH):/usr/local/bin
PORT ?= 4000
IMAGE=danjones000/scrawls/ruby-with-bundler:1.0.0

all: serve

Gemfile.lock:
	docker run -u $(shell id -u) --rm -v $(shell pwd):/app -w /app ruby:2.6.3 sh -c 'gem install bundler:2.0.2 && bundle install'

.image: Gemfile.lock
	docker build -t $(IMAGE) .
	docker image inspect $(IMAGE) | jq -r '.[0].Id' | tee .image

_config.local.yml:
	touch $@

_site/index.html: .image _config.local.yml
	docker run -u $(shell id -u) --rm -v $(shell pwd):/app -w /app $(IMAGE) bundle exec jekyll build -c '_config.yml,_config.local.yml'

serve: _site/index.html
	docker run --rm -it -v $(shell pwd):/app -w /app -p $(PORT):$(PORT) $(IMAGE) bundle exec jekyll serve -H 0.0.0.0 -P "$(PORT)" -c '_config.yml,_config.local.yml'

clean:
	rm -rf _site

deploy:
	git add -A _posts _data archives
	git commit -m "Build for `date`"
	git push github gh-pages
