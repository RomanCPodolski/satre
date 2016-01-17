$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'satre'
require 'minitest/autorun'

include Satre
