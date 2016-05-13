export PATH := $(HOME)/bin:$(PATH):/usr/local/bin

all: deploy

stage:
	bundle exec jekyll build -c '_config.yml,_config.local.yml'

deploy:
	git add -A _posts _data archives
	git commit -m "Build for `date`"
	git push github gh-pages
