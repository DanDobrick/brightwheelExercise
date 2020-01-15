# frozen_string_literal: true

describe SendgridEmail do
  before do
    ENV['SENDGRID_EMAIL_ENDPOINT'] = 'foo.example.com'
    ENV['SENDGRID_API_KEY'] = 'hunter2'
  end

  let(:sendgrid_email) do
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
        'Content-Type': 'application/json',
        authorization: 'Bearer hunter2'
      }
    }
  end

  let(:expected_payload) do
    {
      personalizations: [
        {
          to: [
            email: 'foo@example.com',
            name: 'Foo Bar'
          ]
        }
      ],
      from: {
        email: 'from@example.com',
        name: 'From Example'
      },
      subject: 'subject',
      content: [
        {
          type: 'text/plain',
          value: expected_body
        }
      ]
    }
  end

  describe '#initialize' do
    it 'converts HTML to text in the body' do
      expect(sendgrid_email.body).to eq(expected_body)
    end

    it 'sets proper email endpoint' do
      expect(sendgrid_email.endpoint).to eq('foo.example.com')
    end

    it 'sets proper options' do
      expect(sendgrid_email.options).to eq(expected_options)
    end

    it 'sets proper payload' do
      expect(sendgrid_email.payload).to eq(expected_payload.to_json)
    end
  end

  describe '#send' do
    it 'sends proper payload and headers to expected url' do
      expect(described_class).to receive(:post).with(
        'foo.example.com',
        body: expected_payload.to_json,
        headers: expected_options[:headers]
      )

      sendgrid_email.send
    end
  end
end
