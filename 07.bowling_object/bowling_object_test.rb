# frozen_string_literal: true

require './bowling_object'
require 'minitest/autorun'

class BowlingTest < Minitest::Test
  def test_short
    assert_equal 10, Shot.new('X').score
    assert_equal 7, Shot.new(7).score
    assert_equal 0, Shot.new(0).score
  end

  def test_calc_first
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').calculate_score
  end

  def test_calc_second
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').calculate_score
  end

  def test_calc_third
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').calculate_score
  end

  def test_calc_zero
    assert_equal 0, Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0').calculate_score
  end

  def test_calc_perfect
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').calculate_score
  end
end
