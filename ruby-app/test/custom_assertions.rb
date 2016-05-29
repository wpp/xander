require 'minitest/assertions'

module MiniTest::Assertions
  def assert_response(expected, actual)
    split_expected = remove_greeting(expected)
    split_actual = remove_greeting(actual)

    assert_equal split_expected.last, split_actual.last
  end

  private

  def remove_greeting(message)
    greeting = message.partition '! '
    return greeting
  end
end
