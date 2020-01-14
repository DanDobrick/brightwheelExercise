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

    body = JSON.parse(request.body.read)

    return { body: body }.to_json
  end
end
