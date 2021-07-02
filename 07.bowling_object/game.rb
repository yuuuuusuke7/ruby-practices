# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(input_text)
    @frames = Frame.build_frames(input_text)
  end

  def calculate_score
    [base_score, bonus_score].sum
  end

  private

  def base_score
    @frames.map(&:base_score).sum
  end

  def bonus_score
    shots = @frames.map(&:shots).flatten
    shot_count = 0
    @frames.each.sum do |frame|

      if frame.strike?
        shot_count += 1
        shots[shot_count, 2].map(&:score).sum
      elsif frame.spare?
        shot_count += 2
        shots[shot_count].score
      else
        shot_count += 2
        0
      end
    end
  end
end
