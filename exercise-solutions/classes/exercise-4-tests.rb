#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---
require 'test/unit'
require 'exercise-4'

class CounterTests < Test::Unit::TestCase

  def setup
    Counter.reset
  end

  def test_Counter_counts
    assert_equal(0, Counter.count)
    Counter.counted_new
    assert_equal(1, Counter.count)
    Counter.counted_new
    assert_equal(2, Counter.count)
  end


  def test_birth_order
    assert_equal(1, Counter.counted_new.birth_order)
    # Test another one, just for luck.
    assert_equal(2, Counter.counted_new.birth_order)
  end

  
end
