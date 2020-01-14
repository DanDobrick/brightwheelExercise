# frozen_string_literal: true

require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] = 'test'
Bundler.require(:default, ENV['RACK_ENV'])

Dir[File.expand_path './api/*.rb'].each { |f| require_relative(f) }

module RSpecMixin
  include Rack::Test::Methods
  def app
    EmailApplication
  end
end

RSpec.configure { |c| c.include RSpecMixin }
