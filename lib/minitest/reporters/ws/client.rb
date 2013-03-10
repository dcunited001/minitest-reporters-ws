module Minitest::Reporters::Ws
  class Client
    DEFAULT_CONFIG = { 'host' => "localhost", 'port' => "10081" }

    attr_accessor :no_server
    attr_accessor :socket
    attr_accessor :host, :port

    def initialize(opts = {})
      init_config(opts.delete(:yml), opts.delete(:config), opts.delete(:env))
      init_socket
    rescue => ex
      puts ex.message
    end

    def identify
      data = { receiver: "server", method: "identify", arguments: ["rspec"] }
      @socket.send(data.to_json) if connected?
    rescue => ex
      puts ex.message
    end

    def send_msg(data)
      @socket.send(data.to_json) if connected?
    rescue => ex
      puts ex.message
    end

    def close
      # hmmm, i want to leave the connection open
      data = { receiver: "server", method: "disconnect", arguments: ["rspec"] }
      @socket.send(data.to_json) if connected?
      @socket.close if connected?
    rescue => ex
      puts ex.message
    end

    def connected?
      !!socket
    end

    private

    def init_socket
      @timestamp = Time.now.to_i
      @socket = begin
        WebSocket.new("ws://localhost:10081")
      rescue => ex
        puts ex.message
        nil
      end
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


