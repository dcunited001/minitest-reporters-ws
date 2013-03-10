module Minitest::Reporters::Ws
  module Messages

    def messages
      { start_new_iteration: { receiver: "web", method: "startNewIteration" },
        add_to_passing: { receiver: "web", method: "addToPassing" },
        add_to_pending: { receiver: "web", method: "addToPending" },
        add_to_erring: { receiver: "web", method: "addToFailing" },
        add_to_failing: { receiver: "web", method: "addToFailing" } }
    end

    def start_new_iteration(test_count = 420)
      client.send_msg(messages[:start_new_iteration].merge arguments: [@timestamp, test_count])
    end

    def add_to_passing(test)
      client.send_msg(prep_result(test, :add_to_passing))
    end

    def add_to_pending(test)
      client.send_msg(prep_result(test, :add_to_pending))
    end

    def add_to_failing(test)
      client.send_msg(prep_result(test, :add_to_failing))
    end

    def add_to_erring(test)
      # for now, treating erring the same as failing
      client.send_msg(prep_result(test, :add_to_erring))
    end

    private

    def prep_result(test, key)
      test_data = example_to_hash(test)
      messages[key].merge arguments: [@timestamp, test_data]
    end

    # TODO: fix formatting

    def example_to_hash(meta)
      # the runner is the Minitest::Runner
      #   which Minitest::Reporter modifies to work

      m = meta[:metadata]
      t = meta[:test]
      r = meta[:runner]

      ex = t.exception ? err_info(t.exception) : nil
      desc = get_description(r,t)
      #desc += ex if ex

      # TODO: format times
      { framework: :minitest,
        started_at: r.test_start_time,
        finished_at: Time.now,  # convert to_i? & add? @timestamp + t.time
        run_time: t.time,
        file_path: "/mock/me/some/data",   # not in minitest_reporters?
        line_number: 9876,                 # not in minitest_reporters?
        assertions: t.assertions,
        exception: ex || '',
        description: desc }

    end
  end
end
