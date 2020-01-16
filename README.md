# Brightwheel Platform Engineering Exercise

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

The Mailgun and Sendgrid URLs are already copied over, but you'll need to fill out other information:
1) MAILGUN_API_KEY
2) MAILGUN_DOMAIN_NAME
3) SENDGRID_API_KEY

## Usage
Make sure the service is standing up using `make run` and POST to `localhost:9292`

example CURL:
```bash
curl --location --request POST 'localhost:9292/email' \
--header 'Content-Type: application/json' \
--data-raw ' {
  "to": "fake@email.com",
  "to_name": "Mr. Fake",
  "from": "noreply@mybrightwheel.com",
  "from_name": "Brightwheel",
  "subject": "A Message from Brighwheel",
  "body": "<h1>Your Bill</h><p>$10</p>"
}'
```

Example response:
```json
{
    "response": "Email queued for sending"
}
```

### Selecting an email provider
Change the value of `EMAIL_PROVIDER` in the `.env` file to `sendgrid` or `mailgun` to use the selected mail provider. Capitalization does not matter; the API will automatically select the correct service to use. If the ENV is not provided the application will default to sendgrid

## Technical Decisions

# Ruby
In short, I'm most familiar with Ruby and wanted to spend more time writing good code + tests rather than learning a new tool, language or working with something I have less experience with.

## Sinatra
I decided to use Sinatra instead of Rails since this was a light-weight project not requiring much of Rails feature-set. If we decided this would be the extent of the application I would suggest possibly deploying the app to something like AWS lambda + api gateway; if we wanted to increase the number of features I might suggest moving to Rails since there _are_ more features and a larger amount of support.

## HttParty
[HttParty](https://github.com/jnunemaker/httparty) is a simple HTTP library that makes it easy to make requests and parse responses. If we needed multi-threading or something that has more performance I would use something like `HTTP.rb` but HTTParty works fine for something like this task.

## html2text
Although the library doesn't have many stars of [github](https://github.com/soundasleep/html2text_ruby), it had been updated recently, did the job and didn't have anything glaring when I looked at the source code. I did _not_ want to code this one by hand!

## sinatra-validation
I chose [sinatra-validation](https://github.com/IzumiSy/sinatra-validation) because it was a sinatra-specific parameter validator that used [dry-validation](https://github.com/dry-rb/dry-validation) which is respected ruby validation library; it also seemed easy to use and had been updated recently.

## Tradeoffs and Future considerations
If I had more time I would add the following features:

- Happy path `app.rb` tests
  - I was having a problem with the combination of `rack-test`, `sinatra-validation` and a POST body that contained `body` as a key. I was unable to convince `sinatra-validation` that yes, the keys were truly there. Everything worked when testing it locally, but I already spent too much time wrestling with those tests so I decided to stop working on them for the purposes of this challenge.
  - I outlined the beginning of what I would test in `app_spec.rb` using pending tests and I would add more as I went along.
- More parameter validation on the to/from emails
  - Ensure that the email coming in is formatted correctly and possibly do an `mx` record lookup before sending the payload to the email service.
  - Doing this will limit the number of requests to our service (possibly saving money) as well as limit the network connections (and therefore response time) when a user is providing a bogus email address
- Create `shared_examples` in the spec files for some of the shared behavior.
  - I think you should always strive for DRY-ness, even in testing files.
- Add failover; if one mail provider is down, automatically failover to other provider.
  - Obviously this is something that is out of scope for this request, but in a real-life scenario I would suggest having one provider failover to the other in event of downtime.
- Custom Error handling/retry logic
  - Even if we are not failing over, it would be a good idea to have retry logic for certain status codes in order to protect against "blips" in the 3rd party systems.
