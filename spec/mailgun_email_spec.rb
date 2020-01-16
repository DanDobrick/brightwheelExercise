# frozen_string_literal: true

describe MailgunEmail do
  before do
    ENV['MAILGUN_BASE_URI'] = 'base.example.com'
    ENV['MAILGUN_API_KEY'] = 'hunter2'
    ENV['MAILGUN_DOMAIN_NAME'] = 'my-custom.domain'
    ENV['MAILGUN_EMAIL_ENDPOINT'] = 'email-endpoint/'
  end

  let(:mailgun_email) do
    described_class.new(
      to: 'foo@example.com',
      to_name: 'Foo Bar',
      from: 'from@example.com',
      from_name: 'From Example',
      subject: 'subject',
      body: '<h1>Your Bill</h><p>$10</p>'
    )
  end

  let(:expected_body) { "Your Bill\n\n$10" }

  let(:expected_options) do
    {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      basic_auth: {
        username: 'api',
        password: 'hunter2'
      }
    }
  end

  let(:expected_payload) do
    {
      from: 'From Example <from@example.com>',
      to: 'Foo Bar <foo@example.com>',
      subject: 'subject',
      text: expected_body
    }
  end

  let(:constructed_email_endpoint) { 'base.example.com/my-custom.domain/email-endpoint' }

  let(:mock_response) do
    OpenStruct.new(parsed_response: { body: 'foobar' }, code: 412)
  end

  describe '#initialize' do
    it 'converts HTML to text in the body' do
      expect(mailgun_email.body).to eq(expected_body)
    end

    it 'sets proper email endpoint' do
      expect(mailgun_email.endpoint).to eq(constructed_email_endpoint)
    end

    it 'sets proper options' do
      expect(mailgun_email.options).to eq(expected_options)
    end

    it 'sets proper payload' do
      expect(mailgun_email.payload).to eq(expected_payload)
    end
  end

  describe '#send' do
    it 'sends proper payload and headers to expected url' do
      expect(described_class).to receive(:post).with(
        constructed_email_endpoint,
        body: expected_payload,
        headers: expected_options[:headers],
        basic_auth: expected_options[:basic_auth]
      ).and_return(mock_response)

      mailgun_email.send
    end
  end
end
