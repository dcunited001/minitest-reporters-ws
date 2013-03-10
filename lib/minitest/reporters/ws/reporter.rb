module Minitest::Reporters::Ws
  # A reporter based on rspec-web by RyanScottLewis
  #
  # @see https://github.com/RyanScottLewis/rspec-web
  class Reporter
    include ::Minitest::Reporter

    EMOJI = {
        'P' => "\u{1F49A} ", # heart
        'E' => "\u{1f525} ", # flame
        'F' => "\u{1f4a9} ", # poop
        'S' => "\u{1f37a} "  # beer
    }

    def initialize(opts = {})
      @emoji = EMOJI.merge(opts.fetch(:emoji, {}))

      init_counts
      init_suite_counts
    end

    def init_client
     client = ::Minitest::Reporter::Ws::Client.new(config: client_config) unless client
    end

    def init_suite_counts
      @suites_test_count = 0
      @suites_results = {
          'P' => 0,
          'E' => 0,
          'F' => 0,
          'S' => 0 }
    end

    def init_counts
      @test_count = 0
      @results = {
          'P' => 0,
          'E' => 0,
          'F' => 0,
          'S' => 0 }
    end

    def before_suites(suite, type)
      init_suite_counts
    end

    def after_suites(suites, type)
      puts "FINISHED - #{@suites_test_count} tests ran"
      %w(P E F S).each do |status|
        print("#{@emoji[status]} => " + @emoji[status]*@suites_results[status] + " #{@suites_results[status]}")
        puts;
      end
    end

    def before_suite(suite)
      init_counts
    end

    def after_suite(suite)
      if @test_count > 1
        @suites_results.each_key { |k| @suites_results[k] += @results[k] }

        puts "#{@test_count} Tests - #{suite}"
        %w(P E F S).each do |status|
          print("#{@emoji[status]} => " + @emoji[status]*@results[status] + " #{@results[status]}")
          puts;
        end
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

    def pass(suite, test, test_runner)
      @results['P'] += 1
    end

    def skip(suite, test, test_runner)
      @results['S'] += 1
      puts; print(@emoji['S'] + yellow { pad_mark("#{print_time(test)} SKIP") } )
      puts; print(yellow { pad_mark(suite) } )
      puts; print(yellow { pad_mark(test) } )
    end

    def failure(suite,test,test_runner)
      @results['F'] += 1
      puts; print(@emoji['F'] + red { pad_mark("#{print_time(test)} FAIL") } )
      puts; print(red { pad_mark(suite) } )
      puts; print(red { pad_mark(test) } )
      puts; print_info(test_runner.exception)
    end

    def error(suite,test,test_runner)
      @results['E'] += 1
      puts; print(@emoji['E'] + red { pad_mark("#{print_time(test)} ERROR") } )
      puts; print(red { pad_mark(suite) } )
      puts; print(red { pad_mark(test) } )
      puts; print_info(test_runner.exception)
    end

    def client
      ::Minitest::Reporter::Ws.class_variable_get("@@client")
    end

    private

    def client?
      ::Minitest::Reporter::Ws.class_variable_defined?("@@client")
    end

    def client=(c)
      ::Minitest::Reporter::Ws.class_variable_set("@@client", )
    end

    def print_time(test)
      total_time = Time.now - (runner.test_start_time || Time.now)
      " (%.2fs)" % total_time
    end

    def print_info(e)
      e.message.each_line { |line| print_with_info_padding(line) }

      trace = filter_backtrace(e.backtrace)
      trace.each { |line| print_with_info_padding(line) }
    end
  end
end
