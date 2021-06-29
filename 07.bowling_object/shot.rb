# frozen_string_literal: true

class Shot
  def initialize(pinfall)
    @pinfall = pinfall
  end

  def score
    @pinfall == 'X' ? 10 : @pinfall.to_i
  end

  class << self
    def pinfalls(pinfall_text)
      pinfall_text.split(',').map { |pinfall| Shot.new(pinfall).score }
    end
  end
end
