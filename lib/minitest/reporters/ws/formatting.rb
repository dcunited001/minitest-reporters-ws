module Minitest::Reporters::Ws
  module Formatting
    INFO_PADDING = 8

    def get_description(runner, test)
      "#{test.suite}: <b>#{test.test}</b>"
    end

    def print_time(test)
      total_time = Time.now - (runner.test_start_time || Time.now)
      " (%.2fs)" % total_time
    end

    def print_info(e)
      e.message.each_line { |line|  print_with_info_padding(line) }

      trace = filter_backtrace(e.backtrace)
      trace.each { |line| print_with_info_padding(line) }
    end

    # TODO: fix printing

    def print_pass(suite, test, test_runner)
      unless @client.connected?
        # do nothing
      end
    end

    def print_skip(suite, test, test_runner)
      puts @emoji['S'] + yellow { " SKIP #{suite}" }
      puts yellow { "  #{print_time(test)} #{test}" }
      puts print_info(test_runner.exception) unless @client.connected?
    end

    def print_fail(suite, test, test_runner)
      puts @emoji['F'] + red { " FAIL #{suite}" }
      puts red { "  #{print_time(test)} #{test}" }
      puts print_info(test_runner.exception) unless @client.connected?
    end

    def print_err(suite, test, test_runner)
      puts @emoji['E'] + red { " ERROR #{suite}" }
      puts red { "  #{print_time(test)} #{test}" }
      puts print_info(test_runner.exception) unless @client.connected?
    end

    def print_after_suite(suite)
      puts "#{@test_count} Tests - #{suite}"
      %w(P E F S).each do |status|
        print("#{@emoji[status]} => " + @emoji[status]*@results[status] + " #{@results[status]}")
        puts;
      end
      puts;
    end

    def print_after_suites
      puts "FINISHED - #{runner.test_count} tests ran"
      %w(P E F S).each do |status|
        print("#{@emoji[status]} => " + @emoji[status]*@suites_results[status] + " #{@suites_results[status]}")
        puts;
      end
    end

    def err_info(e)
      err = ""
      e.message.each_line { |line| err += "<p>#{line}</p>" }

      trace = filter_backtrace(e.backtrace)
      trace.each { |line| err += "<p>#{line}</p>" }

      err
    end

    def pad(str, size)
      ' ' * size + str
    end

    def print_with_info_padding(line)
      puts pad(line, INFO_PADDING)
    end
  end
end

