# frozen_string_literal: true

require './shot'

class Frame
  STRIKE = 10

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def strike?
    @first_shot == STRIKE
  end

  def spare?
    @first_shot != STRIKE && [@first_shot, @second_shot].sum == 10
  end
end
