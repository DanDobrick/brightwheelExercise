# frozen_string_literal: true

class Application < Sinatra::Base
  register Sinatra::Validation

  post '/email' do
    content_type :json

    validates do
      params do
        required(:to).filled(:str?)
      end
    end

    body = JSON.parse(request.body.read)

    return { body: body }.to_json
  end
end
