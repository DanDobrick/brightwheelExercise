# frozen_string_literal: true

class Response

  ##
  # Initialize object
  #
  # @param body [String|Hash]    Response body
  # @param status_code [Integer] Status code
  ##
  def initialize(body:, status_code:)
    @status_code = status_code
    @body = body
  end

  ##
  # Standardizes succesful response codes around 202; allows consumers of the API to have a consistent experience
  # On success Mailgun responds with a 200 and Sengrid responds with a 202
  # @return Integer
  ##
  def code
    @status_code == 200 ? 202 : @status_code
  end

  ##
  # If the response body is empty, this will respond with a standard message
  # This is done because Sendgrid responds with an empty body on a successful POST to the email
  # @return Hash
  ##
  def body
    @body || { response: 'Email queued for sending' }
  end
end
