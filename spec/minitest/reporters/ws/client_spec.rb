require 'spec_helper'

describe Minitest::Reporters::Ws::Client do
  subject { CLIENT.new(yml: YML) }

  it '\'s spec\'n out man' do
    'spec'.wont_equal 'none'
  end

  describe "#initialize" do
    before do
      WebSocket.expects(:new)
    end

    it 'reads the correct config' do
      subject.host.must_equal 'localhost'
      subject.port.must_equal 10081
    end
  end

end
