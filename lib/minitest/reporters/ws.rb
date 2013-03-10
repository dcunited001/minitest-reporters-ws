#require 'minitest/unit'
require 'ansi/code'
require 'minitest/reporters'

require 'web_socket'

module Minitest
  module Reporters
    module Ws
    end
  end
end

require 'minitest/reporters/ws/reporter'
require 'minitest/reporters/ws/client'
