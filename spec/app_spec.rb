# frozen_string_literal: true

describe 'Application' do
  before do
    allow_any_instance_of(Email).to receive(:post).with(anything).and_return(mock_response)
  end

  let(:mock_response) do
    OpenStruct.new(parsed_response: { body: 'foobar' }, code: 412)
  end

  let(:proper_post_body) do
    {
      to: 'fake@email.com',
      to_name: 'Mr. Fake',
      from: 'noreply@mybrightwheel.com',
      from_name: 'Brightwheel',
      subject: 'A Message from Brighwheet',
      body: '<h1>Your Bill</h><p>$10</p>'
    }
  end

  let(:headers) { { 'Content-Type': 'application/json' } }

  describe 'validations' do
    context 'missing parameters' do
      let(:expected_error_messages) do
        [
          'to is missing',
          'to_name is missing',
          'from is missing',
          'from_name is missing',
          'subject is missing',
          'body is missing'
        ]
      end

      let(:parsed_body) { JSON.parse(last_response.body, symbolize_names: true) }

      before do
        post '/email', {}
      end

      it 'returns expected error message' do
        error_messages = parsed_body[:errors]

        expect(error_messages.sort).to eq(expected_error_messages.sort)
      end

      it 'returns expected status code' do
        expect(last_response.status).to eq(400)
      end
    end
  end

  xdescribe 'selecting mail provider' do
    context 'env is not set' do
      before { ENV['EMAIL_PROVIDER'] = nil }

      it 'defaults to sendgrid' do
        expect(SendgridEmail).to receive(:new).with(anything)

        post('/email', proper_post_body.to_json, headers: headers)
      end
    end

    context 'env is set to sendgrid' do
      before { ENV['EMAIL_PROVIDER'] = 'sendgrid' }

      it 'Uses proper class' do
        expect(SendgridEmail).to receive(:new).with(anything)

        post('/email', proper_post_body.to_json, headers: headers)
      end
    end

    context 'env is set to mailgun' do
      before { ENV['EMAIL_PROVIDER'] = 'mailgun' }

      it 'Uses proper class' do
        expect(MailgunEmail).to receive(:new).with(anything)

        post('/email', proper_post_body.to_json, headers: headers)
      end
    end
  end

  xdescribe 'sending email' do
  end

  xdescribe 'response code' do
  end
end
