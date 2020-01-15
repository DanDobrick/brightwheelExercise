# frozen_string_literal: true

describe Email do
  let(:email) do
    described_class.new(
      to: 'foo@example.com',
      to_name: 'Foo Bar',
      from: 'from@example.com',
      from_name: 'From Example',
      subject: 'subject',
      body: '<h1>Your Bill</h><p>$10</p>'
    )
  end

  describe '#initialize' do
    it 'converts HTML to text in the body' do
      expected_body = "Your Bill\n\n$10"
      expect(email.body).to eq(expected_body)
    end
  end

  describe '#send' do
    context 'endpoint is not set' do
      it 'raises expected error' do
        expect { email.send }.to raise_error(Exceptions::EmailEndpointNotSet)
      end
    end

    context 'endpoint is set' do
      before { email.endpoint = 'example.com' }

      it 'sends payload to expected url' do
        expect(described_class).to receive(:post).with(
          'example.com',
          body: ''
        )

        email.send
      end
    end
  end
end
