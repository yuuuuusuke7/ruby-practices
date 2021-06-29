# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(input_text)
    @frames = Frame.build_frames(input_text)
    @score_text = Frame.build_score_text(input_text)
  end

  def calculate_score
    [base_score_with_bonus_score_for_last_frame, bonus_score_without_bonus_score_of_last_frame].sum
  end

  private

  def base_score_with_bonus_score_for_last_frame
    @score_text.flatten.sum
  end

  def bonus_score_without_bonus_score_of_last_frame
    bonus = 0
    @frames.each_with_index do |shots, index|
      following_pinfalls = @score_text[index.succ..].flatten
      if shots.strike?
        bonus += following_pinfalls[0..1].sum
      elsif index < 9 && shots.spare?
        bonus += following_pinfalls[0]
      end
    end
    bonus
  end
end
