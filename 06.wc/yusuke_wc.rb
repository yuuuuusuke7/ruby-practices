# frozen_string_literal: true

require 'optparse'

def count_line(file_read)
  file_read.count("\n")
end

def count_words(file_read)
  file_read.split(/\s+/).size
end

def count_byte(file_read)
  file_read.bytesize
end

def wc_command_items(file_name)
  file_read = File.read(file_name)
  wc_command_items = []
  wc_command_items << count_line(file_read)
  wc_command_items << count_words(file_read)
  wc_command_items << count_byte(file_read)
  wc_command_items
end

def print_wc_command(file_name)
  wc_command_items(file_name).map { |wc_command_item| print wc_command_item.to_s.rjust(8) }
  print " #{file_name} \n"
end

def wc_command_opt_l_items(file_name)
  file_read = File.read(file_name)
  wc_command_count_line = []
  wc_command_count_line << count_line(file_read)
  wc_command_count_line
end

def print_wc_command_opt_l(file_name)
  wc_command_opt_l_items(file_name).map { |wc_command_opt_l_item| print wc_command_opt_l_item.to_s.rjust(8) }
  print " #{file_name} \n"
end

def print_stdin
  row_lines = $stdin.readlines
  stdin_items = [row_lines.length, row_lines.to_s.split(/\s+/).size, row_lines.join.chars.size]
  stdin_items.map { |stdin_item| print stdin_item.to_s.rjust(8) }
  print "\n"
end

options = {}
OptionParser.new do |opt|
  opt.on('-l') { |l| options[:l] = l }
  opt.parse!(ARGV)
end

if ARGV.empty?
  print_stdin
elsif options[:l]
  ARGV.each do |file_name|
    print_wc_command_opt_l(file_name)
  end
else
  ARGV.each do |file_name|
    print_wc_command(file_name)
  end
end

if ARGV.size > 1 && options[:l]
  wc_command_opt_l_item_list = ARGV.map do |file_name|
    wc_command_opt_l_items(file_name)
  end
  wc_command_opt_l_item_total = wc_command_opt_l_item_list.transpose.map(&:sum)
  wc_command_opt_l_item_total.each { |transpose_count_line_file| print transpose_count_line_file.to_s.rjust(8) }
  print " total \n"
elsif ARGV.size > 1
  wc_command_item_list = ARGV.map do |file_name|
    wc_command_items(file_name)
  end
  wc_command_item_total = wc_command_item_list.transpose.map(&:sum)
  wc_command_item_total.each { |same_wc_command_item| print same_wc_command_item.to_s.rjust(8) }
  print " total \n"
end
