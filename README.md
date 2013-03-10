Minitest::Reporters::Ws
=======================

The Minitest Formatter is working, but I need to work with the
sinatra app to change the formatting of the results.

> If you want to use it with Zeus, check out that branch

### Minitest Websocket Reporter

> ala https://github.com/RyanScottLewis/rspec-web

Add this to test/support/minitest_reporters.rb:

```ruby
# may want to skip this for CI!
require "minitest/reporters"
require 'minitest/reporters/ws'
emoji = {
    'P' => "\u{1F49A} ", # heart
    'E' => "\u{1f525} ", # flame
    'F' => "\u{1f4a9} ", # poop
    'S' => "\u{1f37a} "} # beer

Minitest::Reporters.use! Minitest::Reporters::Ws::Reporter.new(emoji: emoji)
```

To run tests:

```shell
bundle install --binstubs
rspec-web
guard
# [enter]
```

