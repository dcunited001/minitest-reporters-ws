require 'spec_helper'

describe Minitest::Reporters::Ws::Reporter do
  it '\'s spec\'n out man' do
    'spec'.wont_equal 'none'
  end
end
