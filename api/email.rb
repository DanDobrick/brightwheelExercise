# frozen_string_literal: true

##
# Email is the parent class for both Sendgrid and Mailgun email classes. Handles HTTP requests and HTML stripping
# @author[DanDobrick]
##
class Email
  include HTTParty

  attr_reader :body, :options, :payload
  attr_accessor :endpoint

  ##
  # Initialize object and convert HTML in body to plaintext
  #
  # @param to [String]        Email address to send to
  # @param to_name [String]   Name of recipent
  # @param from [String]      Email of sender
  # @param from_name [String] Name of sender
  # @param subject [String]   Email subject
  # @param body [String]      Email body
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
  # @return HTTParty::Response
  ##
  def send
    fail Exceptions::EmailEndpointNotSet unless @endpoint

    self.class.post(@endpoint, body: @payload, **@options)
  end
end
