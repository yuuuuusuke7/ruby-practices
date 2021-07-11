# frozen_string_literal: true

WIDTH = 80 # widthを80に固定
MAX_FILENAME_COUNT = 21 # 横幅の文字最大21文字に設定

class LsShortFormat < LsCommandExecution

  def ls_short_format_display
    transposed_file_names = safe_transpose(@filenames.each_slice(row_count).to_a)
    format_table(transposed_file_names)
  end

  private

  def columns
    WIDTH / MAX_FILENAME_COUNT
  end

  def row_count
    (@filenames.count.to_f / columns).ceil
  end

  def safe_transpose(filenames)
    first, *rest = filenames
    first.zip(*rest)
  end

  def format_table(filenames)
    filenames.map do |row_files|
      row_files.map { |filename| filename.to_s.ljust(MAX_FILENAME_COUNT) }.join.rstrip
    end.join("\n")
  end
end
