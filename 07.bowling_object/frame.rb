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

  class << self
    def build_score_text(pinfall_text)
      shots = pinfall_text.split(',').map { |pinfall| Shot.new(pinfall) }

      scores_for_each_frame = []
      frame = []
      shots.each do |shot|
        frame << shot.score
        if frame.count == 2 || frame.count == 1 && shot.score == 10 || scores_for_each_frame[9]
          scores_for_each_frame << frame
          frame = []
        end
      end
      scores_for_each_frame = [*scores_for_each_frame[0..8], [*scores_for_each_frame[9], *scores_for_each_frame[10], *scores_for_each_frame[11]]]
    end

    def build_frames(pinfall_text)
      @frames = build_score_text(pinfall_text).map { |shots| Frame.new(*shots) }
    end
  end
end
