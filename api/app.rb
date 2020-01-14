# frozen_string_literal: true

class EmailApplication < Sinatra::Base
  register Sinatra::Validation

  post '/email' do
    content_type :json

    validates do
      params do
        required(:to).filled(:str?)
        required(:to_name).filled(:str?)
        required(:from).filled(:str?)
        required(:from_name).filled(:str?)
        required(:subject).filled(:str?)
        required(:body).filled(:str?)
      end
    end

    body = JSON.parse(request.body.read, symbolize_names: true)

    email_constant = ENV.fetch('EMAIL_PROVIDER', 'sendgrid').capitalize
    email = Object.const_get("#{email_constant}Email").new(body)

    # TODO: Error handling
    response = email.send

    status response.code
    return { body: 'created' }.to_json
  end
end
