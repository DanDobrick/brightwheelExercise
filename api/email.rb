# frozen_string_literal: true

##
# Email is the parent class for both Sendgrid and Mailgun email classes. Handles making HTTP requests and HTML stripping
# @author[DanDobrick]
##
class Email
  include HTTParty

  attr_reader :body, :options, :payload
  attr_accessor :endpoint

  ##
  # Initialize object and convert HTML in body to plaintext
  #
  # @param to [String]        Email of recipent
  # @param to_name [String]   Name of recipent
  # @param from [String]      Email of sender
  # @param from_name [String] Name of sender
  # @param subject [String]   Email subject
  # @param body [String]      Email body
  # @return [Email]
  ##
  def initialize(to:, to_name:, from:, from_name:, subject:, body:)
    @to = to
    @to_name = to_name
    @from = from
    @from_name = from_name
    @subject = subject
    @body = Html2Text.convert(body)
    @endpoint = nil
    @options = {}
    @payload = ''
  end

  ##
  # Sends email to email provider; options provided by child class
  # @return ::Response
  ##
  def send
    fail Exceptions::EmailEndpointNotSet unless @endpoint

    response = self.class.post(@endpoint, body: @payload, **@options)

    # Ideally this would be namespaced to prevent collisions, but for the purposes of this exercise
    # I decided to use the '::' operator
    ::Response.new(body: response.parsed_response, status_code: response.code)
  end
end
