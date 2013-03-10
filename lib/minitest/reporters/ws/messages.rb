module Minitest::Reporters::Ws
  module Messages

    def messages
      { identify: { receiver: "server", method: "identify", arguments: ["rspec"] },
        close: { receiver: "server", method: "disconnect", arguments: ["rspec"] },
        start_new_iteration: { receiver: "web", method: "startNewIteration" },
        add_to_passing: { receiver: "web", method: "addToPassing" },
        add_to_pending: { receiver: "web", method: "addToPending" },
        add_to_erring: { receiver: "web", method: "addToFailing" },
        add_to_failing: { receiver: "web", method: "addToFailing" } }
    end

    def identify
      @client.send_msg(messages[:identify])
    end

    def close
      @client.send_msg(messages[:close])
      @client.close
    end

    def start_new_iteration(test_count = 420)
      @client.send_msg(messages[:start_new_iteration].merge arguments: [@timestamp, test_count])
    end

    def add_to_passing(test)
      @client.send_msg(prep_result(test, :add_to_passing))
    end

    def add_to_pending(test)
      @client.send_msg(prep_result(test, :add_to_pending))
    end

    def add_to_failing(test)
      @client.send_msg(prep_result(test, :add_to_failing))
    end

    def add_to_erring(test)
      # for now, this is treated the same as failing
      @client.send_msg(prep_result(test, :add_to_erring))
    end

    private

    def prep_result(test, key)
      test_data = example_to_hash(test)
      messages[key].merge arguments: [@timestamp, test_data]
    end

    def example_to_hash(test)

      { :started_at => test.metadata[:execution_result][:started_at].to_i,
        :finished_at => test.metadata[:execution_result][:finished_at].to_i,
        :run_time => test.metadata[:execution_result][:run_time],
        :file_path => test.metadata[:file_path],
        :line_number => test.metadata[:line_number],
        :description => test.metadata[:full_description] }

      #{ :started_at => example.metadata[:execution_result][:started_at].to_i,
      #  :finished_at => example.metadata[:execution_result][:finished_at].to_i,
      #  :run_time => example.metadata[:execution_result][:run_time],
      #  :file_path => example.metadata[:file_path],
      #  :line_number => example.metadata[:line_number],
      #  :description => example.metadata[:full_description] }
    end
  end
end