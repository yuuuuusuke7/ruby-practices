# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(input_text)
    create_frame(input_text)
  end

  def calculate_score
    [base_score, bonus_score].sum
  end

  private

  def base_score
    @frames.flatten.sum
  end

  def bonus_score
    bonus = 0
    @frame_instance.each_with_index do |shots, index|
      following_pinfalls = @frames[index.succ..].flatten
      if shots.strike?
        bonus += following_pinfalls[0..1].sum
      elsif index < 9 && shots.spare?
        bonus += following_pinfalls[0]
      end
    end
    bonus
  end

  def create_frame(pinfall_text)
    @frames = []
    frame = []
    Frame.pinfalls(pinfall_text).map do |shot|
      frame << shot
      if frame.count == 2 || frame.count == 1 && shot == 10 || @frames[9]
        @frames << frame
        frame = []
      end
    end
    @frames = [*@frames[0..8], [*@frames[9], *@frames[10], *@frames[11]]]
    @frame_instance = @frames.map { |shots| Frame.new(*shots) }
  end
end
