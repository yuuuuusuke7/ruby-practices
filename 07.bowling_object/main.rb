# frozen_string_literal: true

require './game'

puts Game.new(ARGV[0]).calculate_score
