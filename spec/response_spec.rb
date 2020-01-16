# frozen_string_literal: true

describe ::Response do
  describe '.code' do
    context 'given status code is 200' do
      let(:response) { described_class.new(body: 'foo', status_code: 200) }

      it 'returns status 202' do
        expect(response.code).to eq(202)
      end
    end

    context 'given status code is another number' do
      let(:response) { described_class.new(body: 'foo', status_code: 412) }

      it 'returns original status code' do
        expect(response.code).to eq(412)
      end
    end
  end

  describe '.body' do
    context 'given status code is nil' do
      let(:response) { described_class.new(body: nil, status_code: 412) }

      it 'returns expected response' do
        expect(response.body).to eq(response: 'Email queued for sending')
      end
    end

    context 'body is anything else' do
      let(:response) { described_class.new(body: 'foo', status_code: 412) }

      it 'returns original body' do
        expect(response.body).to eq('foo')
      end
    end
  end
end
