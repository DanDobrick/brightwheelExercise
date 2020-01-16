# frozen_string_literal: true

##
# MailgunEmail object to encapsulate Mailgun specific logic. Inherits from Email object
# @author[DanDobrick]
##
class MailgunEmail < Email

  ##
  # Initialize new instance of MailgunEmail and set email endpoint, options and payload
  # @param to [String]        Email of recipent
  # @param to_name [String]   Name of recipent
  # @param from [String]      Email of sender
  # @param from_name [String] Name of sender
  # @param subject [String]   Email subject
  # @param body [String]      Email body
  # @return [MailgunEmail]
  ##
  def initialize(**args)
    super(**args)

    @endpoint = email_endpoint
    @options = request_options
    @payload = email_payload
  end

  private

  ##
  # Endpoint to send Email request to
  # @return String
  ##
  def email_endpoint
    base_uri = ENV.fetch('MAILGUN_BASE_URI').chomp('/')
    domain = ENV.fetch('MAILGUN_DOMAIN_NAME').chomp('/')
    endpoint = ENV.fetch('MAILGUN_EMAIL_ENDPOINT').chomp('/')

    "#{base_uri}/#{domain}/#{endpoint}"
  end

  ##
  # Options for mailgun emails; includes basic_auth
  # @return Hash
  ##
  def request_options
    {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      basic_auth: {
        username: 'api',
        password: ENV.fetch('MAILGUN_API_KEY')
      }
    }
  end

  ##
  # Mailgun specific email payload
  # @return Hash
  ##
  def email_payload
    {
      from: "#{@from_name} <#{@from}>",
      to: "#{@to_name} <#{@to}>",
      subject: @subject,
      text: @body
    }
  end
end
