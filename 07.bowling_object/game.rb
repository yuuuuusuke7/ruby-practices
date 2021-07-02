# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(input_text)
    @frames = build_frames(input_text)
  end

  def calculate_score
    [base_score_with_bonus_score_for_last_frame, bonus_score_without_bonus_score_of_last_frame].sum
  end

  private

  def base_score_with_bonus_score_for_last_frame
    @frames.map(&:shots).flatten.map(&:score).sum
  end

  def bonus_score_without_bonus_score_of_last_frame
    bonus = 0
    @frames.each_with_index do |shots, index|
      following_frames = @frames[index.succ..]
      following_pinfalls = following_frames.map(&:shots).flatten.map(&:score)
      if shots.strike?
        bonus += following_pinfalls[0..1].sum
      elsif index < 9 && shots.spare?
        bonus += following_pinfalls[0]
      end
    end
    bonus
  end

  def build_frames(pinfall_text)
    shots = pinfall_text.split(',').map { |pinfall| Shot.new(pinfall) }

    10.times.map do |index|
      if index == 9
        Frame.new(*shots)
      else
        first_shot = shots.shift
        frame = Frame.new(first_shot)
        frame.strike? ? frame : Frame.new(first_shot, shots.shift)
      end
    end
  end
end
