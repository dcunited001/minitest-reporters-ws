# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "minitest/spec"
require "mocha/setup"
require "pry"

require "minitest/reporters"
require 'minitest/reporters/ws'

WS = Minitest::Reporters::Ws::Reporter
CLIENT = Minitest::Reporters::Ws::Client
YML = File.join(File.dirname(__FILE__), 'config', 'ws_reporter.yml')

def root_path
  File.dirname(__FILE__)
end

emoji = {
    'P' => "\u{1F49A} ", # heart
    'E' => "\u{1f525} ", # flame
    'F' => "\u{1f4a9} ", # poop
    'S' => "\u{1f37a} "} # beer

Minitest::Reporters.use! Minitest::Reporters::Ws::Reporter.new(emoji: emoji)