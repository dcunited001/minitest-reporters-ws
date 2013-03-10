module Minitest::Reporters::Ws
  # A reporter based on rspec-web by RyanScottLewis
  #
  # @see https://github.com/RyanScottLewis/rspec-web
  class Reporter
    include ::Minitest::Reporter
    include ::ANSI::Code
    include Formatting
    include Messages

    EMOJI = {
      'P' => "\u{1F49A} ",  # heart
      'E' => "\u{1f525} ",  # flame
      'F' => "\u{1f4a9} ",  # poop
      'S' => "\u{1f37a} " } # beer

    attr_accessor :timestamp
    attr_accessor :client
    attr_accessor :metadata

    # MUTEX on MiniTest::ReporterRunner?

    def initialize(opts = {})
      @emoji = EMOJI.merge(opts.fetch(:emoji, {}))

      init_counts
      init_suite_counts
      init_client
      set_timestamp
    end

    def init_client
      conf = ::Minitest::Reporters::Ws::Client::DEFAULT_CONFIG
      find_or_create_client(conf)
    end

    # MINITEST HOOKS

    def before_suites(suite, type)
      set_metadata
      start_new_iteration(metadata[:test_count])
      init_suite_counts
      @client.identify
    end

    def after_suites(suites, type)
      print_after_suites
      @client.close
    end

    def before_suite(suite)
      init_counts
    end

    def after_suite(suite)
      if @test_count > 1
        @suites_results.each_key { |k| @suites_results[k] += @results[k] }
        print_after_suite(suite)
      end
    end

    def before_test(suite,test)
      #FIX_FOR_ZEUS!! (which seems to want to run tests twice)
      #  on the second run,
      #    these are still nil,
      #    for some reason
      #  oh i wish i knew why!
      @test_count ||= 0
      @suite_test_count ||= 0
    end

    def after_test(suite,test)
      @test_count += 1
      @suite_test_count += 1
    end

    # MINITEST PASS/FAIL/ERROR/SKIP

    def pass(suite, test, test_runner)
      @results['P'] += 1
      #print_pass(suite,test,runner)
      add_to_passing(to_metadata(runner, test_runner))
    end

    def skip(suite, test, test_runner)
      @results['S'] += 1
      #print_skip(suite,test,runner)
      add_to_pending(to_metadata(runner, test_runner))
    end

    def failure(suite, test, test_runner)
      @results['F'] += 1
      #print_fail(suite,test,runner)
      add_to_failing(to_metadata(runner, test_runner))
    end

    def error(suite, test, test_runner)
      @results['E'] += 1
      #print_err(suite,test,runner)
      add_to_erring(to_metadata(runner, test_runner))
    end

    # wanted this to be defined as a module accessor,
    #   so zeus will create the initial client
    #   when it initially loads up the minitest_helper
    # then subsequent test runs will use the same client

    def global_client
      ::Minitest::Reporters::Ws.class_variable_get("@@client")
    end

    def global_client=(c)
      ::Minitest::Reporters::Ws.class_variable_set("@@client", c) unless global_client?
    end

    def global_client?
      ::Minitest::Reporters::Ws.class_variable_defined?("@@client")
    end

    def find_or_create_client(config = {})
      @client = if global_client?
        global_client
      else
        ::Minitest::Reporters::Ws::Client.new(config: config)
      end
    end

    private

    def unit_runner
      ::Minitest::Unit.runner
    end

    def set_metadata
      @metadata = {
        test_options: unit_runner.options,
        test_count: unit_runner.test_count,
        #replace @timestamp?
        #start_time: unit_runner.suites_start_time.to_i
      }

      # updated after tests run
      #[runner.test_count,
      # runner.assertion_count,
      # runner.failures,
      # runner.errors,
      # runner.skips]
    end

    def set_timestamp
      @timestamp = Time.now.to_i
    end

    def init_count_hash
      { 'P' => 0,
        'E' => 0,
        'F' => 0,
        'S' => 0 }
    end

    def init_suite_counts
      @suites_test_count = 0
      @suites_results = init_count_hash
    end

    def init_counts
      @test_count = 0
      @results = init_count_hash
    end

    def to_metadata(runner, test_runner = nil)
      { minitest: metadata,
        test: test_runner,
        runner: runner }
    end
  end
end
