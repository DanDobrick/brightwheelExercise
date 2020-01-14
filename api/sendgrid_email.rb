# frozen_string_literal: true

##
# SendgridEmail object to encapsulate Sengrid specific logic. Inherits from Email object
# @author[DanDobrick]
##
class SendgridEmail < Email
  ##
  # Endpoint to send Email request to
  # @return String
  ##
  def email_endpoint
    ENV.fetch('SENDGRID_EMAIL_ENDPOINT')
  end

  ##
  # Sendgrid auth headers containing API key
  # @return Hash
  ##
  def auth_headers
    { authorization: "Bearer #{ENV.fetch('SENDGRID_API_KEY')}" }
  end

  ##
  # Sendgrid specific email payload
  # @return Hash
  ##
  def payload
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
    }
  end
end
