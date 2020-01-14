setup:
	gem install bundler --conservative
	bundle check || bundle install

run:
	bundle exec rackup

run-dev:
	bundle exec shotgun

lint:
	bundle exec rubocop

test:
	bundle exec rspec
