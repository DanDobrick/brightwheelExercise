# Brightwheel Platform Engineering Exercise

 Dependencies and installation

## Dependencies
### Dependencies that need to be manually installed
- Ruby v2.6.3+
See Ruby's [installation page](https://www.ruby-lang.org/en/documentation/installation/) for information about installing ruby on your system.

This application uses [bundler](https://bundler.io/) which makes it easy to install any dependencies that are needed; to see any packages that were used, see the `Gemfile` in the root directory.

## Setup
### Using Make
After cloning the repo, change directories into the `brightwheelExercise` directory and run `make setup`. This will install needed dependencies.
```bash
cd brightwheelExercise
make setup
```

Once dependencies are installed use
```bash
make run
```
to run the server on `localhost:9292/`.

I've also provided a linter (using [Rubocop](https://www.rubocop.org/en/stable/)):
```bash
make lint
```
and a test runner (TESTS COMING SOON):
```bash
make test
```

### Manual installation
If you would rather not use the makefile provided, you can install the dependencies with the following commands:

```bash
	gem install bundler --conservative
	bundle check || bundle install
```

Then to run the server at `localhost:9292` run `bundle exec rackup`.
