require 'test_helper'
require_relative '../lib/greeting'

class GreetingTest < MiniTest::Test
  def test_no_username_provided
    greeting = Greeting.greet(nil)
    assert_equal greeting, nil
  end

  def test_successful_greeting
    username = "@samsymons"
    greeting = Greeting.greet username

    assert greeting.end_with?("<@#{username}>" + "!")
  end
end
