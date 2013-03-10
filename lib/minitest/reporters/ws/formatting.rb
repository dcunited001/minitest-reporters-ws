module Minitest::Reporters::Ws
  module Formatting
    def get_description(runner, test)
      "#{test.suite}: <b>#{test.test}</b>"
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

    # TODO: fix printing

    def print_pass(suite, test, test_runner)
      # do nothing
    end

    def print_skip(suite, test, test_runner)
      #puts; print(@emoji['S'] + yellow { pad_mark("#{print_time(test)} SKIP") } )
      #puts; print(yellow { pad_mark(suite) } )
      #puts; print(yellow { pad_mark(test) } )
    end

    def print_fail(suite, test, test_runner)
      #puts; print(@emoji['F'] + red { pad_mark("#{print_time(test)} FAIL") } )
      #puts; print(red { pad_mark(suite) } )
      #puts; print(red { pad_mark(test) } )
      #puts; print_info(test_runner.exception)
    end

    def print_err(suite, test, test_runner)
      #puts; print(@emoji['E'] + red { pad_mark("#{print_time(test)} ERROR") } )
      #puts; print(red { pad_mark(suite) } )
      #puts; print(red { pad_mark(test) } )
      #puts; print_info(test_runner.exception)
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
  end
end

