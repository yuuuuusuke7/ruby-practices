# frozen_string_literal: true

class LsCommandExecution
  def initialize(filenames, long_format: false, reverse: false, dot_match: false)
    @filenames = filenames
    @long_format = long_format
    @reverse = reverse
    @dot_match = dot_match
  end

  def run_ls
    @filenames = @dot_match ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
    @filenames = @reverse ? @filenames.reverse : @filenames
    @long_format ? LsLongFormat.new(@filenames).ls_long_format_display : LsShortFormat.new(@filenames).ls_short_format_display
  end
end
