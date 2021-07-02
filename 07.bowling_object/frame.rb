# frozen_string_literal: true

require './shot'

class Frame
  STRIKE = 10
  attr_writer :bonus_shots

  def initialize(first_shot, second_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @bonus_shots = []
  end

  def strike?
    @first_shot.score == STRIKE
  end

  def spare?
    @first_shot.score != STRIKE && [@first_shot.score, @second_shot.score].sum == 10
  end

  def base_score
    (self.strike? || self.spare?) ? STRIKE : @first_shot.score + @second_shot&.score || 0
  end

  def bonus_score
    @bonus_shots.map(&:score).sum
  end

  class << self
    def build_frames(pinfall_text)
      shots = pinfall_text.split(',').map { |pinfall| Shot.new(pinfall) }

      10.times.map do |index|
        first_shot = shots.shift
        frame = Frame.new(first_shot)
        if frame.strike?
          frame.bonus_shots = shots[0, 2]
        else
          second_shot = shots.shift
          frame = Frame.new(first_shot, second_shot)
          if frame.spare?
            frame.bonus_shots = shots[0, 1]
          end
        end
        frame
      end
    end
  end
end
