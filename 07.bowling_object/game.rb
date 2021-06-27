# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(input_text)
    build_frames(input_text)
  end

  def calculate_score
    [base_score_with_bonus_score_for_last_frame, bonus_score_without_bonus_score_of_last_frame].sum
  end

  private

  def base_score_with_bonus_score_for_last_frame
    @scores_for_each_frame.flatten.sum
  end

  def bonus_score_without_bonus_score_of_last_frame
    bonus = 0
    @frames.each_with_index do |shots, index|
      following_pinfalls = @scores_for_each_frame[index.succ..].flatten
      if shots.strike?
        bonus += following_pinfalls[0..1].sum
      elsif index < 9 && shots.spare?
        bonus += following_pinfalls[0]
      end
    end
    bonus
  end

  def build_frames(pinfall_text)
    @scores_for_each_frame = []
    frame = []
    Frame.pinfalls(pinfall_text).map do |shot|
      frame << shot
      if frame.count == 2 || frame.count == 1 && shot == 10 || @scores_for_each_frame[9]
        @scores_for_each_frame << frame
        frame = []
      end
    end
    @scores_for_each_frame = [*@scores_for_each_frame[0..8], [*@scores_for_each_frame[9], *@scores_for_each_frame[10], *@scores_for_each_frame[11]]]
    @frames = @scores_for_each_frame.map { |shots| Frame.new(*shots) }
  end
end
