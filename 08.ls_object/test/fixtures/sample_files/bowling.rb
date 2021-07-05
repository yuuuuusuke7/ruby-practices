# frozen_string_literal: true

score = ARGV[0]
# ターミナルから引数を取得
scores = score.split('').map { |shot| shot == 'X' ? 10 : shot.to_i }
# スコアをの要素(倒れた本数)を1つずつ分けて整数で返すようにする
frames = []
frame = []

scores.each do |shot|
  frame << shot
  if frame.count == 1 && frame.first == 10 || frame.count == 2 || frames[9]
    frames << frame
    frame = []
  end
end

frames = [*frames[0..8], [*frames[9], *frames[10], *frames[11]]]

base_score = frames.flatten.sum

bonus_score = 0
frames.each_with_index do |shot, index|
  following_pinfalls = frames[index.succ..].flatten
  if shot[0] == 10
    bonus_score += following_pinfalls[0..1].sum
  elsif shot.sum == 10 && shot[0] != 10
    bonus_score += following_pinfalls[0]
  end
end

puts base_score + bonus_score
