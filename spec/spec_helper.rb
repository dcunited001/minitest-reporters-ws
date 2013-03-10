# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "minitest/spec"
#require "mocha"
#require "pry"

# in test/support/minitest_reporters.rb
require "minitest/reporters"
require 'minitest/reporters/ws'
emoji = {
    'P' => "\u{1F49A} ", # heart
    'E' => "\u{1f525} ", # flame
    'F' => "\u{1f4a9} ", # poop
    'S' => "\u{1f37a} "} # beer

MiniTest::Reporters.use! Minitest::Reporters::Ws::Reporter.new(emoji: emoji)


WS = Minitest::Reporters::Ws::Reporter
CLIENT = Minitest::Reporters::Ws::Client

def root_path
  File.dirname(__FILE__)
end

