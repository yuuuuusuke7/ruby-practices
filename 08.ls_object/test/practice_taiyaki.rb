# frozen_string_literal: true

require 'minitest/autorun'
require 'date'

class Taiyaki
  attr_reader :anko, :size, :produced_on

  def initialize(anko, size)
    @anko = anko
    @size = size
    @produced_on = Date.today
  end

  def to_s
    "あんこ：#{anko}, サイズ：#{size}, 値段：#{price}円"
  end

  def price
    amount = 100
    if anko == '白あん'
      amount += 30
    elsif size == '大きめ'
      amount += 50
    end
    amount
  end

  def expired_on
    produced_on + 3
  end

  def expired?(today = Date.today)
    expired_on < today
  end
end

class TaiyakiTest < Minitest::Test
  def test_taiyaki
    taiyaki_first = Taiyaki.new('あずき', 'ふつう')
    assert_equal 'あずき', taiyaki_first.anko
    assert_equal 'ふつう', taiyaki_first.size
    assert_equal 100, taiyaki_first.price
    assert_equal 'あんこ：あずき, サイズ：ふつう, 値段：100円', taiyaki_1.to_s

    taiyaki_second = Taiyaki.new('白あん", "大きめ')
    assert_equal '白あん', taiyaki_second.anko
    assert_equal '大きめ', taiyaki_second.size
    assert_equal 180, taiyaki_second.price
    assert_equal 'あんこ：白あん, サイズ：大きめ, 値段：180円', taiyaki_2.to_s
  end

  def test_ezpired
    taiyaki = Taiyaki.new('あずき', 'ふつう')
    assert_equal Date.today, taiyaki.produced_on
    assert_equal (Date.today + 3), taiyaki.expired_on
    refute taiyaki.expired?
    refute taiyaki.expired?(Date.today + 3)
    assert taiyaki.expired?(Date.today + 4)
  end
end
