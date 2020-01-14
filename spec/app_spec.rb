# frozen_string_literal: true

describe 'Application' do
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
end
