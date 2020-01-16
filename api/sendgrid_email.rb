# frozen_string_literal: true

##
# SendgridEmail object to encapsulate Sengrid specific logic. Inherits from Email object
# @author[DanDobrick]
##
class SendgridEmail < Email
  ##
  # Initialize new instance of SendgridEmail and set email endpoint, options and payload
  # @param to [String]        Email of recipent
  # @param to_name [String]   Name of recipent
  # @param from [String]      Email of sender
  # @param from_name [String] Name of sender
  # @param subject [String]   Email subject
  # @param body [String]      Email body
  # @return [SendgridEmail]
  ##
  def initialize(**args)
    super(**args)

    @endpoint = ENV.fetch('SENDGRID_EMAIL_ENDPOINT')
    @options = request_options
    @payload = email_payload
  end

  private

  ##
  # Options for Sendgrid emails; includes auth headers
  # @return Hash
  ##
  def request_options
    {
      headers: {
        'Content-Type': 'application/json',
        authorization: "Bearer #{ENV.fetch('SENDGRID_API_KEY')}"
      }
    }
  end

  ##
  # Sendgrid specific email payload
  # @return Hash
  ##
  def email_payload
    {
      personalizations: [
        {
          to: [
            email: @to,
            name: @to_name
          ]
        }
      ],
      from: {
        email: @from,
        name: @from_name
      },
      subject: @subject,
      content: [
        {
          type: 'text/plain',
          value: @body
        }
      ]
    }.to_json
  end
end
