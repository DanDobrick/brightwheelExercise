# frozen_string_literal: true

require 'dotenv/load'
require 'rubygems'
require 'bundler'
require 'json'

require 'rack/contrib'

use Rack::PostBodyContentTypeParser

Bundler.require(:default, ENV['RACK_ENV'])

Dir[File.expand_path 'api/**/*.rb'].each { |f| require_relative(f) }

run EmailApplication
