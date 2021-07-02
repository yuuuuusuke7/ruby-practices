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
    @first_shot.score == STRIKE
  end

  def spare?
    @first_shot.score != STRIKE && [@first_shot.score, @second_shot.score].sum == 10
  end

  def shots
    [@first_shot, @second_shot, @third_shot].compact
  end

  def base_score
    (self.strike? || self.spare?) ? STRIKE : shots.map(&:score).sum
  end
end
