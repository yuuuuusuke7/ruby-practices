# frozen_string_literal: true

class Game
  attr_reader :input_text

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

class Frame
  STRIKE = 10
  attr_reader :first_shot, :second_shot, :third_shot

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
  end
end

class Shot
  def initialize(pinfall)
    @pinfall = pinfall
  end

  def score
    @pinfall == 'X' ? 10 : @pinfall.to_i
  end
end

puts Game.new(ARGV[0]).calculate_score
