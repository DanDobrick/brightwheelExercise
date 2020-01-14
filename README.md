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
and a test runner:
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

### Envs
This application is using the `.env` pattern. Simply copy the `.env.example` and fill out the details inside:
```bash
cp .env.example .env
```

The Mailgun and Sendgrid URLs are already copied over, but you'll need to fill out the API keys for each service.

## Usage

## Technical Decisions

# Ruby
In short, I'm most familiar with Ruby and wanted to spend more time writing good code + test rather than learning a new tool, language or working with something I have less experience with.

## Sinatra
I decided to use Sinatra instead of Rails since this was a light-weight project not requiring much of Rails feature set. If we decided this would be the extent of the application I would suggest keeping Sinatra and possibly deploying the app to something like AWS lambda; if we wanted to increase the number of features I might suggest moving to Rails since there _are_ more features and a larger amount of support.

## HttParty
Simple HTTP library that makes it easy to make requests and parse output. If we needed multi-threading or something that has more performance I would use something like `HTTP.rb` but HTTPart works fine for something like this task.

## Tradeoffs and Future considerations
- More parameter validation on the to/from emails
