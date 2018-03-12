require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/reservation'
require_relative '../lib/reservation_manager'
require_relative '../lib/block'
require_relative '../lib/hotel'
require_relative '../lib/guest'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
