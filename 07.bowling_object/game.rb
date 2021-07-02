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
    @frames.map(&:bonus_score).sum
  end
end
