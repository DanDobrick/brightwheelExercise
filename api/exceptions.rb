# frozen_string_literal = true

module Exceptions
  class EmailEndpointNotSet < StandardError
    def initialize(msg = 'Email endpoint not set, please use SendgridEmail or MailgunEmail classes')
      super(msg)
    end
  end
end
