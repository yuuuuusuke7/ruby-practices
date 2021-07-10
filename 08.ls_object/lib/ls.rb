# frozen_string_literal: true

require 'etc'
require 'pathname'

MAX_FILENAME_COUNT = 21 # 横幅の文字最大21文字に設定

FILE_TYPES = {
  file: '-',
  directory: 'd',
  characterSpecial: 'c',
  blockSpecial: 'b',
  fifo: 'p',
  link: 'l',
  socket: 's',
  unknown: ' '
}.freeze

FILE_MODES = {
  "7" => "rwx",
  "6" => "rw-",
  "5" => "r-x",
  "4" => "r--",
  "3" => "-wx",
  "2" => "-w-",
  "1" => "--x",
  "0" => "---"
}.freeze

class LsCommandExecution
  def initialize(filenames, width, long_format: false, reverse: false, dot_match: false)
    @filenames = filenames
    @width = width
    @long_format = long_format
    @reverse = reverse
    @dot_match = dot_match
  end

  def run_ls
    @filenames = @dot_match ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
    @filenames = @reverse ? @filenames.reverse : @filenames
    @long_format ? LsLongFormat.new(@filenames).ls_long_format_display : LsShortFormat.new(@filenames, @width).ls_short_format_display
  end
end

class LsLongFormat < LsCommandExecution
  def initialize(filenames)
    @filenames = filenames
  end

  def ls_long_format_display
    row_data = @filenames.map do |filename|
      stat = File.stat(filename)
      build_data(filename, stat)
    end
    total = "total #{total_blocks(@filenames)}"
    body = render_long_format_body(row_data)
    [total, *body].join("\n")
  end

  def build_data(filename, stat)
    {
      type: type(filename),
      mode: mode(stat),
      nlink: hard_link(stat),
      user: file_user(stat),
      group: file_group(stat),
      size: file_size(stat),
      mtime: mtime(stat),
      filename: filename
    }
  end

  def render_long_format_body(row_data)
    max_size = %i[nlink user group size].map do |key|
      find_max_size(row_data, key)
    end
    row_data.map do |data|
      format_row(data, *max_size)
    end
  end

  def find_max_size(row_data, key)
    row_data.map {|data| data[key].size}.max
  end

  def format_row(data, max_nlink, max_user, max_group, max_size)
    [
      "#{data[:type]}",
      "#{data[:mode]}",
      "  #{data[:nlink].rjust(max_nlink)}",
      " #{data[:user].ljust(max_user)}",
      "  #{data[:group].ljust(max_group)}",
      "  #{data[:size].rjust(max_size)}",
      "#{data[:mtime]}",
      "#{data[:filename]}"
    ].join
  end

  def total_blocks(filenames)
    total_blocks = 0
    filenames.map { |file| total_blocks += File.stat(file).blocks }
    total_blocks
  end

  def type(file_name)
    type = File.ftype(file_name).to_sym
    FILE_TYPES[type]
  end

  def mode(file_stat)
    mode = file_stat.mode.to_s(8)
    file_mode = -3.upto(-1).map do |n|
      FILE_MODES[mode[n]]
    end
    file_mode.join
  end

  def hard_link(file_stat)
    file_stat.nlink.to_s
  end

  def file_user(file_stat)
    Etc.getpwuid(file_stat.uid).name
  end

  def file_group(file_stat)
    Etc.getgrgid(file_stat.gid).name
  end

  def file_size(file_stat)
    file_stat.size.to_s
  end

  def mtime(file_stat)
    file_stat.mtime.strftime("  %-m %e %H:%M ")
  end
end

# MAX_FILENAME_COUNT = 21
class LsShortFormat < LsCommandExecution
  def initialize(filenames, width)
    super
  end

  def ls_short_format_display
    transposed_file_names = safe_transpose(@filenames.each_slice(row_count(@filenames, @width)).to_a)
    format_table(transposed_file_names)
  end

  def columns(width)
    width / MAX_FILENAME_COUNT
  end

  def row_count(filenames, width)
    (filenames.count.to_f / columns(width)).ceil
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
