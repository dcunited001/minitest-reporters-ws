module Minitest::Reporters::Ws
  class Client
    DEFAULT_CONFIG = { 'host' => "localhost", 'port' => "10081" }

    attr_accessor :socket
    attr_accessor :host, :port

    def initialize(opts = {})
      init_config(opts.delete(:yml), opts.delete(:config), opts.delete(:env))
      init_socket
    end

    def send_msg(data)
      @socket.send(data.to_json)
    end

    def close
      @socket.close
    end

    private

    def init_socket
      @timestamp = Time.now.to_i
      @socket = WebSocket.new("ws://localhost:10081")
    end

    def init_config(file, conf, env = 'test')
      config = conf
      config = read_conf(file, env) if file
      config ||= DEFAULT_CONFIG

      @host = config['host']
      @port = config['port'].to_i
    end

    def read_conf(filename, env)
      YAML::load(File.open(filename))[env]
    end

  end
end


