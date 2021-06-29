# frozen_string_literal: true

require './shot'

class Frame
  STRIKE = 10

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
  end

  def strike?
    @first_shot.score == STRIKE
  end

  def spare?
    @first_shot.score != STRIKE && [@first_shot.score, @second_shot.score].sum == 10
  end

  class << self
    def pinfalls(pinfall_text)
      pinfall_text.split(',').map { |pinfall| Shot.new(pinfall).score }
    end

    def build_score_text(pinfall_text)
      scores_for_each_frame = []
      frame = []
      Frame.pinfalls(pinfall_text).map do |shot|
        frame << shot
        if frame.count == 2 || frame.count == 1 && shot == 10 || scores_for_each_frame[9]
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
