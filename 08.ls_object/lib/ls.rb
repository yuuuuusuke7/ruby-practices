# frozen_string_literal: true

require 'etc'
require 'pathname'
MAX_FILENAME_COUNT = 21

def run_ls(pathname, width: 80, long_format: false, reverse: false, dot_match: false)
  filenames = dot_match ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
  filenames = reverse ? filenames.reverse : filenames
  ls_short_format(filenames, width: 80)
end

def ls_long_format(filenames)
  'Hi'
end

# MAX_FILENAME_COUNT = 21
def ls_short_format(filenames, width: 80)
  transposed_file_names = safe_transpose(filenames.each_slice(row_count(filenames, width: 80)).to_a)
  format_table(transposed_file_names)
end

def columns(width: 80)
  width / MAX_FILENAME_COUNT
end

def row_count(filenames, width: 80)
  (filenames.count.to_f / columns(width: 80)).ceil
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
