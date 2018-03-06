require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/reservation'
require_relative '../lib/reservation_manager'
require_relative '../lib/block'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
